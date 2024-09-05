# Tails.com Retention and Active Dogs Challenge

This project is built using dbt to track and analyse the number of active trialists and converted pets for Tails.com. The models are designed to help the business understand customer retention and the behaviour of trialists over time. The project follows a star schema structure with fact and dimension tables, focusing on ease of analysis, scalability, and efficiency for downstream reporting in tools like Tableau.

## Documentation

 - View the full dbt project documentation [here](https://dobsontom.github.io/tails-active-retention/).

## Project Structure

```bash
tails-active-retention
│   .gitignore
│   .sqlfluff
│   .sqlfluffignore
│   dbt_project.yml
│   README.md
│
├───docs
│       catalog.json
│       index.html
│       manifest.json
│
├───models
│   ├───intermediate
│   │       int_trial_active_conversion_flags.sql
│   │       int_trial_active_days.sql
│   │       int_trial_subscriptions.sql
│   │       _int_models.yml
│   │
│   ├───marts
│   │       dim_pet.sql
│   │       dim_subscriptions.sql
│   │       fct_trial_activity.sql
│   │       _marts_models.yml
│   │
│   └───staging
│           stg_pets.sql
│           stg_subscriptions.sql
│           _sources.yml
│           _stg_models.yml
│
└───tests
```
## Project Overview

### Key Models

1. **Staging Models (`stg_`)**: These models serve as the first layer, cleaning and preparing raw data from the source tables.
   - `stg_pets`: Cleans and prepares data from the `tails_default__pet` source table.
   - `stg_subscriptions`: Cleans and prepares data from the `tails_default__subscription` source table.

2. **Intermediate Models (`int_`)**: Intermediate models transform the staging data, applying business logic to track trials and conversions over time.
   - `int_trial_subscriptions`: Calculates trial start and end dates, considering conversion events from both pets and subscriptions.
   - `int_trial_active_days`: Uses recursion to generate rows for each active day between trial start and end dates for each subscription.
   - `int_active_conversion_flags`: Applies flags indicating active trial days and conversion events for each subscription on a daily basis.

3. **Mart Models (`fct_` and `dim_`)**: These are the final fact and dimension tables, optimised for analysis and reporting.
   - `fct_trial_activity`: The main fact table that stores trial activity and conversion data by day. It includes flags for whether the subscription was active and whether a conversion event occurred on a specific day.
   - `dim_pets`: The pets dimension table, containing attributes related to each pet, such as `pet_gender`, `pet_birth_date`, and `pet_created_at`.
   - `dim_subscriptions`: The subscriptions dimension table, containing attributes of each subscription, such as `subscription_status`, `tier`, and dates related to the subscription lifecycle.

## dbt Tests

This dbt project includes the following tests:

- **Uniqueness and Not Null Tests**:
  - For primary keys (e.g., `subscription_id`, `pet_id`, `customer_id`) in the staging, intermediate, and mart models.
  
- **Referential Integrity Tests**:
  - Ensures that relationships between fact and dimension tables are preserved, for example:
    - Ensuring every `pet_id` in the fact table exists in `dim_pets`.
    - Ensuring every `subscription_id` in the fact table exists in `dim_subscriptions`.

## Setup Instructions

1. Clone the repository.
2. Install dbt and any required dependencies.
3. Configure your `profiles.yml` file to match the connection settings for your environment.
4. Run the dbt models to generate the final tables:

5. To ensure data quality, execute the dbt tests:

   ```bash
   dbt test
    ```

