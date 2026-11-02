WITH source AS (
    SELECT * FROM {{ source('raw_openclassrooms', 'raw_insee') }}
),

cleaned AS (
    SELECT
        region,
        gender,
        age_group,
        population
    FROM source
)

SELECT * FROM cleaned