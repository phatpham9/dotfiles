# tofu-ls

Local Claude Code LSP plugin for the OpenTofu language server.

- Server: `tofu-ls serve`
- Extensions: `.tf`, `.tofu`, `.tfvars`
- Language IDs: `opentofu`, `opentofu-vars`

The marketplace entry in `../.claude-plugin/marketplace.json` declares the LSP
server, so this directory intentionally has no `plugin.json`.

`apps/cli/install.sh` installs the binary from the upstream GitHub Releases
archive into `~/.local/bin`, verifying the published SHA-256 checksum. The
release's `go.mod` uses replace directives, so `go install` does not work for
this project.
