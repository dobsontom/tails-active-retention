-- Use recursion to generate a row for every day between
-- the trial start and trial end date for each subscription
with recursive active_days_cte as (

    -- Base case: select the starting active day (trial start date) for each subscription
    select
        -- Cast primary and foreign keys to STRING for consistency across models
        CAST(sub.subscription_id as STRING) as subscription_id,
        CAST(sub.customer_id as STRING) as customer_id,
        CAST(sub.pet_id as STRING) as pet_id,
        CAST(sub.trial_start_at as DATE) as active_day,  -- Initial active day is the trial start date
        sub.trial_start_at,
        sub.trial_end_at,
        sub.converted_date
    from
        {{ ref('int_trial_subscriptions') }} as sub

    union all

    -- Recursive step: Add one day to the active day for each subscription
    -- and repeat the process until active_day equals trial_end_at
    select
        CAST(cte.subscription_id as STRING) as subscription_id,
        CAST(cte.customer_id as STRING) as customer_id,
        CAST(cte.pet_id as STRING) as pet_id,
        DATEADD(day, 1, cte.active_day) as active_day,  -- Increment the active day by one
        cte.trial_start_at,
        cte.trial_end_at,
        cte.converted_date
    from
        active_days_cte as cte
    where
        cte.active_day < CAST(cte.trial_end_at as DATE)  -- Stop the recursion when active_day reaches trial_end_at
)

-- Select relevant fields for downstream fact table
select
    subscription_id,
    customer_id,
    pet_id,
    active_day, -- Key date for each row, one per day between trial start and end
    trial_start_at,
    trial_end_at,
    converted_date
from
    active_days_cte

-- Sorting would not typically be included in a real model
-- but is included here for demonstrative purposes
order by
    subscription_id, active_day
