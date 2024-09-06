![Tails.com Logo](./assets/tails-com-logo.png)

# Tails.com Retention and Active Dogs Challenge

This project is built using dbt to track and analyse the daily number of active trialists and converted pets at Tails.com. It follows a star schema structure with fact and dimension tables, optimised for ease of use, scalability, and efficiency. The models are designed to support downstream visualisations and analytics in tools such as Tableau.

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

1. **Staging Models (`stg_`)**: These models act as the first layer, preparing raw data from Snowflake for further processing.
   - `stg_pets`: Processes data from the `tails_default__pet` source table.
   - `stg_subscriptions`: Processes data from the `tails_default__subscription` source table.

2. **Intermediate Models (`int_`)**: Intermediate models transform the data and apply logic to track trials and conversions over time.
   - `int_trial_subscriptions`: Calculates trial start and end dates, and joins trial conversion dates from `stg_pets`.
   - `int_trial_active_days`: Uses recursion to generate rows for each day between the trial start and end dates for active subscriptions.
   - `int_active_conversion_flags`: Applies flags to indicate active trials and conversion events for each subscription on a daily basis.

3. **Mart Models (`fct_` and `dim_`)**: These are the final fact and dimension models, optimised for analysis and reporting.
   - `fct_trial_activity`: Fact table containing daily active trials and conversions data.
   - `dim_pets`: Dimension table containing pet attributes such as `pet_gender`, `pet_birth_date`, and `pet_created_at`.
   - `dim_subscriptions`: Dimension table containing subscription attributes such as `subscription_status`, `tier`, and dates related to the subscription lifecycle.

## dbt Tests

This dbt project includes the following tests:

- **Uniqueness and Not Null Tests**:
  - Ensure that key fields (e.g., `subscription_id`, `pet_id`, `customer_id`) in the staging, intermediate, and mart models are unique and not null.
  
- **Referential Integrity Tests**:
  - Ensure that relationships between fact and dimension tables are preserved, for example:
    - Ensuring every `pet_id` in the fact table exists in `dim_pets`.
    - Ensuring every `subscription_id` in the fact table exists in `dim_subscriptions`.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/dobsontom/tails-active-retention.git/
   cd tails-active-retention
   ```

2. **Install Dependencies**:
   ```bash
   pip install dbt-core dbt-snowflake
   ```

3. **Configure `profiles.yml`**:
 - Update `profiles.yml` with your Snowflake credentials.

4. **Run dbt Models**:
   ```bash
   dbt run
   ```
