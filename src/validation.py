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
        # check for nulls  
        if df[list(unique_key)].isna().any().any():
            raise ValueError(
                f"{source_name} source contains NULL values in key: {unique_key}"
            )

        # check for empty strings in id keys
        for col_name in unique_key:
            if df[col_name].dtype == "object":
                df[col_name] = df[col_name].str.strip()
                if df[col_name].eq("").any():
                    raise ValueError(
                        f"{source_name} contains blank values in key column: {col_name}"
                    )
        
        # check for duplicates
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
