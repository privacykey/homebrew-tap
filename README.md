# privacykey/homebrew-tap

Homebrew tap for [privacykey](https://github.com/privacykey) macOS apps and tools.

## Install

```sh
brew tap privacykey/tap
```

Or, in a single command:

```sh
brew install --cask privacykey/tap/privacycommand
```

## Available packages

### Casks

| Cask | Description |
| --- | --- |
| [`privacycommand`](Casks/privacycommand.rb) | Inspect app bundles for privacy and security findings |
| [`privacytracker`](Casks/privacytracker.rb) | Monitor, track, and get alerted when iOS apps change their privacy labels |

### Formulae

| Formula | Description |
| --- | --- |
| [`mantis`](Formula/mantis.rb) | Command-line client for Mantis — manage keys and watch hits from the terminal |

## Updating

```sh
brew update
brew upgrade
```

## How updates land here

Every cask and formula in this tap is owned by its app's repository, and
version bumps arrive as pull requests — nothing is pushed to `main` directly:

1. An app repo (e.g. [privacytracker](https://github.com/privacykey/privacytracker),
   [mantis](https://github.com/privacykey/mantis)) publishes a release.
2. That repo's release workflow rewrites the cask/formula here (new `version`
   and `sha256`) and opens a PR against this tap. It authenticates with a
   `HOMEBREW_TAP_TOKEN` repo secret: a fine-grained personal access token
   scoped to **this repository only**, with Contents and Pull requests
   read & write.
3. The [PR checks workflow](.github/workflows/pr-checks.yml) runs
   `brew style` and a Ruby syntax check over `Casks/` and `Formula/`.
4. A maintainer reviews and merges. Merging to `main` is what publishes the
   update to tap users.

Files marked `AUTO-GENERATED` are templated inside the app repo's release
workflow — change the template there rather than hand-editing here, or the
edit will be overwritten on the next release. Everything else (new casks,
style fixes, metadata) follows the same route: branch, PR, review, merge.

## Uninstall

```sh
brew uninstall --cask privacycommand
brew untap privacykey/tap
```

## License

[MIT](LICENSE)
