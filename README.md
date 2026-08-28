# CAU26

This repository hosts the tutorials I led during the [Causality in biomedicine: going beyond associations](https://www.ebi.ac.uk/training/events/causality-in-biomedicine-2026/) course at EMBL-EBI during the 4 – 9 October 2026.

## Tutorials Requirements

You will need:

- [Git](https://git-scm.com/install/)
- [Docker](https://docs.docker.com/engine/install/)
- The 1000 GP data which can be downloaded [here](https://drive.google.com/file/d/10qVlGHDOAyrffQKQZHK1FIfDCQJ5KPY6/view?usp=drive_link) and decompressed with `tar -xzf cau26_data.tar.gz`. However, future availability is not guaranteed, it can be regenerated (see "Developer Side" below).

### Statistical Genetics : A Causal Inference Perspective

Assuming the downloaded data is in `cau26_data` (from your current directory), launch the notebook server with:

```bash
docker run \
--platform linux/amd64 \
-p 1234:1234 \
-v $PWD/cau26_data:/workspaces/CAU26/kgp \
olivierlabayle/cau26:latest \
julia --project=. --startup-file=no -t auto -e 'import Pluto; Pluto.run(host="0.0.0.0", port=1234, launch_browser=false, sysimage="pluto_sys.so")'
```

Then go to the displayed adress in your brower and open the `statistical_genetics.jl` notebook.

### Reproducible Research Software and Data

In your terminal, run:

```bash
git clone https://github.com/olivierlabayle/CAU26.git && git switch reproducible_research_1
```

## Developer Side

- Building the Docker image:

```bash
docker build -f .devcontainer/Dockerfile -t olivierlabayle/cau26 --target prod .
```

- Devevopment Environment

Relies on dev containers, typically used with vs code.

- Download the 1000 Genome Project data

```bash
./download_KGP.sh
```

- Running the notebook in the dev container:

```bash
julia --project --startup-file=no -t auto -e 'import Pluto; Pluto.run(require_secret_for_access=false)'
```

## Limitations

- Currently variants are generated in a Markov chain which means that the current intervention method in the nonlinear model section is not really accurate but is probbaly enough for the purpose of this tutorial.
- Results between the dev and prod environment seem to vary but not sure why