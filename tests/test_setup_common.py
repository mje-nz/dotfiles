"""Unit tests for helper functions in setup_common.sh.

Author: Matthew Edwards
Date: August 2019
"""

from pathlib import Path
import pexpect

import pytest


def run_bash(command, input_=None, return_value=0, timeout: float = 0.5):
    """Run a command in bash, check it's return value, and return its stdout.

    The command is run with setup_common sourced.

    Escape any double quotes.

    Args:
        command: Single command, or list of commands to run sequentially
        input_: Characters to send into command's stdin
        return_value: Assert the command returns this value
        timeout: Throw pexpect.TIMEOUT if it takes longer than this many seconds
    """
    common_path = Path(__file__).parent.parent / "setup_common.sh"
    if type(command) != str:
        command = "; ".join(command)
    command = f"set -e; source {common_path}; {command}"
    command = f'bash -c "{command}"'
    print("Running", command)
    # TODO: why does this hang in the debugger, or crash with encoding specified?
    p = pexpect.spawn(command, timeout=timeout, echo=False)
    if input_:
        p.send(input_)
    try:
        output = p.read().decode("utf8")
    except pexpect.TIMEOUT:
        print("Before:\n", p.before.decode("utf8"))
        raise
    print(output)
    p.close()
    assert p.exitstatus == return_value, "Command failed, output: " + output
    return output


PROMPT_SCRIPT = [
    "prompt 'What is your name?' >/dev/null",
    # Deeply nested double quotes
    # https://stackoverflow.com/a/28786747
    'printf "\\""$prompt_result"\\"',
]


@pytest.mark.parametrize("input_,expected", (("test\n", "test"), ("\n", "")))
def test_prompt(input_, expected):
    """Test prompt helper returns input."""
    output = run_bash(PROMPT_SCRIPT, input_=input_)
    assert output == expected


def test_prompt_no_stdin():
    """Test prompt helper returns nothing with no stdin."""
    commands = [i for i in PROMPT_SCRIPT]
    commands[0] += " </dev/null"
    output = run_bash(commands)
    assert output == ""


PROMPT_SCRIPT2 = [
    "prompt 'What is your name?' Matthew >/dev/null",
    "printf $prompt_result",
]


@pytest.mark.parametrize("input_,expected", (("test\n", "test"), ("\n", "Matthew")))
def test_prompt_with_default(input_, expected):
    """Test prompt helper returns input or default value."""
    output = run_bash(PROMPT_SCRIPT2, input_=input_)
    assert output == expected


def test_prompt_with_default_no_stdin():
    """Test prompt helper returns default value with no stdin."""
    commands = [i for i in PROMPT_SCRIPT2]
    commands[0] += " </dev/null"
    output = run_bash(commands)
    assert output == "Matthew"


PROMPT_SCRIPT3 = [
    "prompt 'What is your name?' Matthew name >/dev/null",
    "printf $name",
]


@pytest.mark.parametrize("input_,expected", (("test\n", "test"), ("\n", "Matthew")))
def test_prompt_with_output_var(input_, expected):
    """Test prompt with default value and named output variable."""
    output = run_bash(PROMPT_SCRIPT3, input_=input_)
    assert output == expected


def test_prompt_with_default_no_stdin():
    """Test prompt helper returns default value with no stdin."""
    commands = [i for i in PROMPT_SCRIPT3]
    commands[0] += " </dev/null"
    output = run_bash(commands)
    assert output == "Matthew"


def test_prompt_reads_whole_line():
    """Test prompt doesn't return if it doesn't get a newline."""
    prompt = "prompt 'What is your name?'"
    with pytest.raises(pexpect.TIMEOUT):
        run_bash(prompt, input_="test")


@pytest.mark.parametrize(
    "input_,return_value",
    (
        # Yes
        ("y", 0),
        ("Y", 0),
        # No
        ("n", 1),
        ("N", 1),
        # Any other character
        ("x", 1),
        # Enter
        ("\n", 0),
    ),
)
def test_yesno(input_, return_value):
    """Test yesno return value."""
    command = "yesno 'Do the thing?'"
    run_bash(command, input_=input_, return_value=return_value)


def test_yesno_no_stdin():
    """Test yesno returns yes with no stdin."""
    command = "yesno 'Do the thing?' </dev/null"
    run_bash(command, return_value=0)


@pytest.mark.parametrize(
    "input_,return_value",
    (
        # Yes
        ("y", 0),
        ("Y", 0),
        # No
        ("n", 1),
        ("N", 1),
        # Any other character
        ("x", 1),
        # Enter
        ("\n", 1),
    ),
)
def test_noyes(input_, return_value):
    """Test noyes return value."""
    command = "noyes 'Do the thing?'"
    run_bash(command, input_=input_, return_value=return_value)


