# E-Commerce Analytics Pipeline

A portfolio data engineering and analytics project built with **Python, pandas, SQL Server, and Power BI** using the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

**Current status:** The Python ingestion pipeline, SQL Server dimensional warehouse, automated loading, data validation, and reconciliation are implemented. The project also includes SQL business analysis and a Power BI dashboard.

## Architecture

```text
Olist CSV files (8 datasets)
        |
        v
Python / pandas
  - source validation
  - data cleaning and type conversion
        |
        v
SQL Server staging (stg)
  - full refresh of source tables
        |
        v
SQL Server dimensional warehouse (dw)
  - SQL dimension and fact loaders
  - reconciliation before commit
        |
        +----> SQL business analysis
        |        - seller handover performance
        |        - delivery delays
        |
        +----> Power BI
                 - Sales Overview
                 - Shipping & Delivery
                 - Customer Satisfaction
```

Run the batch pipeline with a single command (`python main.py`). Staging ingestion runs first; warehouse SQL scripts then execute within a shared database transaction. Warehouse changes are **committed only if reconciliation passes**, and rolled back on failure.

## Technologies

- **Python / pandas:** CSV ingestion, validation, and standardization
- **SQL Server / T-SQL:** staging tables, dimensional model, loading scripts, and reconciliation
- **pyodbc:** Python–SQL Server connection and data loading
- **pytest:** local integration tests for repeated loading and transaction rollback
- **Power BI:** Dimensional data model, DAX measures, interactive reports, and row-level security (RLS)

## Dimensional model

| Table | Grain / purpose |
| --- | --- |
| `dw.fact_order` | One row per order |
| `dw.fact_order_item` | One row per order item (`order_id`, `order_item_id`) |
| `dw.fact_payment` | One row per payment sequence (`order_id`, `payment_sequential`) |
| `dw.fact_review` | One row per review (`review_id`) |
| `dw.dim_customer` | Unique customer identity |
| `dw.dim_product` | Product attributes and translated categories |
| `dw.dim_seller` | Seller attributes |
| `dw.dim_location` | Customer ZIP-prefix, city, and state combination |
| `dw.dim_date` | Calendar dates used by the fact tables |
| `dw.ref_category_translation` | Portuguese-to-English product category lookup, including two missing source translations |

The fact tables have **different grains**. Orders, order items, and payments must not be joined directly and summed indiscriminately: multiple items and payments per order can multiply measures. Analysis will respect each fact's grain or aggregate to the appropriate level first.

## Pipeline structure

```text
main.py
src/
  config.py
  staging/
    staging_pipeline.py     # Load all staging configurations
    ingestion.py            # Read, transform, validate and load one CSV
    validation.py
    db.py
    configs/                # Configuration and optional per-source transforms
  warehouse/
    warehouse_pipeline.py   # Execute SQL, reconcile, commit / roll back
    reconciliation/         # Key, financial, date and translation checks
sql/ 
  loads/                    # Data warehouse loading scripts
  analysis/                 # SQL business analysis and findings
powerbi/                    # Power BI project, documentation and screenshots
docs/                       # Additional project documentation
database/                   # SQL Server database project / schema definitions
tests/                      # Integration tests
```

The project loads the Olist orders, customers, order items, payments, reviews, products, sellers, and category-translation CSV files. The Olist geolocation file is not currently ingested.

## Data quality and reliability

- **Before staging:** check required columns and nonempty input; standardize configured dates and selected keys; validate null, blank, and duplicate keys.
- **After staging:** check loaded row counts.
- **In the warehouse:** enforce database primary-key, unique, foreign-key, and check constraints.
- **Reconciliation:** compare expected and actual business keys, financial totals (item price, freight, payments), date coverage, and product-category translations.
- **Atomic warehouse load:** execute warehouse scripts and reconciliation on one connection; commit only on success.
- **Reruns:** warehouse loaders avoid inserting existing business keys; a pytest integration test checks that a repeated load does not change table row counts.

### Current scope and limitations

This is a **batch pipeline** using a static source dataset. Staging uses a full reload, while warehouse loaders insert records that do not already exist. Updates or deletions of existing warehouse rows are **not** handled incrementally. The idempotency test compares table row counts; it is not a full row-by-row comparison. GitHub Actions CI is not configured because the integration tests currently depend on a local SQL Server database.

## Analytics and Reporting

The project includes two analytical outputs:

**SQL analysis**

SQL queries investigate seller handover performance, delivery delays, and other findings from the dataset. The seller analysis compares shipping deadline compliance across sellers and examines its relationship with late deliveries.

See [SQL Analysis](sql/analysis/README.md) for the queries, findings, and recommendations.

**Power BI dashboard**

The dashboard contains three report pages:

- **Sales Overview:** Revenue, orders, products, and sales performance.
- **Shipping & Delivery:** Delivery times, late deliveries, and shipping performance.
- **Customer Satisfaction:** Review scores and relationships between delivery performance and customer reviews.

The report uses a dimensional model with DAX measures and includes a sample regional row-level security role.

See [Power BI Report](powerbi/README.md) for details and screenshots.

## Running locally

**Prerequisites:** Python, SQL Server LocalDB or another SQL Server instance, and Microsoft ODBC Driver 18 for SQL Server.

1. Clone the repository and create a Python virtual environment.
2. Install dependencies:

   ```powershell
   python -m pip install -r requirements.txt
   ```

3. Download the Olist CSV files and place the eight required files in `data/raw/` (see `src/staging/configs/` for expected filenames).
4. Configure the database connection in `src/config.py` to point to your SQL Server database.
5. Create/publish the SQL Server database schema using the project under `database/` before the initial load. This includes the `stg` and `dw` objects and the staging date view used by reconciliation.
6. From the repository root, run:

   ```powershell
   python main.py
   ```

   The command loads staging first, then runs the warehouse SQL scripts and reconciliation.

### Integration tests

```powershell
python -m pytest -v
```

- **Idempotency:** checks that another warehouse load does not change DWH table counts.
- **Rollback:** injects a controlled failure during warehouse loading and verifies that its database change is rolled back.

**Note:** These are real database integration tests, not isolated unit tests. Run them only against a local/development database configured for testing.

