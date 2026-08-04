# CAU26

Practicals for Causality in biomedicine: going beyond associations.

# Setup

1. Install Julia

```bash
curl -fsSL https://install.julialang.org | sh
```

2. Setup the environment

```bash
julia --project --startup-file=no -t auto -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
```

3. Download the 1000 Genome Project data

```bash
./download_KGP.sh
```

4. Run the notebook server

```bash
julia --project --startup-file=no -t auto -e 'import Pluto; Pluto.run()'
```