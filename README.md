# 🚕 NYC Taxi dbt Data Warehouse

A data warehouse built using **dbt (data build tool)** on top of the NYC Yellow Taxi dataset.
This project transforms raw taxi trip data into clean, analytics-ready models using
staging, facts, and aggregation layers.

---

## 🛠️ Tools & Technologies

- **dbt-postgres** 1.10.0
- **PostgreSQL** 18
- **Python** 3.13
- **SQL**

---

## 📐 Project Architecture
Raw Data (taxidb.taxi_trips)
│
▼
stg_taxi_trips      ← Staging layer: cleans data, adds derived columns
│
▼
fct_taxi_trips      ← Facts layer: payment labels, time buckets, distance categories
│
▼
agg_hourly_stats    ← Aggregation layer: trip stats grouped by hour

---

## 📊 Models

| Model | Type | Description |
|---|---|---|
| `stg_taxi_trips` | View | Adds pickup_hour, day_of_week, trip_duration, tip_percentage |
| `fct_taxi_trips` | View | Adds payment descriptions, time of day buckets, distance categories |
| `agg_hourly_stats` | View | Aggregates trip count, avg fare, avg distance by hour |

---

## ✅ Data Quality Tests

8 automated tests defined in `schema.yml` — all passing:
- `unique` and `not_null` checks on key columns across all models

Run tests with:
```bash
dbt test
```

---

## 🚀 How to Run

1. Clone the repo
2. Set up your `~/.dbt/profiles.yml` with your PostgreSQL credentials
3. Install dbt: `pip install dbt-postgres`
4. Run the models:

```bash
dbt run
```

5. Run the tests:

```bash
dbt test
```

---

## 📁 Data Source

NYC Yellow Taxi Trip Records — 2,884,216 rows loaded via
[Project 1: NYC Taxi Pipeline](https://github.com/Brian-10-star/nyc-taxi-pipeline)

---

## 👤 Author

**Brian Mbugua Chira**  
BSc Computer Science, Egerton University  
[LinkedIn](https://www.linkedin.com/in/mbuguabrian) • [GitHub](https://github.com/Brian-10-star)