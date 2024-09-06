with source as (
    select
        *
    from {{ source('analytics_engineer', 'tails_default__subscription') }}
)

select
    -- Cast primary and foreign keys to STRING for consistency across models
    CAST(subscription_id as STRING) as subscription_id,  -- Primary key
    CAST(pet_id as STRING) as pet_id,                    -- Foreign key
    CAST(customer_id as STRING) as customer_id,          -- Foreign key
    subscription_type,
    -- Rename to avoid using a reserved word in ANSI SQL
    status as subscription_status,

    -- Rename date and timestamp fields for consistency
    start_datetime as start_at,
    end_datetime as end_at,
    created_datetime as created_at,
    last_modified_datetime as last_modified_at,
    order_days,
    tier,
    trial_days,
    fixed_revenue,
    dry,
    wet,
    suspended,
    fulfilment_date,
    scheduled_next_delivery_date,
    scheduled_next_billing_datetime as scheduled_next_billing_at,
    pricing_set_id
from
    source
