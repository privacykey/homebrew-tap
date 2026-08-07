# List available commands
default:
    @just --list

# Syntax-check casks and formulae, then run brew style if available
[group("dev")]
lint:
    ruby -c Casks/*.rb Formula/*.rb
    if command -v brew >/dev/null; then brew style Casks Formula; fi
