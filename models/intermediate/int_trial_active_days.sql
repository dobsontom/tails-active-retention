
-- Use recursion to generate a row for every every day between the subscription start
-- and subscription end date
with recursive active_days_cte as (
    -- Use start_at as the trial start date
    select
        sub.subscription_id,
        sub.customer_id,
        sub.pet_id,
        sub.start_at as active_day,
        sub.trial_end_at,
        sub.converted_date
    from
        {{ ref('int_trial_subscriptions') }} as sub

    union all

    -- Recursive case: generate the next active day
    select
        sub.subscription_id,
        sub.customer_id,
        sub.pet_id,
        DATEADD(day, 1, cte.active_day) as active_day,
        sub.trial_end_at,
        sub.converted_date,
        1 as active_trial_flag
    from
        active_days_cte as cte
    join
        {{ ref('int_trial_subscriptions') }} as sub
        on cte.subscription_id = sub.subscription_id
    where
        cte.active_day <= sub.trial_end_at
)
-- Select relevant fields for downstream analysis
select
    subscription_id,
    customer_id,
    pet_id,
    active_day,
    -- Apply an active flag to all days except the converted date
    case
        when active_day = converted_date then 0
        else 1
    end as active_trial_flag,
    -- Apply a conversion flag to days where the active day equals the converted date
    case
        when active_day = converted_date then 1
        else 0
    end as converted_flag
from
    active_days_cte
order by
    subscription_id, active_day
