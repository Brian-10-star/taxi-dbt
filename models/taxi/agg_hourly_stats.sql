with facts as (
    select * from {{ ref('fct_taxi_trips') }}
),

hourly as (
    select
        pickup_hour,
        time_of_day,
        COUNT(*)                                    as total_trips,
        ROUND(AVG(fare_amount)::numeric, 2)         as avg_fare,
        ROUND(AVG(tip_percentage)::numeric, 2)      as avg_tip_pct,
        ROUND(AVG(trip_distance)::numeric, 2)       as avg_distance,
        ROUND(SUM(total_amount)::numeric, 2)        as total_revenue
    from facts
    group by pickup_hour, time_of_day
    order by pickup_hour
)

select * from hourly