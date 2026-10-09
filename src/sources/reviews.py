import pandas as pd
from src.config import REVIEWS_CSV
from src import ingestion

SOURCE_NAME = "reviews"

EXPECTED_COLUMNS: set[str] = {
    "review_id",
    "order_id",
    "review_score",
    "review_comment_title",
    "review_comment_message",
    "review_creation_date",
    "review_answer_timestamp",
}

UNIQUE_KEY = None

DATE_COLUMNS: tuple[str, ...] = (
    "review_creation_date",
    "review_answer_timestamp",
)

#################################################################################################

def transform(reviews: pd.DataFrame) -> pd.DataFrame:
    for col_name in DATE_COLUMNS:
        reviews[col_name] = pd.to_datetime(reviews[col_name])

    return reviews

def run() -> None:
    ingestion.run_source(
        csv_path=REVIEWS_CSV,
        source_name=SOURCE_NAME,
        expected_columns=EXPECTED_COLUMNS,
        transform=transform,
        unique_key=UNIQUE_KEY
    )