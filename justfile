# Checks for this chezmoi source repo. `just check` before every commit.

cz := "mise x chezmoi@latest -- chezmoi --source " + justfile_directory()
stylua := env("HOME") / ".local/share/nvim/mason/bin/stylua"

# Render every template for both profiles and OSes, lint the scripts, parse the JSON.
check:
    #!/usr/bin/env bash
    set -euo pipefail
    out=$(mktemp -d); trap 'rm -rf "$out"' EXIT
    for prof in full light; do for os in linux darwin; do
      data="{\"profile\":\"$prof\",\"chezmoi\":{\"os\":\"$os\"}}"
      {{cz}} execute-template --init --promptChoice profile="$prof" < .chezmoi.toml.tmpl > /dev/null
      find . -name '*.tmpl' -not -name '.chezmoi.toml.tmpl' -not -path './.git/*' -not -path './.claude/*' | while read -r t; do
        r="$out/$prof-$os/${t#./}"; mkdir -p "$(dirname "$r")"
        {{cz}} execute-template --override-data "$data" < "$t" > "$r" || { echo "render failed: $t ($prof, $os)"; exit 1; }
        case $t in ./run_*.sh.tmpl) if [ -s "$r" ]; then shellcheck -S warning -s sh "$r"; fi ;; esac
      done
    done; done
    grep -l '^#!/bin/sh' dot_local/bin/executable_* | xargs shellcheck -S warning
    python3 -m py_compile dot_local/bin/executable_raycast-export && rm -rf dot_local/bin/__pycache__
    for f in dot_zshrc.tmpl dot_zshenv.tmpl; do zsh -n "$out/full-linux/$f"; done
    find . -name '*.json' -not -path './.git/*' -not -path './.claude/*' -print0 | xargs -0 -n1 jq empty
    {{stylua}} --check dot_config/nvim
    if [ -d raycast/devserver/node_modules ]; then (cd raycast/devserver && npx tsc --noEmit); fi
    echo "check: ok"

# Format the Neovim Lua.
fmt:
    {{stylua}} dot_config/nvim
