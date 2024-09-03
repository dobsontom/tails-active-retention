select
    -- Cast primary and foreign keys to strings
    CAST(subscription_id AS STRING) AS subscription_id, -- Primary key
    CAST(pet_id AS STRING) AS pet_id, -- Foreign key
    CAST(customer_id AS STRING) AS customer_id, -- Foreign key
    subscription_type,
    status,
    -- Rename date and timestamp fields to conform to best practice
    start_datetime AS start_at,,
    end_datetime AS end_at,
    created_datetime AS created_at,
    last_modified_datetime AS last_modified_at,
    order_days,
    tier,
    scheduled_next_delivery_date,
    fixed_revenue,
    dry,
    wet,
    suspended,
    trial_days,
    fulfilment_date,
    scheduled_next_billing_datetime AS scheduled_next_billing_at,
    pricing_set_id
from
    challenge.analytics_engineer.tails_default__subscription;
