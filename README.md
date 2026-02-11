Staged Liquidity Bootstrapper

A **Staged Liquidity Bootstrapper** smart contract built in **Clarity** for the Stacks blockchain.  
This contract enables projects to onboard liquidity in clearly defined stages, ensuring fairness, transparency, and controlled capital formation during early protocol launches.

---

Overview

The Staged Liquidity Bootstrapper allows liquidity contributions to occur in sequential stages, each with predefined funding targets. A new stage only becomes active once the previous stage’s target is met, preventing premature or unfair liquidity dominance.

All logic is enforced on-chain, removing the need for trusted intermediaries.

---

Key Features

- **Stage-based liquidity onboarding**
- **Sequential stage enforcement**
- **Funding target thresholds per stage**
- **Contributor tracking per stage**
- **Read-only queries for transparency**
- **Fully on-chain, immutable logic**

---

How It Works

1. The contract defines multiple liquidity stages, each with:
   - A funding target
   - A stage index
2. Contributors can add liquidity only to the currently active stage.
3. Once a stage’s funding target is reached:
   - The stage is marked complete
   - The next stage becomes active automatically
4. Liquidity progress and stage status are publicly queryable.

---

Core Contract Functions

 Public Functions
- `contribute` – Contribute liquidity to the active stage
- `advance-stage` – Automatically triggered when funding targets are met

Read-Only Functions
- `get-current-stage` – Returns the active stage index
- `get-stage-target` – Returns the funding target for a stage
- `get-stage-progress` – Returns total liquidity contributed to a stage
- `get-user-contribution` – Returns a user’s contribution per stage

---

Security & Design Principles

- No centralized admin control during active stages
- Strict stage ordering enforced by contract logic
- Deterministic execution with no external dependencies
- Designed to pass `clarinet check` with minimal warnings
- Safe for composability with AMMs, vaults, and DAO treasuries

---

 Use Cases

- New DeFi protocol launches
- Fair liquidity bootstrapping events
- DAO-governed funding rounds
- Controlled token distribution phases
- Community-driven liquidity onboarding

---


License
MIT License

 
 Development & Testing

```bash
clarinet check
clarinet test




