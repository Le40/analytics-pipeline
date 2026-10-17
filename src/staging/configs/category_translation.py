import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "category_translation"
CSV_PATH = RAW_DATA_DIR / "product_category_name_translation.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "product_category_name",
    "product_category_name_english",
}

UNIQUE_KEY: tuple[str, ...] = ("product_category_name",)


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY
)