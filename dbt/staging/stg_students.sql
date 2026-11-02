WITH source AS (
    -- On appelle la source qu'on a définie dans le fichier YML
    SELECT * FROM {{ source('raw_openclassrooms', 'raw_students') }}
),

renamed_and_cleaned AS (
    SELECT
        -- On passe tout en minuscules pour respecter les conventions dbt
        user_id,
        
        -- On ajoute les tirets pour s'aligner sur la nomenclature INSEE
        REPLACE(region, 'Centre-Val de Loire', 'Centre-Val-de-Loire') AS region,
        
        path_category_name AS path_category,
        age_group,
        
        -- Règle RGPD / Qualité : On remplace les valeurs vides par "Non renseigné"
        COALESCE(gender, 'Non renseigné') AS gender,
        
        -- L'ancien "region," qui faisait doublon a été supprimé ici !
        year_path_started
        
    FROM source
-- NOUVEAUTÉ : On dédoublonne ! 
    -- On groupe par user_id, on trie par année décroissante, et on ne garde que la ligne n°1
    QUALIFY ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY year_path_started DESC) = 1
)

SELECT * FROM renamed_and_cleaned