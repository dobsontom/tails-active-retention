select
    -- Cast primary and foreign keys to strings
    CAST(pet_id AS STRING), -- Primary key
    CAST(customer_id AS STRING), -- Foreign key
    -- Rename date and timestamp fields to conform to best practice
    pet_created_datetime AS pet_created_at,
    dob AS birth_date,
    gender,
    converted AS converted_date
from
    challenge.analytics_engineer.tails_default__pet;
