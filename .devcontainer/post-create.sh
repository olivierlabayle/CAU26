#!/usr/bin/env bash
set -euo pipefail

echo "Instantiating Julia project..."
julia --project=/workspaces/CAU26 -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

echo "Post-create setup complete."