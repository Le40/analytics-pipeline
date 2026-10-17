import pandas as pd
from pathlib import Path
from collections.abc import Callable
from dataclasses import dataclass

from src.staging import validation
from src.staging import db

@dataclass(frozen=True)
class StagingConfig:
    csv_path: Path
    table_name: str
    expected_columns: frozenset[str]

    unique_key: tuple[str, ...] | None = None
    date_columns: tuple[str, ...] = ()
    csv_dtypes: dict[str, str] | None = None
    transform: Callable[[pd.DataFrame], pd.DataFrame] | None = None


def load_to_staging(config: StagingConfig) -> None:
    # READING
    df = pd.read_csv(config.csv_path, dtype=config.csv_dtypes)

    # VALIDATION
    validation.validate_structure(
        df=df,
        source_name=config.table_name,
        expected_columns=config.expected_columns,
    )

    # TRANSFORMATIONS
    # DATE COLUMNS
    for column in config.date_columns:
        df[column] = pd.to_datetime(df[column])
    # WHITE SPACES IN UNIQUE COLUMNS  
    if config.unique_key:
        for column in config.unique_key:
            if df[column].dtype == "object":
                df[column] = df[column].str.strip()
    # CUSTOM
    if config.transform is not None:
        df = config.transform(df)

    # VALIDATION
    validation.validate_keys(
        df=df,
        source_name=config.table_name,
        unique_key=config.unique_key
    )   

    # LOADING
    db.load_dataframe(
        df=df,
        schema_name="stg",
        table_name=config.table_name,
    )

    # LOAD VALIDATION
    source_row_count = len(df)
    loaded_row_count = db.get_row_count("stg", config.table_name)

    validation.validate_row_count(
        expected_count=source_row_count,
        actual_count=loaded_row_count,
        source_name=config.table_name,
    )