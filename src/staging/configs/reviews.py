import pandas as pd
from src.config import RAW_DATA_DIR
from src.staging.ingestion import StagingConfig

TABLE_NAME = "reviews"
CSV_PATH = RAW_DATA_DIR / "olist_order_reviews_dataset.csv"

EXPECTED_COLUMNS: frozenset[str] = {
    "review_id",
    "order_id",
    "review_score",
    "review_comment_title",
    "review_comment_message",
    "review_creation_date",
    "review_answer_timestamp",
}

DATE_COLUMNS: tuple[str, ...] = (
    "review_creation_date",
    "review_answer_timestamp",
)


STAGING_CONFIG = StagingConfig(
    csv_path=CSV_PATH,
    table_name=TABLE_NAME,
    expected_columns=EXPECTED_COLUMNS,
    date_columns=DATE_COLUMNS
)