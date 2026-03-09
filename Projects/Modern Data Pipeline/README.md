# Flagship Project: Modern Data Pipeline (API → Warehouse → Analytics)

## Project Goal

Build a complete end-to-end data pipeline that:

1. Extracts data from a public API
2. Loads raw data into a warehouse
3. Transforms data into a star schema
4. Runs transformations with a data build tool
5. Schedules the pipeline
6. Adds data quality checks
7. Produces analytics-ready tables

This mirrors how modern companies use tools like:

- Google BigQuery
- dbt
- Apache Airflow

---

## Example Use Case
### E-commerce Analytics Pipeline

Example APIs:

- Shopify-like store API (many public examples)
- Stripe payments API
- Fake Store API
- GitHub API
- Spotify listening history

#### For This Project - [Fake Store API](https://fakestoreapi.com/)

This project utilizes the Fake Store API, a mock e-commerce backend that provides structured data for products, users, and login sessions. It serves as a reliable sandbox for practicing data fetching, state management, and UI development in a risk-free environment. [Official Documentation](https://fakestoreapi.com/docs)

It contains 3 tables:

```bash
products
carts
users
```

---
## Proposed Architecture

```bash
API
 ↓
Python ingestion script
 ↓
Raw tables
 ↓
dbt transformations
 ↓
Star schema warehouse
 ↓
Analytics tables
 ↓
Dashboard / example queries
```
