with trial_subscriptions as (
    select
        sub.subscription_id,
        sub.customer_id,
        sub.pet_id,
        sub.subscription_type,
        sub.start_at,
        -- Calculate the trial end date using either the converted date or the start
        -- date plus the number of trial days if there was no conversion.
        COALESCE(pets.converted_date, DATEADD(day, sub.trial_days, sub.start_at)) as trial_end_at,
        pets.converted_date,
        sub.trial_days,
        sub.tier,
        sub.dry,
        sub.wet,
        sub.pricing_set_id
    from
        {{ ref('stg_subscriptions') }} as sub
    join
        {{ ref('stg_pets') }} as pets
        on sub.pet_id = pets.pet_id
    -- Since we're only concerned with active trials and converted trials, we can 
    -- filter subscriptions to only those with a populated trial_days value.
    where
        sub.trial_days is not NULL
)

-- Select relevant fields to be used in downstream fact tables.
select
    subscription_id,
    customer_id,
    pet_id,
    subscription_type,
    start_at,
    trial_end_at,
    converted_date,
    trial_days,
    -- Include the following fields to enable filtering and breakdowns in
    -- downstream BI tools.
    tier,
    dry,
    wet,
    pricing_set_id
from
    trial_subscriptions
