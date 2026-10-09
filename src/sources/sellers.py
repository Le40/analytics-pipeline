import pandas as pd

from src.config import SELLERS_CSV
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
    sellers = sellers.copy()

    sellers["seller_zip_code_prefix"] = (
        sellers["seller_zip_code_prefix"]
        .astype("string")
        .str.zfill(5)
    )
    return sellers


def run() -> None:
    ingestion.run_source(
        csv_path=SELLERS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        transform=transform,
        unique_key=UNIQUE_KEY,
        csv_dtypes={"seller_zip_code_prefix": "string"}
    )