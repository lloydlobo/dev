# /// script
# requires-python = ">=3.14"
# dependencies = [
#   "rich",
# ]
# ///
from collections import Counter
from pathlib import Path
from typing import BinaryIO

from rich.console import Console
from rich.table import Table


# Streaming	Line-by-line reading, safe for large files
def parse_history_gen(f: BinaryIO):
    """Remove zsh extended history timestamp (b': 1739424127:0;zoxide init'\\n  ->  zoxide init)"""
    for line in f:  # note that empty lines have no semicolon
        if cmd := line.partition(b";")[2].strip(b"'\r\n"):
            try:
                yield cmd.decode("utf-8")  # ..., errors="replace"
            except UnicodeDecodeError:
                pass  # skip unreadable lines


def main() -> None:
    home = Path.home()  # -> /home/user
    scripts_dir = home / ".local" / "scripts"
    history_path = home / ".zsh_history"

    scripts: set[str] = {p.stem for p in scripts_dir.iterdir() if p.is_file()}
    with history_path.open("rb") as f:
        commands = parse_history_gen(f)
        commands = (
            Path(part).stem for c in commands if (part := c.split(maxsplit=1)[0])
        )
        counts = Counter(name for name in command_names if name in scripts)

    table = Table(title="Script Usage Stats", show_lines=False)
    table.add_column("Rank", justify="right", style="cyan")
    table.add_column("Script", style="green")
    table.add_column("Count", justify="right", style="magenta")

    for rank, (script, count) in enumerate(counts.most_common(30), 1):
        table.add_row(str(rank), script, str(count))

    Console().print(table)


if __name__ == "__main__":
    main()

"""
Format:
  :!uvx ruff format scripts_stats.py

Usage:
  :!uv run scripts_stats.py --script

        Script Usage Stats
┏━━━━━━┳━━━━━━━━━━━━━━━━━━┳━━━━━━━┓
┃ Rank ┃ Script           ┃ Count ┃
┡━━━━━━╇━━━━━━━━━━━━━━━━━━╇━━━━━━━┩
│    1 │ pomo             │   179 │
│    2 │ tmux-sessionizer │   120 │
│    3 │ keep             │    94 │
│    4 │ newvhs           │    54 │
│    5 │ bloat            │    51 │
│    6 │ bf               │    26 │
│    7 │ gshfzf           │    23 │
│    8 │ fzfclip          │    20 │
│    9 │ asm              │     9 │
│   10 │ pdf              │     7 │
│   11 │ smake            │     6 │
│   12 │ rand64           │     5 │
│   13 │ notify-date      │     3 │
│   14 │ dumpgcc          │     2 │
│   15 │ jqfzf            │     2 │
│   16 │ debugbreak       │     1 │
│   17 │ kr               │     1 │
│   18 │ notify-battery   │     1 │
└──────┴──────────────────┴───────┘
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
