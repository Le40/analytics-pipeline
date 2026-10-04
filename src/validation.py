import pandas as pd

def validate_source(
        df: pd.DataFrame, 
        source_name: str,
        expected_columns: set[str],
        unique_key: tuple[str,...] | None = None
) -> None:
    
    missing_columns = expected_columns - set(df.columns)

    if missing_columns:
        raise ValueError(
            f"{source_name} source is missing required columns: "
            f"{sorted(missing_columns)}"
        )

    if df.empty:
        raise ValueError(f"{df.Name} source contains no rows.")

    if unique_key is not None:
        if df.duplicated(subset=list(unique_key)).any():
            raise ValueError(
                f"{source_name} source contains duplicate key values "
                f"for {list(unique_key)}."
            )

def validate_row_count(
    expected_count: int,
    actual_count: int,
    source_name: str,
) -> None:
    if expected_count != actual_count:
        raise RuntimeError(
            f"{source_name} load failed. "
            f"Expected {expected_count} rows, "
            f"but SQL contains {actual_count} rows."
        )
