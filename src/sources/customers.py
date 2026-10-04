import pandas as pd
from src.config import CUSTOMERS_CSV, CREATE_CUSTOMERS_SQL
from src import ingestion

SOURCE_NAME = "customers"

EXPECTED_COLUMNS: set[str] = {
    "customer_id",
    "customer_unique_id",
    "customer_zip_code_prefix",
    "customer_city",
    "customer_state",
}

UNIQUE_KEY: tuple[str, ...] = ("customer_id",)

#################################################################################################

def transform(customers: pd.DataFrame) -> pd.DataFrame:

    return customers

def run() -> None:
    ingestion.run_source(
        csv_path=CUSTOMERS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        unique_key=UNIQUE_KEY,
        create_table_sql=CREATE_CUSTOMERS_SQL,
        transform=transform
    )