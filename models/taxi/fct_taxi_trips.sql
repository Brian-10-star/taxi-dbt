with staged as (
    select * from {{ ref('stg_taxi_trips') }}
),

enriched as (
    select
        trip_id,
        pickup_datetime,
        dropoff_datetime,
        trip_duration,
        passenger_count,
        trip_distance,
        fare_amount,
        tip_amount,
        total_amount,
        tip_percentage,
        pickup_hour,
        pickup_day_of_week,
        pickup_month,

        -- Payment type description
        case payment_type
            when 1 then 'Credit Card'
            when 2 then 'Cash'
            when 3 then 'No Charge'
            when 4 then 'Dispute'
            else 'Unknown'
        end as payment_type_desc,

        -- Time of day bucket
        case
            when pickup_hour between 6  and 11 then 'Morning'
            when pickup_hour between 12 and 16 then 'Afternoon'
            when pickup_hour between 17 and 20 then 'Evening Rush'
            when pickup_hour between 21 and 23 then 'Night'
            else 'Late Night'
        end as time_of_day,

        -- Trip distance category
        case
            when trip_distance < 1    then 'Short'
            when trip_distance < 5    then 'Medium'
            when trip_distance < 10   then 'Long'
            else 'Very Long'
        end as distance_category

    from staged
)

select * from enriched