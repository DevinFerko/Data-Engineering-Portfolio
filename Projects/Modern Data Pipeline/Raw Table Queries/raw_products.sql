-- Used to create or replace Products table

CREATE OR REPLACE TABLE `project_id.raw.products` (
    id INT64,
    title STRING,
    price FLOAT64,
    description STRING,
    category STRING,
    image STRING,
    rating_rate FLOAT64,
    rating_count INT64
);