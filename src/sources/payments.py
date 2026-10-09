import pandas as pd
from src.config import PAYMENTS_CSV
from src import ingestion

SOURCE_NAME = "payments"

EXPECTED_COLUMNS: set[str] = {
    "order_id",
    "payment_sequential",
    "payment_type",
    "payment_installments",
    "payment_value",
}

UNIQUE_KEY: tuple[str, ...] = ("order_id", "payment_sequential")

#################################################################################################

def transform(payments: pd.DataFrame) -> pd.DataFrame:

    return payments

def run() -> None:
    ingestion.run_source(
        csv_path=PAYMENTS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        transform=transform,
        unique_key=UNIQUE_KEY
    )