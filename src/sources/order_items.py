import pandas as pd
from src.config import ORDER_ITEMS_CSV, CREATE_ORDER_ITEMS_SQL
from src import ingestion

SOURCE_NAME = "order_items"

EXPECTED_COLUMNS: set[str] = {
    "order_id",
    "order_item_id",
    "product_id",
    "seller_id",
    "shipping_limit_date",
    "price",
    "freight_value",
}

UNIQUE_KEY: tuple[str, ...] = ("order_id", "order_item_id")

#################################################################################################

def transform(order_items: pd.DataFrame) -> pd.DataFrame:
    order_items["shipping_limit_date"] = pd.to_datetime(
        order_items["shipping_limit_date"]
    )
    return order_items

def run() -> None:
    ingestion.run_source(
        csv_path=ORDER_ITEMS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        unique_key=UNIQUE_KEY,
        create_table_sql=CREATE_ORDER_ITEMS_SQL,
        transform=transform
    )