import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "payments"
CSV_PATH = RAW_DATA_DIR / "olist_order_payments_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "order_id",
    "payment_sequential",
    "payment_type",
    "payment_installments",
    "payment_value",
}

UNIQUE_KEY: tuple[str, ...] = ("order_id", "payment_sequential")


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY
)