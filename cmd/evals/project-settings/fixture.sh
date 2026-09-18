#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj/.claude
cat > proj/.claude/settings.json <<MD
{
  "permissions": {
    "allow": ["Bash(npm test:*)"]
  },
  "hooks": {
    "SessionEnd": [
      { "hooks": [ { "type": "command", "command": "echo fremder-hook" } ] }
    ]
  }
}
MD
printf '{ "permissions": { "allow": ["Bash(ls:*)"] } }\n' > proj/.claude/settings.local.json
git init -q proj
