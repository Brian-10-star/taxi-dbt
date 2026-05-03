with source as (
    select * from {{ source('public', 'taxi_trips') }}
),

staged as (
    select
        trip_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        fare_amount,
        tip_amount,
        total_amount,
        payment_type,

        -- Derived columns
        EXTRACT(HOUR FROM pickup_datetime)          as pickup_hour,
        EXTRACT(DOW FROM pickup_datetime)           as pickup_day_of_week,
        EXTRACT(MONTH FROM pickup_datetime)         as pickup_month,
        (dropoff_datetime - pickup_datetime)        as trip_duration,
        ROUND((tip_amount / NULLIF(fare_amount, 0) * 100)::numeric, 2) as tip_percentage

    from source
    where
        trip_distance > 0
        and fare_amount > 0
        and passenger_count between 1 and 6
)

select * from staged