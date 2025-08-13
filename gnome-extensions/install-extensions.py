#!/usr/bin/env python3

import json
import subprocess
import sys

BACKUP_FILE = sys.argv[1] if len(sys.argv) > 1 else "./extension-list.json"

with open(BACKUP_FILE) as f:
    data = json.load(f)

for ext in data:
    uuid = ext.get("uuid")
    if uuid:
        print(f"Installing {uuid}")
        subprocess.run(["gext", "install", uuid])