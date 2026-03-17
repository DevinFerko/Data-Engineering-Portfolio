-- Used to create or replace Users table

CREATE OR REPLACE TABLE `project_id.raw.products` (
    id INT64,
    email STRING,
    username STRING,
    password STRING,
    phone STRING,
    __v INT64,
    address_geolocation_lat STRING,
    address_geolocation_long STRING,
    address_city STRING,
    address_street STRING,
    address_number INT64,
    address_zipcode STRING,
    name_firstname STRING,
    name_lastname STRING
);