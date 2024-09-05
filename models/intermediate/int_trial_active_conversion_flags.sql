-- Apply flags for active trial and conversion
with flags as (
    select
        subscription_id,
        customer_id,
        pet_id,
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
    active_day,
    active_trial_flag,  -- Indicates whether this day is part of an active trial
    converted_flag  -- Indicates whether this day had a conversion
from
    flags
