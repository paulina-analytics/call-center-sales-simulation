# Project Assumptions

This project is a simulation inspired by real-life experience in a sales call center.
Processes and parameters were intentionally simplified to improve analytical clarity.
The goal is to compare routing strategies, not to predict real-world performance.

---

## Agent Costs

- Agent hourly cost represents the total company cost per productive hour.
- It includes salary, taxes, infrastructure, systems, and management overhead.
- Costs are modeled as averages and do not reflect individual compensation.
- Base scenario assumes an average cost of **45 PLN per hour**.

---

## Sales Targets & Incentives

- Daily operational targets are based on the number of signed agreements.
- Contract approval is not part of the daily target.
- Financial incentives are tied only to approved contracts.
- This creates a structural misalignment between short-term activity metrics and long-term business value.

---

## Credit Assessment

- Sales agents do not have access to customer credit scores.
- Credit approval is performed after agreement submission.
- Rejection is primarily driven by credit history and overall creditworthiness.
- This separation reflects common operational constraints in large organizations.

---

## Callbacks

- Customers requesting a callback have a significantly lower probability of finalizing a contract.
- Callbacks are modeled as low-conversion interactions rather than strictly non-converting.
- This simplification allows the model to focus on first-call routing decisions.

---

## AI vs Human Performance

- AI is modeled as a faster and cheaper channel with lower closing effectiveness.
- Human agents are slower and more expensive but better at converting high-value opportunities.
- Differences are expressed through relative performance, not absolute prediction.

---

## Limitations

- The model does not account for customer churn, lifetime value beyond contract duration, or learning effects.
- All results should be interpreted comparatively, not as absolute forecasts.

---

## Model evolution note

An initial version of the model explored routing based on lead-level scoring and static thresholds.
During development, this approach was intentionally replaced with a routing strategy based on relative economic advantage between AI and Human agents.
This change reflects a key insight of the project: decision quality depends more on marginal value differences than on absolute lead quality.
