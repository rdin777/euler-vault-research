# euler-vault-research


*If this research helped you, please consider giving it a ⭐ Star.*


## 🚀 Stay Updated
Found this research useful?
* **Star ⭐** this repo to keep track of it.
* **Follow me** on GitHub for more DeFi security research.
* **Fork** it if you want to run your own experiments.

### ☕ Support the Research
If you appreciate the work and want to support further security research:

<img src="456.PNG" alt="Donate QR" width="200"/>

**Wallet Address (ETH/EVM):** 0xBDDD7973D0DE27B715A4A5cbdb87d0DF78757b3A 

Deep dive into Euler Vaults: Analysis of liquidation edge cases, interest rate rounding, and protocol fee mechanics.
Markdown
# Security Research: Euler Vaults Analysis

This repository contains technical deep dives and Proof-of-Concept (PoC) scripts for edge cases identified during the audit of **Euler Vaults**. While these findings were classified as documented behavior or low-impact by the protocol team, they demonstrate complex logical interactions within the system.

## 📊 Summary of Findings

### 1. Zero-Value Liquidation & Collateral Claim (#272)
* **Type:** Design Analysis / Documentation Gap
* **Description:** Analysis of how collateral with zero or near-zero value can be claimed without debt repayment. 
* **Key Insight:** Highlights the critical importance of Oracle selection and "Vault Governor" responsibilities in modular lending protocols.

### 2. Protocol Fee Precision & Cache Manipulation (#271)
* **Type:** Economic Analysis / Gas Efficiency
* **Description:** Investigation into whether frequent updates to the interest cache (`touch()`) could lead to systematic protocol fee loss.
* **Key Insight:** While the attack proved economically unfeasible due to L1/L2 gas costs, the PoC demonstrates a deep understanding of Euler's interest rate model.

### 3. Debt Socialization & Rounding Errors (#270)
* **Type:** Mathematical Analysis
* **Description:** Research into `totalBorrows` inflation caused by 1-wei rounding discrepancies during debt socialization.
* **Key Insight:** Analyzes the long-term state drift in high-TVL environments.

## 🛠️ Tech Stack
* **Language:** Solidity
* **Framework:** Foundry / Hardhat
* **Tooling:** Slither, custom fuzzing scripts.

## Technical Analysis
Euler Vaults uses fixed-point arithmetic.
My analysis focused on the accumulation of rounding errors:
$$totalBorrows_{new} = totalBorrows_{old} \times (1 + r \times \Delta t)$$
Where even a minimal deviation of $1\ wei$ at a high transaction frequency can affect the protocol balance.

## 🚀 Reproducing the Findings

This repository uses **Foundry**. To run the Proof-of-Concept (PoC) scripts for each finding:

### 1. Zero-Value Liquidation (Free Collateral)
Demonstrates how collateral can be claimed without debt repayment under specific conditions.
```bash
forge test --match-path test/FreeCollateral.t.sol -vv

2. Protocol Fee Leak Analysis
Simulates frequent interest cache updates to analyze systematic fee discrepancies.
forge test --match-path test/FeeLeak.t.sol -vv

3. Precision & Rounding Math
Deep dive into interest rate compounding and rounding errors in totalBorrows.
forge test --match-path test/AuditMath.t.sol -vv


---
*Note: These reports were submitted via Cantina. This repository serves as a personal archive of technical research.*
