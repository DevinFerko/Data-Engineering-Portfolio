ecommerce-data-pipeline/

README.md

ingestion/
  extract_api.py
  load_bigquery.py

sql/
  raw_tables.sql

dbt/
  dbt_project.yml
  models/

    staging/
      stg_products.sql
      stg_users.sql
      stg_orders.sql

    warehouse/
      dim_products.sql
      dim_users.sql
      fact_orders.sql

    marts/
      revenue_daily.sql
      top_products.sql

orchestration/
  airflow_dag.py

tests/
  data_quality_checks.sql

diagrams/
  pipeline_architecture.png