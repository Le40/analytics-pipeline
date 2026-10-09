import pandas as pd
from pathlib import Path
from collections.abc import Callable

from src import validation, db

def run_source(
        csv_path: Path,
        source_name : str,
        expected_columns : set[str],
        transform: Callable[[pd.DataFrame], pd.DataFrame],
        unique_key: tuple[str,...] | None,
        csv_dtypes: dict[str, str] | None = None,
):
    df = pd.read_csv(csv_path, dtype=csv_dtypes)

    validation.validate_source(
            df=df,
            source_name=source_name,
            expected_columns=expected_columns,
            unique_key=unique_key
        )

    df = transform(df)

    db.load_dataframe(
        df=df,
        schema_name="stg",
        table_name=source_name,
    )

    source_row_count = len(df)
    loaded_row_count = db.get_row_count("stg", source_name)

    validation.validate_row_count(
        expected_count=source_row_count,
        actual_count=loaded_row_count,
        source_name=source_name,
    )