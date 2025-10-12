# /// script
# requires-python = ">=3.14"
# dependencies = [
#   "icecream",
# ]
# ///
from collections import Counter
from pathlib import Path
from typing import BinaryIO

from icecream import ic

# Usage:
#   :!uv run scripts_stats.py --script
#
# Format:
#   :!uvx ruff format scripts_stats.py


def parse_history_gen(f: BinaryIO):
    """Remove zsh extended history timestamp
    b': 1739424127:0;zoxide init'\\n  ->  zoxide init
    """
    for line in f:  # note that empty lines have no semicolon
        if cmd := line.partition(b";")[2].strip(b"'\r\n"):
            try:
                yield cmd.decode("utf-8")  # ..., errors="replace"
            except UnicodeDecodeError:  # skip unreadable lines
                pass


def run_main() -> None:
    home_path = Path.home()  # -> /home/user
    scripts_path = home_path / ".local" / "scripts"  # -> /home/user/.local/scripts

    scripts: set[str] = {path.stem for path in scripts_path.iterdir() if path.is_file()}

    with open(home_path / ".zsh_history", "rb") as f:  # -> /home/user/.zsh_history
        cmds = parse_history_gen(f)
        cmds = (Path(parts[0]).resolve().stem for cmd in cmds if (parts := cmd.split()))  # fmt: skip
        counts = Counter(name for name in cmds if name in scripts)

    for script, count in counts.most_common(30):
        ic(script, count)


def main() -> None:
    run_main()


if __name__ == "__main__":
    main()

"""
ic| script: 'pomo', count: 179
ic| script: 'tmux-sessionizer', count: 120
ic| script: 'keep', count: 94
ic| script: 'newvhs', count: 54
ic| script: 'bloat', count: 51
ic| script: 'bf', count: 26
ic| script: 'gshfzf', count: 23
ic| script: 'fzfclip', count: 20
ic| script: 'asm', count: 9
ic| script: 'pdf', count: 7
ic| script: 'smake', count: 6
ic| script: 'rand64', count: 5
ic| script: 'notify-date', count: 3
ic| script: 'dumpgcc', count: 2
ic| script: 'jqfzf', count: 2
ic| script: 'debugbreak', count: 1
ic| script: 'kr', count: 1
ic| script: 'notify-battery', count: 1
"""

"""
# NeoVim Mappings

## K

- Nvim LSP client defaults |lsp-defaults|
  - K |K-lsp-default|

## `gf`

- /usr/lib/python3.10/pathlib.py
- /home/user/.local/share/nvim-kickstart/mason/packages/basedpyright/venv/lib/python3.10/site-packages/basedpyright/dist/typeshed-fallback/stdlib

"""

"""
cat ~/.zsh_history | sed 's/^: [0-9]*:[0-9]*;//' | grep '/' | awk '{print $1}' | sort | uniq -c | sort -nr | head -20

history 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head "$1"

zsh-histdb:
  ```sql
  SELECT command, COUNT(*) as count
  FROM history
  GROUP BY command
  ORDER BY count DESC
  LIMIT 20;
  ```

"""
