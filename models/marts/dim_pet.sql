select
    -- Cast primary and foreign keys to STRING for consistency across models
    CAST(pet_id as STRING) as pet_id,
    CAST(customer_id as STRING) as customer_id,
    pet_created_at,
    pet_birth_date,
    pet_gender,
    converted_date  -- Nullable; will show when pet converted to a subscription
from
    {{ ref('stg_pets') }}
