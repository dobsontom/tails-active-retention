-- Apply flags for active trial and conversion
with apply_flags as (
    select
        -- Cast primary and foreign keys to STRING for consistency across models
        CAST(subscription_id as STRING) as subscription_id,
        CAST(customer_id as STRING) as customer_id,
        CAST(pet_id as STRING) as pet_id,
        trial_start_at,
        active_day,
        -- Active trial flag: If no conversion occurred, flag all days. Otherwise, flag days before the conversion
        case
            when converted_date is NULL then 1
            when active_day < CAST(converted_date as DATE) then 1
        end as active_trial_flag,

        -- Conversion flag: Flag the day when the conversion occurred
        case
            when active_day = CAST(converted_date as DATE) then 1
            else 0
        end as converted_flag
    from
        {{ ref('int_trial_active_days') }}
)

-- Final selection
select
    subscription_id,
    customer_id,
    pet_id,
    trial_start_at,
    active_day,
    active_trial_flag,  -- Indicates whether this day is part of an active trial
    converted_flag  -- Indicates whether this day had a conversion
from
    apply_flags
