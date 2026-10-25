#!/bin/bash
# Emit the Authorization header for the HuggingFace MCP server, sourcing the
# token from the hf CLI's stored login. No secret is written to config.
printf '{"Authorization":"Bearer %s"}' "$(hf auth token -q)"
