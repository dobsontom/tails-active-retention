-- Use recursion to generate a row for every every day between
-- the trial start and trial end date for each subscription
with recursive active_days_cte as (
    -- Use start_at as the base
    select
        sub.subscription_id,
        sub.customer_id,
        sub.pet_id,
        sub.start_at as active_day,
        sub.trial_start_at,
        sub.trial_end_at,
        sub.converted_date
    from
        {{ ref('int_trial_subscriptions') }} as sub

    union all

    -- Add one day to the active day until it equals the trial
    -- end date, then repeat for the next subscription
    select
        sub.subscription_id,
        sub.customer_id,
        sub.pet_id,
        DATEADD(day, 1, cte.active_day) as active_day,
        sub.trial_start_at,
        sub.trial_end_at,
        sub.converted_date
    from
        active_days_cte as cte
    join
        {{ ref('int_trial_subscriptions') }} as sub
        on cte.subscription_id = sub.subscription_id
    where
        CAST(cte.active_day as DATE) <= CAST(sub.trial_end_at as DATE)
)
-- Select relevant fields for downstream analysis
select
    subscription_id,
    customer_id,
    pet_id,
    active_day,
    trial_start_at,
    trial_end_at,
    converted_date
from
    active_days_cte
