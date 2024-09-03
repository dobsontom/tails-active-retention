with source as (
    select
        *
    from {{ source('analytics_engineer', 'tails_default__pet') }}
)

select
    -- Cast primary and foreign keys to strings as per best practice
    CAST(pet_id as STRING) as pet_id,
    CAST(customer_id as STRING) as customer_id,
    -- Rename date and timestamp fields as per best practice
    pet_created_datetime as pet_created_at,
    dob as pet_birth_date,
    gender as pet_gender,
    converted as converted_date,
from
    source;