def test_noyes_no_stdin():
    """Test noyes returns no with no stdin."""
    command = "noyes 'Do the thing?' </dev/null"
    run_bash(command, return_value=1)


@pytest.fixture
def in_temp_dir(tmpdir):
    """Create a temporary directory and change to it for the duration of the test."""
    with tmpdir.as_cwd():
        yield Path(str(tmpdir))


@pytest.mark.parametrize(
    "dest,input_,expected",
    (
        # Should link file with no questions if the dest doesn't exist
        (None, "", "source"),
        # Should wait for input if the dest does exist
        ("dest", "", None),
        # Should link file for "overwrite", "backup", and the "all"s
        ("dest", "o", "source"),
        ("dest", "O", "source"),
        ("dest", "b", "source"),
        ("dest", "B", "source"),
        # Should do nothing for "skip", "skip all", or any other input
        ("dest", "s", "dest"),
        ("dest", "S", "dest"),
        ("dest", "x", "dest"),
    ),
)
def test_link_file(in_temp_dir, dest, input_, expected, src="source"):
    """Test link_file helper.

    Args:
        dest: initial content of dest file, or None for nonexistent
        input_: input to type
        expected: final content of dest file, or None for timeout
        src: content of source file
    """
    open("src", "w").write(src)
    if dest:
        open("dest", "w").write(dest)
    command = f"link_file src dest"
    kwargs = dict(command=command, input_=input_)

    if expected is not None:
        run_bash(**kwargs)
        assert open("dest").read() == expected
    else:
        with pytest.raises(pexpect.TIMEOUT):
            run_bash(**kwargs)


@pytest.mark.parametrize(
    "dest,input_,expected",
    (
        # Should link files with no questions if the dests don't exist
        (None, "", "source1,source2"),
        # Should wait for input if any dests do exist
        ("dest1,dest2", "", None),
        ("dest1,", "", None),
        (",dest2", "", None),
        # Should link files for "overwrite" and "backup"
        ("dest1,dest2", "oo", "source1,source2"),
        ("dest1,dest2", "bb", "source1,source2"),
        # Make sure it prompts twice
        ("dest1,dest2", "o", None),
        ("dest1,dest2", "b", None),
        # Should link files for "overwrite all" and "backup all", without asking again
        ("dest1,dest2", "O", "source1,source2"),
        ("dest1,dest2", "B", "source1,source2"),
        # Should do nothing for "skip" or any other input
        ("dest1,dest2", "ss", "dest1,dest2"),
        ("dest1,dest2", "sx", "dest1,dest2"),
        ("dest1,dest2", "xx", "dest1,dest2"),
        ("dest1,dest2", "os", "source1,dest2"),
        ("dest1,dest2", "so", "dest1,source2"),
        # Should do nothing and not prompt again for "skip all"
        ("dest1,dest2", "S", "dest1,dest2"),
    ),
)
def test_link_multiple_files(
    in_temp_dir, dest, input_, expected, src="source1,source2"
):
    """Test link_file helper with multiple files in one session.

    Args:
        dest: comma-separated initial content of dest files with empty strings for
            nonexistent, or None for all nonexistent
        input_: input to type
        expected: comma-separated final content of dest files, or None for timeout
        src: comma-separated content of source files
    """
    sources = src.split(",")
    src_paths = [f"src{i}" for i in range(len(sources))]
    dest_paths = [f"dest{i}" for i in range(len(sources))]
    for path, content in zip(src_paths, sources):
        open(path, "w").write(content)
    if dest is not None:
        for path, content in zip(dest_paths, dest.split(",")):
            open(path, "w").write(content)
    command = [
        f"link_file {src_path} {dest_path}"
        for src_path, dest_path in zip(src_paths, dest_paths)
    ]
    kwargs = dict(command=command, input_=input_)

    if expected is not None:
        run_bash(**kwargs)
        for path, content in zip(dest_paths, expected.split(",")):
            assert open(path).read() == content
    else:
        with pytest.raises(pexpect.TIMEOUT):
            run_bash(**kwargs)


@pytest.mark.parametrize(
    "dest,expected",
    (
        # Should link file with no questions if the dest doesn't exist
        (None, "source"),
        # Should skip if the dest does exist
        ("dest", "dest"),
    ),
)
def test_link_file_no_stdin(in_temp_dir, dest, expected, src="source"):
    """Test link_file helper skips with no stdin.

    Args:
        dest: initial content of dest file, or None for nonexistent
        expected: final content of dest file
        src: content of source file
    """
    open("src", "w").write(src)
    if dest:
        open("dest", "w").write(dest)

    run_bash("link_file src dest </dev/null")
    assert open("dest").read() == expected
