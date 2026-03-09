# SQL Data Modeling

## Project Overview
The goal of this project is to demonstrate best practices in database design, performance tuning, and the implementation of modern data architectures (such as the Medallion Architecture or Star Schema).

### Key Capabilities Demonstrated:
* **DDL & Schema Design:** Creating robust, indexed tables with appropriate constraints (Primary Keys, Foreign Keys, Not Null).
* **Business Logic Abstraction:** Developing reusable views to simplify complex reporting requirements for stakeholders.
* **Data Modeling:** Architecting Star and Snowflake schemas to optimize for analytical queries (OLAP).
* **Performance Optimization:** Efficient use of Joins, Window Functions, CTEs, and Indexing strategies.

---

## Repository Structure

```bash
├── Tables/           # DDL scripts for raw and staging tables
├── Views/            # Logic layers for reporting and business metrics
└── Models/           # Final dimensional models (Facts & Dimensions)
```
---

## Key Implementation Details

### Data Definition

Located in the ```Tables``` directory, these scripts define the foundational layer. I focus on:

- Enforcing data integrity through strict constraints.
- Implementing partitioned tables to handle large-scale datasets efficiently.

### Analytical Views

The ```Views``` directory contains logic designed to provide a "clean" layer for BI tools. This prevents logic duplication and ensures "one version of the truth" for metrics like Monthly Invoiced Revenue or Order Margin.

### Dimensional Modeling

The ```Models``` directory transitions from normalized operational data to a Star Schema optimized for analytical performance.

- Fact Tables: Centralized quantitative data (e.g., Lead Source Results by Agent, CS Overall Data Freshdesk Tickets Assigned).
- Dimension Tables: Descriptive attributes (e.g., 3CX Sales Agent).

---

## Using this Repo

1. Exploration: Start with ```Tables``` to understand the raw data structure.
2. Logic: Review ```Views``` to see how raw data is cleaned and transformed.
3. Analysis: Check ```Models``` to see the final output ready for a BI tool like Tableau or Power BI.

---

## Contact Information

This repository is part of my larger Data Engineering portfolio.

- Main Portfolio: [Data Enginnering Portfolio](https://github.com/DevinFerko/Data-Engineering-Portfolio/tree/main)
- GitHub Profile: [github.com/DevinFerko](https://github.com/DevinFerko)
- LinkedIn: [linkedin.com/in/devin-ferko/](https://www.linkedin.com/in/devin-ferko/)