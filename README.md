# CAU26

This repository hosts the tutorials I led during the [Causality in biomedicine: going beyond associations](https://www.ebi.ac.uk/training/events/causality-in-biomedicine-2026/) course at EMBL-EBI during the 4 – 9 October 2026.

# Setup

0. Install [plink2](https://www.cog-genomics.org/plink/2.0/)

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