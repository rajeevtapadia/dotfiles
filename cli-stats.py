import os
import re
import subprocess
import shlex
from collections import Counter

class HistoryEntry:
    def __init__(self, command, timestamp=None, exit_code=None):
        self.command = command
        self.timestamp = timestamp
        self.exit_code = exit_code

    def __repr__(self):
        meta = []
        if self.timestamp:
            meta.append(f"ts={self.timestamp}")
        if self.exit_code is not None:
            meta.append(f"code={self.exit_code}")
        meta_str = f" ({', '.join(meta)})" if meta else ""
        return f"<HistoryEntry: {self.command}{meta_str}>"


class ShellHistory:
    def __init__(self):
        self.shell = self._detect_shell()
        self.aliases = self._load_aliases()
        self.raw_entries = self._load_history()
        self.entries = self._parse_entries(self.raw_entries)
        self.processed_entries = self._resolve_entries(self.entries)

    def _detect_shell(self):
        shell = os.environ.get("SHELL", "")
        return os.path.basename(shell) if shell else None

    def _history_file(self):
        home = os.path.expanduser("~")
        candidates = {
            "bash": ".bash_history",
            "zsh": ".zsh_history",
            "sh": ".sh_history"
        }
        if self.shell in candidates:
            return os.path.join(home, candidates[self.shell])
        for fname in candidates.values():
            path = os.path.join(home, fname)
            if os.path.exists(path):
                return path
        return None

    def _load_history(self):
        path = self._history_file()
        if not path or not os.path.exists(path):
            return []
        with open(path, "r", errors="ignore") as f:
            return [line.strip() for line in f if line.strip()]

    def _parse_entries(self, raw_entries):
        parsed = []
        if self.shell == "zsh":
            for entry in raw_entries:
                match = re.match(r"^: (\d+):(\d+);(.*)", entry)
                if match:
                    ts, code, cmd = match.groups()
                    parsed.append(HistoryEntry(cmd.strip(), int(ts), int(code)))
                else:
                    parsed.append(HistoryEntry(entry))
        else:
            parsed = [HistoryEntry(entry) for entry in raw_entries]
        return parsed

    def _load_aliases(self):
        """Return a dict of aliases by calling `alias` in the shell."""
        try:
            result = subprocess.run(
                [self.shell, "-i", "-c", "alias"],
                capture_output=True, text=True
            )
            aliases = {}
            for line in result.stdout.splitlines():
                if "=" not in line:
                    continue
                if line.startswith("alias "):
                    line = line[6:]
                name, value = line.split("=", 1)
                name = name.strip()
                value = value.strip().strip("'").strip('"')
                aliases[name] = value
            return aliases
        except Exception as e:
            print(f"Failed to load aliases: {e}")
            return {}

    def _resolve_command(self, cmd):
        """Resolve aliases + strip sudo for a single command string."""
        try:
            parts = shlex.split(cmd)
        except ValueError:
            parts = cmd.strip().split()

        if not parts:
            return cmd

        # strip sudo
        if parts[0] == "sudo":
            parts = parts[1:]
            if not parts:
                return ""

        # resolve alias (first word only)
        if parts and parts[0] in self.aliases:
            try:
                expansion = shlex.split(self.aliases[parts[0]])
            except ValueError:
                expansion = self.aliases[parts[0]].split()
            parts = expansion + parts[1:]

        return " ".join(parts)

    def _resolve_entries(self, entries):
        resolved = []
        for e in entries:
            resolved_cmd = self._resolve_command(e.command)
            resolved.append(
                HistoryEntry(resolved_cmd, e.timestamp, e.exit_code)
            )
        return resolved

    def last(self, n=10, processed=True):
        entries = self.processed_entries if processed else self.entries
        return entries[-n:]

    def all(self, processed=True):
        return self.processed_entries if processed else self.entries

    def count(self):
        return len(self.entries)
    def command_counts(self, processed=True, top=None):
        entries = self.processed_entries if processed else self.entries
        commands = [e.command.split()[0] for e in entries if e.command.strip()]
        counter = Counter(commands)
        sorted_counts = sorted(counter.items(), key=lambda x: x[1], reverse=True)
        if top:
            sorted_counts = sorted_counts[:top]
        return [(count, cmd) for cmd, count in sorted_counts]


if __name__ == "__main__":
    history = ShellHistory()
    print(f"Detected shell: {history.shell}")
    print(f"Loaded {history.count()} entries")
    print(f"Aliases loaded: {len(history.aliases)}")

    print("\nTop 20 commands:")
    for count, cmd in history.command_counts(top=20):
        print(f"{count} - {cmd}")
