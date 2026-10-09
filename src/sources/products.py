import pandas as pd

from src.config import PRODUCTS_CSV
from src import ingestion


SOURCE_NAME = "products"

EXPECTED_COLUMNS: set[str] = {
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


def transform(products: pd.DataFrame) -> pd.DataFrame:
    return products


def run() -> None:
    ingestion.run_source(
        csv_path=PRODUCTS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        transform=transform,
        unique_key=UNIQUE_KEY
    )