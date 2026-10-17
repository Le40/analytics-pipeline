import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "orders"
CSV_PATH = RAW_DATA_DIR / "olist_orders_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "order_id",
    "customer_id",
    "order_status",
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
}

UNIQUE_KEY: tuple[str, ...] = ("order_id",)

DATE_COLUMNS: tuple[str,...] = (
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
)


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY,
    date_columns=DATE_COLUMNS
)