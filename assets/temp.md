- ATE Definition

md"""
```math
ATE_{Y, V} = \begin{cases}
      \mathbb{E}[Y(V=TT)] - \mathbb{E}[Y(TA)] \\
      \mathbb{E}[Y(V=TA)] - \mathbb{E}[Y(AA)]
    \end{cases}    
```
"""

- What is the definition of the ATE in this model? What assumption does it make compared to the initial definition we discussed?

The ATE is alpha

- Can you compute it exactly? Yes

- Is the ATE correctly recovered by the estimator? Yes

- Does it matter whether PC1 and PC2 are adjusted for in this case? What do you conclude? PC1 and PC2 are not strongly ocnfounding the effect of this variant.

- Linear model on non-linear dataset

- What is the ATE? Can you compute it? Not exactly but can be approximated by MC.

linear_results = lm(@formula(Y ~ V1 + V2 + PC1 + PC2 + SEX), nonlinear_dataset)
linear_effect = coef(linear_results)[2]
linear_confint = confint(linear_results)[2, :]

- Do you think this will work? Talk about double robustness.


- tmle 0 -> 1

ATE_0_to_1 = ATE(
  outcome=:Y, 
  treatment_values=(V1=(case=1, control=0),),
  treatment_confounders=(:PC1, :PC2, :V2),
  outcome_extra_covariates=(:SEX,)
)
# Estimate it on the datset
tmle_ATE_0_to_1, _ = tmle(ATE_0_to_1, nonlinear_dataset, verbosity=0)
# We extract the point estimate and confidence interval for plotting
tmle_ATE_0_to_1_effect = estimate(tmle_ATE_0_to_1)
tmle_ATE_0_to_1_confint = confint(significance_test(tmle_ATE_0_to_1))

tmle_ATE_0_to_1

- Positivity

combine(groupby(nonlinear_dataset, [:V1, :V2]), nrow, proprow)

- Stack:

models_stack = default_models(
  G = G_stack, 
  Q_continuous = Q_simple_stack
)
tmle_stack = Tmle(models=models_stack)
tmle_stack_ATE_0_to_1, _ = tmle_stack(ATE_0_to_1, nonlinear_dataset, verbosity=0)
# We extract the point estimate and confidence interval for plotting
tmle_stack_ATE_0_to_1_effect = estimate(tmle_stack_ATE_0_to_1)
tmle_stack_ATE_0_to_1_confint = confint(significance_test(tmle_stack_ATE_0_to_1))

tmle_stack_ATE_0_to_1

- Interaction Ground truth

ground_truths.AIE_V1_V2

- Interaction estimate

factorialEstimand(AIE, [:V1, :V2], :Y; 
	confounders = [:PC1, :PC2], 
	dataset = nonlinear_dataset,
	outcome_extra_covariates=(:SEX,)
)