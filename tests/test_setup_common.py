"""Unit tests for helper functions in setup_common.sh.

Author: Matthew Edwards
Date: August 2019
"""

from pathlib import Path
import pexpect

import pytest


def assert_bash(command, input=None, returncode=0, timeout=5):
    """Assert a bash command succeeds and return its output.

    The command is run in the root dotfiles directory.  Escape any double quotes.

    Args:
        command: Single command, or list of commands to run sequentially
        input: Characters to send into command's stdin
        returncode: Assert the command returns this valu
        timeout: Throw pexpect.TIMEOUT if it takes long than this many seconds
    """
    cwd = Path(__file__).parent.parent
    if type(command) != str:
        command = '; '.join(command)
    command = f"bash -c \"{command}\""
    print(command)
    p = pexpect.spawn(command, cwd=cwd, timeout=timeout, echo=False, encoding="utf-8")
    if input:
        p.send(input)
    output = p.read()
    p.close()
    assert p.exitstatus == returncode, "Command failed, output: " + output
    return output


def test_prompt():
    """Test basic prompt."""
    commands = [
        "source ./setup_common.sh",
        "prompt 'What is your name?' >/dev/null",
        # Deeply nested double quotes
        # https://stackoverflow.com/a/28786747
        "printf \"\\\"\"$prompt_result\"\\\""
    ]

    output = assert_bash(commands, input="test\n")
    assert output == "test"

    output = assert_bash(commands, input="\n")
    assert output == ""

    commands[1] += " </dev/null"
    output = assert_bash(commands)
    assert output == ""


def test_prompt_with_default():
    """Test prompt with default value."""
    commands = [
        "source ./setup_common.sh",
        "prompt 'What is your name?' Matthew >/dev/null",
        "printf $prompt_result"
    ]

    output = assert_bash(commands, input="test\n")
    assert output == "test"

    output = assert_bash(commands, input="\n")
    assert output == "Matthew"

    commands[1] += " </dev/null"
    output = assert_bash(commands)
    assert output == "Matthew"


def test_prompt_with_output_var():
    """Test prompt with default value and output variable."""
    commands = [
        "source ./setup_common.sh",
        "prompt 'What is your name?' Matthew name >/dev/null",
        "printf $name"
    ]

    output = assert_bash(commands, input="test\n")
    assert output == "test"

    output = assert_bash(commands, input="\n")
    assert output == "Matthew"

    commands[1] += " </dev/null"
    output = assert_bash(commands)
    assert output == "Matthew"


def test_prompt_reads_whole_line():
    """Test prompt doesn't return if it doesn't get a newline."""
    prompt = "source ./setup_common.sh; prompt 'What is your name?'"
    with pytest.raises(pexpect.TIMEOUT):
        assert_bash(prompt, input="test", timeout=0.1)


def test_yesno():
    """Test yesno return value."""
    yesno = "source ./setup_common.sh; yesno 'Do the thing?'"
    # Yes
    assert_bash(yesno, input="y", returncode=0)
    assert_bash(yesno, input="Y", returncode=0)
    # No
    assert_bash(yesno, input="n", returncode=1)
    assert_bash(yesno, input="n", returncode=1)
    # Any other character
    assert_bash(yesno, input="x", returncode=1)
    # Enter
    assert_bash(yesno, input="\n", returncode=0)
    # No input
    assert_bash(f"{yesno} </dev/null", returncode=0)


def test_noyes():
    """Test noyes return value."""
    noyes = "source ./setup_common.sh; noyes 'Do the thing?'"
    # Yes
    assert_bash(noyes, input="y", returncode=0)
    assert_bash(noyes, input="Y", returncode=0)
    # No
    assert_bash(noyes, input="n", returncode=1)
    assert_bash(noyes, input="n", returncode=1)
    # Any other character
    assert_bash(noyes, input="x", returncode=1)
    # Enter
    assert_bash(noyes, input="\n", returncode=1)
    # No input
    assert_bash(f"{noyes} </dev/null", returncode=1)
