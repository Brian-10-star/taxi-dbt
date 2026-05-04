# NYC Taxi dbt Data Warehouse

![dbt](https://img.shields.io/badge/dbt-1.10.0-FF694B?logo=dbt)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-316192?logo=postgresql)
![SQL](https://img.shields.io/badge/Language-SQL-lightgrey?logo=postgresql)
![Tests](https://img.shields.io/badge/dbt%20Tests-8%20Passing-brightgreen)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

A three-layer data warehouse built with **dbt (data build tool)** on top of 2.8 million NYC Yellow Taxi trip records. Transforms raw PostgreSQL data into clean, analytics-ready models using staging, facts, and aggregation layers — with automated data quality testing.

Built as Project 4 of a structured Data Engineering portfolio, using the dataset loaded in [Project 1 — NYC Taxi Pipeline](https://github.com/Brian-10-star/nyc-taxi-pipeline).

---

## Warehouse Architecture

```
PostgreSQL Source Table
taxidb.taxi_trips (2,884,216 rows)
        │
        ▼
┌─────────────────────────────────────────┐
│           stg_taxi_trips                │  STAGING LAYER
│                                         │
│  Derived columns added:                 │
│  • pickup_hour     (0–23)               │
│  • day_of_week     (Monday–Sunday)      │
│  • trip_duration   (minutes)            │
│  • tip_percentage  (tip / fare × 100)   │
└───────────────────┬─────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│           fct_taxi_trips                │  FACTS LAYER
│                                         │
│  Enrichments added:                     │
│  • payment_description (Credit Card,    │
│    Cash, No Charge, Dispute)            │
│  • time_of_day bucket (Morning, After-  │
│    noon, Evening, Night)                │
│  • distance_category (Short, Medium,    │
│    Long, Very Long)                     │
└───────────────────┬─────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│          agg_hourly_stats               │  AGGREGATION LAYER
│                                         │
│  Metrics by hour:                       │
│  • trip_count                           │
│  • avg_fare                             │
│  • avg_distance                         │
│  • avg_trip_duration                    │
└─────────────────────────────────────────┘
```

---

## Models

| Model | Materialization | Layer | Description |
|---|---|---|---|
| `stg_taxi_trips` | View | Staging | Cleans raw data, adds 4 derived columns |
| `fct_taxi_trips` | View | Facts | Adds payment labels, time buckets, distance categories |
| `agg_hourly_stats` | View | Aggregation | Summarises trip stats grouped by pickup hour |

---

## Data Quality Tests

8 automated tests defined in `schema.yml` — all passing with **0 errors**:

| Test | Column | Model |
|---|---|---|
| `unique` | `vendorid` | stg_taxi_trips |
| `not_null` | `pickup_datetime` | stg_taxi_trips |
| `not_null` | `trip_duration` | stg_taxi_trips |
| `not_null` | `tip_percentage` | stg_taxi_trips |
| `not_null` | `payment_description` | fct_taxi_trips |
| `not_null` | `time_of_day` | fct_taxi_trips |
| `not_null` | `distance_category` | fct_taxi_trips |
| `not_null` | `trip_count` | agg_hourly_stats |

Run all tests with:

```bash
dbt test
```

Expected output:
```
PASS=8 WARN=0 ERROR=0 SKIP=0 TOTAL=8
```

---

## Project Structure

```
taxi_dbt/
├── models/
│   └── taxi/
│       ├── stg_taxi_trips.sql
│       ├── fct_taxi_trips.sql
│       ├── agg_hourly_stats.sql
│       └── schema.yml
├── dbt_project.yml
└── README.md
```

---

## How to Run

### Prerequisites
- PostgreSQL 18 with `taxidb` database loaded (see [Project 1](https://github.com/Brian-10-star/nyc-taxi-pipeline))
- Python 3.13
- dbt-postgres installed

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Brian-10-star/taxi-dbt.git
cd taxi-dbt

# 2. Install dbt
pip install dbt-postgres

# 3. Configure your database connection
# Create ~/.dbt/profiles.yml with the following:
```

```yaml
taxi_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      pass: yourpassword
      port: 5432
      dbname: taxidb
      schema: public
      threads: 1
```

```bash
# 4. Run all models
dbt run

# 5. Run all data quality tests
dbt test
```

---

## Data Source

| Detail | Value |
|---|---|
| Dataset | NYC Yellow Taxi Trip Records — January 2023 |
| Source table | `taxidb.taxi_trips` |
| Row count | 2,884,216 clean rows |
| Loaded by | [Project 1 — NYC Taxi Pipeline](https://github.com/Brian-10-star/nyc-taxi-pipeline) |

---

## Project Portfolio

This is Project 4 of 5 in my Data Engineering portfolio:

| # | Project | Tools |
|---|---|---|
| 1 | [NYC Taxi Pipeline](https://github.com/Brian-10-star/nyc-taxi-pipeline) | Python, Pandas, PostgreSQL |
| 2 | [Nairobi Weather Pipeline](https://github.com/Brian-10-star/weather-pipeline) | Python, REST API, PostgreSQL |
| 3 | [Airflow Weather DAG](https://github.com/Brian-10-star/weather-pipeline) | Apache Airflow, Cron, XCom |
| 4 | **dbt Data Warehouse** ← you are here | dbt, SQL, Data Modeling |
| 5 | Cloud Pipeline | GCP, Cloud Storage, Cloud Functions |

---

## Author

**Brian Mbugua Chira**
BSc Computer Science — Egerton University, Kenya (Expected 2028)

- GitHub: [github.com/Brian-10-star](https://github.com/Brian-10-star)
- LinkedIn: [linkedin.com/in/mbuguabrian](https://linkedin.com/in/mbuguabrian)
- Email: chirabrian1@gmail.com
