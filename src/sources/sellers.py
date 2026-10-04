import pandas as pd

from src.config import SELLERS_CSV, CREATE_SELLERS_SQL
from src import ingestion


SOURCE_NAME = "sellers"

EXPECTED_COLUMNS: set[str] = {
    "seller_id",
    "seller_zip_code_prefix",
    "seller_city",
    "seller_state",
}

UNIQUE_KEY: tuple[str, ...] = ("seller_id",)


def transform(sellers: pd.DataFrame) -> pd.DataFrame:
    return sellers


def run() -> None:
    ingestion.run_source(
        csv_path=SELLERS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        unique_key=UNIQUE_KEY,
        create_table_sql=CREATE_SELLERS_SQL,
        transform=transform,
    )