import shutil
import subprocess
import sys
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import yaml

_, CONFIG_FILE = sys.argv

with open(CONFIG_FILE, "r") as f:
    config = yaml.safe_load(f)

B = config["B"]
SEED = config["SEED"]
DATA_FILE = config["DATA_FILE"]
OUTPUT_FILE = config["OUTPUT_FILE"]

rng = np.random.default_rng(SEED)

# 1. Read the input data.
df = pd.read_csv(DATA_FILE)

# 2. Run a randomised bootstrap analysis.
groups = df["group"].unique()
results = {}

for group in groups:
    values = df.loc[df["group"] == group, "value"].to_numpy()

    # Random resampling with replacement.
    bootstrap_means = np.array([
        rng.choice(values, size=len(values), replace=True).mean()
        for _ in range(B)
    ])

    results[group] = {
        "mean": values.mean(),
        "ci_low": np.percentile(bootstrap_means, 2.5),
        "ci_high": np.percentile(bootstrap_means, 97.5),
    }

# 4. Create a plot.
labels = list(results)
means = [results[g]["mean"] for g in labels]
lower_errors = [results[g]["mean"] - results[g]["ci_low"] for g in labels]
upper_errors = [results[g]["ci_high"] - results[g]["mean"] for g in labels]

fig, ax = plt.subplots(figsize=(6, 4))
ax.errorbar(
    labels,
    means,
    yerr=[lower_errors, upper_errors],
    fmt="o",
    capsize=6,
)
ax.set_ylabel("Value")
ax.set_title(f"Bootstrap mean and 95% CI (seed={SEED})")
ax.grid(axis="y", alpha=0.3)
fig.tight_layout()
fig.savefig(OUTPUT_FILE, dpi=150)

print(f"\nAnalysis complete.")
print(f"Plot written to: {OUTPUT_FILE}")
for group, result in results.items():
    print(
        f"{group}: mean={result['mean']:.3f}, "
        f"95% CI=({result['ci_low']:.3f}, {result['ci_high']:.3f})"
    )
