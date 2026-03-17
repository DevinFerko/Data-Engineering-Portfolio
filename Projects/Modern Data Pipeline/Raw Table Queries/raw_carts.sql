-- Used to create or replace Carts table

CREATE OR REPLACE TABLE `project_id.raw.products` (
    id INT64,
    user_id INT64,
    date DATETIME,
    products STRING,
    __v INT64
);