import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig


TABLE_NAME = "products"
CSV_PATH = RAW_DATA_DIR / "olist_products_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "product_id",
    "product_category_name",
    "product_name_lenght",
    "product_description_lenght",
    "product_photos_qty",
    "product_weight_g",
    "product_length_cm",
    "product_height_cm",
    "product_width_cm",
}

UNIQUE_KEY: tuple[str, ...] = ("product_id",)


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    unique_key=UNIQUE_KEY
)