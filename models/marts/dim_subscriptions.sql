select
    -- Cast primary and foreign keys to STRING for consistency across models
    CAST(subscription_id as STRING) as subscription_id,  -- Primary key
    CAST(customer_id as STRING) as customer_id,          -- Foreign key
    CAST(pet_id as STRING) as pet_id,                    -- Foreign key
    subscription_type,
    subscription_status,  -- Current-state field, useful for flagging currently active subscriptions
    tier,
    pricing_set_id,
    start_at as subscription_start_at,
    end_at as subscription_end_at,
    created_at as subscription_created_at,
    last_modified_at,
    order_days,
    fixed_revenue,
    trial_days,
    scheduled_next_delivery_date,
    fulfilment_date,
    scheduled_next_billing_at,
    dry,
    wet,
    suspended  -- Current-state field, useful for flagging currently suspended subscriptions
from
    {{ ref('stg_subscriptions') }}
