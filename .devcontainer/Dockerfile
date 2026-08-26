FROM debian:trixie AS dev

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    ca-certificates \
    wget \
    libssl-dev \
    libblas-dev \
    liblapack-dev \
    libopenblas-dev \
    libffi-dev \
    zlib1g-dev \
    unzip \
    procps \
    clang \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install PLINK2
RUN wget https://s3.amazonaws.com/plink2-assets/alpha7/plink2_linux_avx2_20260805.zip \
    && unzip plink2_linux_avx2_20260805.zip \
    && mv plink2 /usr/local/bin \
    && chmod +x /usr/local/bin/plink2

# Install Julia
ENV JULIAUP_DEPOT_PATH="/opt/julia/depot"

ENV JULIA_DEPOT_PATH="/opt/julia/depot"

ENV PATH="/opt/julia/bin:$PATH"

RUN curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel 1.12 --path /opt/julia

RUN julia -e 'using Pkg; Pkg.add("Revise")' && \
    mkdir -p "$JULIA_DEPOT_PATH/config" && \
    cat > "$JULIA_DEPOT_PATH/config/startup.jl" <<'EOF'
try
    using Revise
catch
end
EOF

FROM dev AS prod

COPY . /workspaces/CAU26

WORKDIR /workspaces/CAU26

RUN julia --project=. -e 'using Pkg; Pkg.instantiate()'

RUN julia --project=. create_sysimage.jl