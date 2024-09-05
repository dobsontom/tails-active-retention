with trial_subscriptions as (
    select
        -- Cast primary and foreign keys to STRING for consistency across models
        CAST(sub.subscription_id as STRING) as subscription_id,
        CAST(sub.customer_id as STRING) as customer_id,
        CAST(sub.pet_id as STRING) as pet_id,
        sub.start_at as trial_start_at,

        -- Calculate the trial end date
        case
            -- If there is a converted_date, take the earliest of converted_date 
            -- and the start date plus the trial length
            when
                pets.converted_date is not NULL
                then LEAST(pets.converted_date, DATEADD(day, sub.trial_days, sub.start_at))
            -- If there isn't a converted date, use the start date plus the trial length
            else DATEADD(day, sub.trial_days, sub.start_at)
        end as trial_end_at,

        pets.converted_date,
        sub.trial_days
    from
        {{ ref('stg_subscriptions') }} as sub
    inner join
        {{ ref('stg_pets') }} as pets
        on CAST(sub.pet_id as STRING) = CAST(pets.pet_id as STRING)
    -- Since we're only concerned with active and converted trials, we filter 
    -- to subscriptions with a trial_days value
    where
        sub.trial_days is not NULL
)

-- Select relevant fields for the downstream fact table
select
    subscription_id,
    customer_id,
    pet_id,
    trial_start_at,
    trial_end_at,
    converted_date,
    trial_days
from
    trial_subscriptions
