import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "customers"
CSV_PATH = RAW_DATA_DIR / "olist_customers_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "customer_id",
    "customer_unique_id",
    "customer_zip_code_prefix",
    "customer_city",
    "customer_state",
}

UNIQUE_KEY: tuple[str, ...] = ("customer_id",)

CSV_DTYPES: dict[str, str] = {
    "customer_zip_code_prefix": "string"
}

def transform(customers: pd.DataFrame) -> pd.DataFrame:

    customers = customers.copy()
    customers["customer_zip_code_prefix"] = (
        customers["customer_zip_code_prefix"]
        .str.zfill(5)
    )
    return customers

STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY,
    csv_dtypes=CSV_DTYPES,
    transform=transform
)
