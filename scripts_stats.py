# /// script
# requires-python = ">=3.14"
# dependencies = [
#   "pandas",
#   "rich",
#   "icecream",
# ]
# ///

import argparse  # /home/user/.local/share/nvim-kickstart/mason/packages/basedpyright/venv/lib/python3.10/site-packages/basedpyright/dist/typeshed-fallback/stdlib/argparse.pyi
import sys  # /home/user/.local/share/nvim-kickstart/mason/packages/basedpyright/venv/lib/python3.10/site-packages/basedpyright/dist/typeshed-fallback/stdlib/sys/__init__.pyi
from collections import Counter
from pathlib import Path
from typing import BinaryIO

import pandas as pd
from icecream import ic
from rich import print as rprint
from rich.console import Console
from rich.table import Table


# Streaming	Line-by-line reading, safe for large files
def parse_history_gen(f: BinaryIO):
    """
    Generator that yields shell commands from zsh history.

    Removes zsh extended history timestamps, e.g.:
        b': 1739424127:0;zoxide init' -> 'zoxide init'
    """
    for line in f:  # note that empty lines have no semicolon
        _, _, part = line.partition(b";")  # if not part: continue
        if cmd := part.strip(b"'\r\n"):  # skip empty or malformed lines
            # NOTE: Could also use errors="replace" in decode() to avoid
            #       skipping these `try/except` lines entirely
            try:
                yield cmd.decode("utf-8")  # ..., errors="replace"
            except UnicodeDecodeError:
                continue  # skip unreadable lines


def run_plugin_dataframe() -> None:
    limit = 20

    home = Path.home()  # -> /home/user
    scripts_dir = home / ".local" / "scripts"
    history_path = home / ".zsh_history"

    scripts: set[str] = {p.stem for p in scripts_dir.iterdir() if p.is_file()}

    with history_path.open("rb") as f:
        commands = parse_history_gen(f)  # lazy generator

        df = pd.DataFrame({"raw": commands})
        df["cmd"] = df["raw"].str.split().str[0]
        df = df[df["cmd"].isin(scripts)]

        counts = df["cmd"].value_counts().head(limit).reset_index()
        counts.columns = ["script", "count"]

    console = Console()
    console.print(counts) -- KISS; dataframes are good enough


def run_plugin_counter() -> None:
    limit = 20

    home = Path.home()  # -> /home/user
    scripts_dir = home / ".local" / "scripts"
    history_path = home / ".zsh_history"

    scripts: set[str] = {p.stem for p in scripts_dir.iterdir() if p.is_file()}

    with history_path.open("rb") as f:
        commands = parse_history_gen(f)  # lazy generator

        commands = (
            Path(part).stem
            for c in commands
            if (parts := c.split(maxsplit=1)) and (part := parts[0])
        )
        counts = Counter(name for name in commands if name in scripts)

    table = Table(title="Script Usage Stats", show_lines=False)
    table.add_column("Rank", justify="right", style="cyan")
    table.add_column("Script", style="green")
    table.add_column("Count", justify="right", style="magenta")

    for rank, (script, count) in enumerate(counts.most_common(limit), start=1):
        table.add_row(str(rank), script, str(count))

    console = Console()
    Console().print(table)


def main():
    parser = argparse.ArgumentParser( description="Analyze local script usage from zsh history.")
    parser.add_argument(
        "--mode",
        choices=["dataframe", "counter"],
        default="dataframe",
        help="Choose implementation mode: pandas dataframe or Counter",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=20,
        help="Number of top scripts to display",
    )
    args = parser.parse_args()
    """
        $ uv run --script scripts_stats.py --help
        usage: scripts_stats.py [-h] [--mode {dataframe,counter}] [--limit LIMIT]

        Analyze local script usage from zsh history.

        options:
          -h, --help            show this help message and exit
          --mode {dataframe,counter}
                                Choose implementation mode: pandas dataframe or Counter
          --limit LIMIT         Number of top scripts to display
    """

    match args.mode:
        case "counter":
            run_plugin_counter()
        case _:  # default catch all case
            run_plugin_dataframe()


if __name__ == "__main__":
    main()

"""
Usage:
  uv run --script scripts_stats.py --mode=counter
  uv run --script scripts_stats.py --mode=dataframe

Formatting:
  uvx ruff format scripts_stats.py
  uvx isort scripts_stats.py
"""

"""
$ uv run /home/user/Personal/dev/scripts_stats.py --mode=dataframe
  script  count
0   keep      6
1     tw      2
"""

"""
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
