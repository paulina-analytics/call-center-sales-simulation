# Call Center Sales Simulation: Human vs AI Routing

This project is a simulation of a sales call center, built as a learning and exploratory exercise.
Its main goal is to analyze how different call routing strategies (Human-only, AI-only, Random, and Smart AI routing)
affect business outcomes such as profit and efficiency.

The project was created **as part of a learning process**, not as a production-ready system.

---

## 🎯 Project Goals

- Simulate a realistic outbound sales call center environment
- Compare different call handling strategies:
  - Human-only
  - AI-only
  - Random (50/50)
  - Smart routing based on relative advantage
- Explore **when AI makes sense** and when humans clearly outperform it
- Learn R through hands-on experimentation and simulation

---

## 🤖 Human–AI Collaboration (Important Note)

This project was developed **in close collaboration with AI (ChatGPT)**.

I do **not** present this code as something I could have written fully on my own at this stage.
Instead, the project reflects how AI can be used as:

- a learning companion
- a reasoning partner
- a tool for structuring complex logic step by step
- support in debugging, refactoring, and explaining concepts

The value of this project lies not only in the final code,
but in **how AI enabled faster learning, experimentation, and understanding**.

The model logic, assumptions, and interpretation of results are human-driven.
The implementation was created iteratively with AI assistance.

This repository is intentionally transparent about that collaboration.

---

## 🧠 Key Insights

- Most calls generate low or marginal profit — a small subset drives most of the value
- Humans clearly outperform AI on high-value, high-risk calls
- AI performs comparably on low-value calls while being significantly cheaper
- Random routing performs worse than both human-only and smart routing
- Smart routing (based on relative advantage) delivers the highest average profit per call

**Conclusion:**  
AI should not replace humans — it should **filter and prioritize**, allowing humans to focus where they add the most value.

---

## 🗂 Project Structure

call-center-sales-simulation/
│
├── R/
│ ├── 01_generate_clients.R
│ ├── 02_generate_agents.R
│ ├── 03_simulate_calls.R
│ └── 04_visualizations.R
│
├── plots/
│ ├── p_strategy.png
│ ├── p_delta.png
│ └── p_routing.png
│
├── assumptions.md
├── .gitignore
└── call-center-sales-simulation.Rproj


---

## ⚠️ Assumptions & Limitations

This is a simplified simulation.
Some important real-world aspects are intentionally abstracted.

Key assumptions are documented in detail in [`assumptions.md`](assumptions.md).

This project is meant for:
- learning
- discussion
- conceptual exploration

Not for direct operational use.

---

## 📊 Visual Outputs

All key results are visualized using `ggplot2`.
Plots are saved in the `plots/` directory and represent:
- average profit per call by strategy
- distribution of relative advantage (Human vs AI)
- routing decisions based on relative advantage

---

## 🚀 Why This Project Exists

This project exists to show that:
- you don’t need to be an expert to start working with data
- AI can significantly lower the entry barrier to technical learning
- learning by building real things is far more effective than tutorials
- transparency about AI usage is a strength, not a weakness

---

## 🧩 Next Steps

Potential future extensions:
- dynamic learning of routing thresholds
- multi-product portfolios
- agent fatigue and learning effects
- delayed revenue and churn modeling

---

**Built with curiosity, iteration, and AI collaboration.**


