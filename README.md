# CAU26

This repository hosts the tutorials I led during the [Causality in biomedicine: going beyond associations](https://www.ebi.ac.uk/training/events/causality-in-biomedicine-2026/) course at EMBL-EBI during the 4 – 9 October 2026.

## Statistical Genetics : A Causal Inference Perspective

```bash
docker run -it olivierlabayle/cau26:main julia --sysimage=pluto_sys.so --project=. --startup-file=no -t auto -e 'import Pluto; Pluto.run(require_secret_for_access=false)'
```

## Setup

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
julia --project --startup-file=no -t auto -e 'import Pluto; Pluto.run(require_secret_for_access=false)'
```

## Todo


- Currently variants are generated in a Markov chain which means that the current intervention method in the nonlinear model section is not really accurate => Use TMLE.jl copula approach to generate variants
- Understand where potential random seed is not faithful