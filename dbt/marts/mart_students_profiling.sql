WITH students_aggregated AS (
    -- 1. On compte le nombre d'étudiants pour chaque croisement (Année, Région, Genre, Âge)
    SELECT
        year_path_started,
        region,
        gender,
        age_group,
        COUNT(user_id) AS nb_students
    FROM {{ ref('stg_students') }}
    GROUP BY 1, 2, 3, 4
),

insee_aggregated AS (
    -- 2. On prépare les données de l'INSEE pour la jointure
    SELECT
        region,
        gender,
        age_group,
        SUM(population) AS insee_population
    FROM {{ ref('stg_insee') }}
    GROUP BY 1, 2, 3
),

final_join AS (
    -- 3. On croise les étudiants avec la population française
    SELECT
        s.year_path_started,
        s.region,
        s.gender,
        s.age_group,
        s.nb_students,
        -- S'il n'y a pas de correspondance INSEE (ex: Genre "Non renseigné"), on met 0
        COALESCE(i.insee_population, 0) AS insee_population
    FROM students_aggregated s
    LEFT JOIN insee_aggregated i
        ON s.region = i.region
        AND s.gender = i.gender
        AND s.age_group = i.age_group
)

SELECT * FROM final_join