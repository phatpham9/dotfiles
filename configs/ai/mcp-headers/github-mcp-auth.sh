#!/bin/bash
# Emit the Authorization header for the GitHub MCP server, sourcing the token
# from the gh CLI (stored in the macOS keyring). No secret is written to config.
printf '{"Authorization":"Bearer %s"}' "$(gh auth token)"
