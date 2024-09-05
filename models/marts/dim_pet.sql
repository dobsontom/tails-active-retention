select
    -- Cast primary and foreign keys to STRING for consistency across models
    CAST(pet_id as STRING) as pet_id,
    CAST(customer_id as STRING) as customer_id,
    pet_gender,
    pet_birth_date,
    pet_created_at
from
    {{ ref('stg_pets') }}
