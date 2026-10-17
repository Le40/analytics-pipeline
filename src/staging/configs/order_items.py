import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "order_items"
CSV_PATH = RAW_DATA_DIR / "olist_order_items_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "order_id",
    "order_item_id",
    "product_id",
    "seller_id",
    "shipping_limit_date",
    "price",
    "freight_value",
}

UNIQUE_KEY: tuple[str, ...] = ("order_id", "order_item_id")

DATE_COLUMNS: tuple[str,...] = (
        "shipping_limit_date",
)


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY,
    date_columns=DATE_COLUMNS
)