# Projet 8 : Profil des étudiants Data avec dbt et Snowflake

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

### Contexte
Un organisme de formation en forte croissance sur ses filières Data veut connaître précisément ses étudiants : profil type (âge, origine géographique), évolution d'une année sur l'autre, et comparaison avec la population française (INSEE).

**Mon objectif :** pas un rapport ponctuel, mais un pipeline ELT automatisé et testé, servant de source unique de vérité, rejouable à chaque nouvelle promotion.

### Missions réalisées
* **Architecture en trois couches dans Snowflake :** tables brutes, vues de nettoyage dbt (non matérialisées pour économiser le stockage), table finale matérialisée pour un accès instantané.
* **Dédoublonnage :** le fichier source comptait une ligne par *inscription*, pas par *étudiant*. Une règle dbt ne conserve que l'inscription la plus récente de chaque étudiant.
* **RGPD dès la conception :** identifiant pseudonymisé, minimisation des données, catégorie « Non renseigné » plutôt que suppression de lignes.
* **Harmonisation avec l'INSEE :** noms des régions et tranches d'âge.
* **Tests de qualité dbt** (`schema.yml`) : unicité et non-nullité de l'identifiant étudiant, valeurs acceptées pour le genre, non-nullité des effectifs dans la table finale.

### Structure du pipeline dbt
* `dbt/staging/`
    * `stg_students.sql` : nettoyage, standardisation des régions et dédoublonnage (vue)
    * `stg_insee.sql` : préparation des données de population (vue)
    * `schema.yml` et `src_openclassrooms.yml` : tests et déclaration des sources
* `dbt/marts/`
    * `mart_students_profiling.sql` : table finale qui croise étudiants et INSEE

### Résultats
* Inscriptions passées de **255 à 69** entre 2022 et 2025.
* Part de femmes passée de **41 % à 20 %** depuis 2023.
* Un public de professionnels en reconversion (25-39 ans), concentré en Île-de-France.

### Contenu du dépôt
* `dbt/` : les modèles et tests dbt
* `data-raw/` : données étudiants et estimations de population INSEE
* `reports/` : fichier d'analyse final et présentation
* `images/` : captures d'écran

<img src="images/Capture d'écran 2026-03-10 133019.png" width="500px"><img src="images/Capture d'écran 2026-03-09 142559.png" width="500px">
<img src="images/Capture d'écran 2026-03-09 142332.png" width="450px"><img src="images/Capture d'écran 2026-03-09 142031.png" width="450px">

---
📂 Dossier complet sur mon portfolio : [remydaura.github.io/p8.html](https://remydaura.github.io/p8.html)

*Ce projet fait partie de la formation Data Analyst d'OpenClassrooms.*
