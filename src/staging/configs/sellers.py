import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "sellers"
CSV_PATH = RAW_DATA_DIR / "olist_sellers_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "seller_id",
    "seller_zip_code_prefix",
    "seller_city",
    "seller_state",
}

UNIQUE_KEY: tuple[str, ...] = ("seller_id",)

CSV_DTYPES: dict[str, str] = {
    "seller_zip_code_prefix": "string"
}


def transform(sellers: pd.DataFrame) -> pd.DataFrame:
    sellers = sellers.copy()

    sellers["seller_zip_code_prefix"] = (
        sellers["seller_zip_code_prefix"]
        .str.zfill(5)
    )
    return sellers


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY,
    csv_dtypes=CSV_DTYPES,
    transform=transform
)