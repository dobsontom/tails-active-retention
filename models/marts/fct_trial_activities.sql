-- Final fact model for analysing active trialists and conversion events

with fact_data as (
    select
        -- Cast primary and foreign keys to STRING for consistency across models
        CAST(subscription_id as STRING) as subscription_id,  -- Primary Key
        CAST(customer_id as STRING) as customer_id,          -- Foreign Key
        -- Foreign Key to dim_pet
        CAST(pet_id as STRING) as pet_id,
        -- Key date for each row
        active_day,
        trial_start_at,
        trial_end_at,
        converted_date,
        active_trial_flag,  -- Indicates if this day is part of an active trial
        converted_flag      -- Indicates if this day had a conversion event
    from
        -- Pull from the intermediate model
        {{ ref('int_trial_active_conversion_flags') }}
)

-- Final selection for the fact table
select
    subscription_id,
    customer_id,
    pet_id,
    active_day,
    trial_start_at,
    trial_end_at,
    converted_date,
    active_trial_flag,
    converted_flag
from
    fact_data
