import pandas as pd

from src.config import CATEGORY_TRANSLATION_CSV
from src import ingestion


SOURCE_NAME = "category_translation"

EXPECTED_COLUMNS: set[str] = {
    "product_category_name",
    "product_category_name_english",
}

UNIQUE_KEY: tuple[str, ...] = ("product_category_name",)


def transform(category_translation: pd.DataFrame) -> pd.DataFrame:
    return category_translation


def run() -> None:
    ingestion.run_source(
        csv_path=CATEGORY_TRANSLATION_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        transform=transform,
        unique_key=UNIQUE_KEY
    )