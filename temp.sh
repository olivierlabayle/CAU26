# plink2 --pfile kgp/KGP_merged \
#         --r-unphased square \
#         --chr 6 \
#         --from-bp 29000000 \
#         --to-bp 29100000 \
#         --out toto

plink2 --pfile kgp/KGP_merged.pruned \
        --r-unphased square \
        --chr 6 \
        --from-bp 29000000 \
        --to-bp 40000000 \
        --out /tmp/jl_zPPsrJ/6_29000000_29050000