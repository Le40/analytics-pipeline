import pandas as pd
from src.config import ORDERS_CSV, CREATE_ORDERS_SQL
from src import ingestion

SOURCE_NAME = "orders"

EXPECTED_COLUMNS: set[str] = {
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

#################################################################################################

def transform(orders: pd.DataFrame) -> pd.DataFrame:

    for col_name in DATE_COLUMNS:
        orders[col_name] = pd.to_datetime(orders[col_name])

    return orders

def run() -> None:
    ingestion.run_source(
        csv_path=ORDERS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        unique_key=UNIQUE_KEY,
        create_table_sql=CREATE_ORDERS_SQL,
        transform=transform
    )