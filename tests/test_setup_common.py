"""Unit tests for helper functions in setup_common.sh.

Author: Matthew Edwards
Date: August 2019
"""

from pathlib import Path
import pexpect

import pytest


def run_bash(command, input_=None, return_value=0, timeout: float = 5):
    """Run a command in bash, check it's return value, and return its stdout.

    The command is run in the root dotfiles directory.

    Escape any double quotes.

    Args:
        command: Single command, or list of commands to run sequentially
        input_: Characters to send into command's stdin
        return_value: Assert the command returns this value
        timeout: Throw pexpect.TIMEOUT if it takes longer than this many seconds
    """
    cwd = Path(__file__).parent.parent
    if type(command) != str:
        command = "; ".join(command)
    command = f'bash -c "{command}"'
    print(command)
    p = pexpect.spawn(command, cwd=cwd, timeout=timeout, echo=False, encoding="utf-8")
    if input_:
        p.send(input_)
    output = p.read()
    p.close()
    assert p.exitstatus == return_value, "Command failed, output: " + output
    return output


PROMPT_SCRIPT = [
    "source ./setup_common.sh",
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
    commands[1] += " </dev/null"
    output = run_bash(commands)
    assert output == ""


PROMPT_SCRIPT2 = [
    "source ./setup_common.sh",
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
    commands[1] += " </dev/null"
    output = run_bash(commands)
    assert output == "Matthew"


PROMPT_SCRIPT3 = [
    "source ./setup_common.sh",
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
    commands[1] += " </dev/null"
    output = run_bash(commands)
    assert output == "Matthew"


def test_prompt_reads_whole_line():
    """Test prompt doesn't return if it doesn't get a newline."""
    prompt = "source ./setup_common.sh; prompt 'What is your name?'"
    with pytest.raises(pexpect.TIMEOUT):
        run_bash(prompt, input_="test", timeout=0.1)


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
    command = "source ./setup_common.sh; yesno 'Do the thing?'"
    run_bash(command, input_=input_, return_value=return_value)


def test_yesno_no_stdin():
    """Test yesno returns yes with no input."""
    command = "source ./setup_common.sh; yesno 'Do the thing?' </dev/null"
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
    command = "source ./setup_common.sh; noyes 'Do the thing?'"
    run_bash(command, input_=input_, return_value=return_value)


def test_noyes_no_stdin():
    """Test noyes returns no with no input."""
    command = "source ./setup_common.sh; noyes 'Do the thing?' </dev/null"
    run_bash(command, return_value=1)
