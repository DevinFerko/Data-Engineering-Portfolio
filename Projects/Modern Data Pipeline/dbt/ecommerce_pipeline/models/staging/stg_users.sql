SELECT
    *
FROM {{ source('Testing', 'users') }}