import pyodbc
from pathlib import Path
from datetime import date
from src.db import CONNECTION_STRING
from src.dwh_reconciliation.config import KEY_CHECKS, FINANCIAL_CHECKS


def reconcile_keys(cursor: pyodbc.Cursor) -> int:
    """
    Check for missing and unexpected records between staging and DWH.

    Uses TableMapping configuration:
        source: Staging table
        target: DWH table
        columns: {source_column: target_column}

    Returns the number of missing and unexpected records.
    """

    errors = 0

    for check in KEY_CHECKS:

        source_columns = ", ".join(check.columns.keys())
        target_columns = ", ".join(check.columns.values())

        comparisions = [
            ("Missing", check.source, source_columns,
                        check.target, target_columns),
            ("Unexpected",   check.target, target_columns,
                        check.source, source_columns)          
        ]

        for name, left_table, left_columns, right_table, right_columns in comparisions:

            sql = f"""
                SELECT COUNT(*)
                FROM (
                    SELECT {left_columns} FROM {left_table}
                    EXCEPT
                    SELECT {right_columns} FROM {right_table}
                ) AS differences
            """

            cursor.execute(sql)
            count = cursor.fetchone()[0]

            print(f"{check.target} | {name}: {count}")
            errors += count

    return errors

def reconcile_financials(cursor: pyodbc.Cursor) -> int:
    """
    Compare financial totals between staging and DWH.

    Uses TableMapping configuration:
        source: Staging table
        target: DWH table
        columns: {source_column: target_column}

    Returns the number of failed comparisons.
    """

    errors = 0

    for check in FINANCIAL_CHECKS:
        for source_column, target_column in check.columns.items():

            sql = f"""
                SELECT 
                    (SELECT COALESCE(SUM({source_column}), 0) FROM {check.source}),
                    (SELECT COALESCE(SUM({target_column}), 0) FROM {check.target})
            """

            cursor.execute(sql)
            source_total, target_total = cursor.fetchone()

            name = f"{check.target}.{target_column}"

            if source_total != target_total:
                errors += 1
                print(f"{name} | FAIL | Source: {source_total}, DWH: {target_total}")
            else:
                print(f"{name} | PASS | Total: {source_total}")

    return errors

def reconcile_dates(cursor: pyodbc.Cursor) -> int:
    """Verify that the DWH contains every date within the staging date range."""

    min_date, max_date = _get_source_date_range(cursor)

    expected_days = (max_date - min_date).days + 1
    actual_days = _count_unique_dates(cursor, min_date, max_date)

    missing_days = expected_days - actual_days

    if missing_days:
        print(f"DATES | FAIL | Missing: {missing_days}")
    else:
        print(f"DATES | PASS | Missing: 0")

    return missing_days


def _count_unique_dates(cursor: pyodbc.Cursor, min_date: date, max_date: date) -> int:

    sql = """
        SELECT COUNT(DISTINCT full_date)
        FROM dw.dim_date
        WHERE full_date BETWEEN ? AND ?
    """

    cursor.execute(sql, min_date, max_date)
    return cursor.fetchone()[0]


def _get_source_date_range(cursor: pyodbc.Cursor) -> tuple[date, date]:

    sql = """
        SELECT MIN(full_date), MAX(full_date)
        FROM stg.v_source_dates
    """

    cursor.execute(sql)
    min_date, max_date = cursor.fetchone()

    if min_date is None or max_date is None:
        raise ValueError("No source dates available for reconciliation.")

    return min_date, max_date

def reconcile_translations(cursor: pyodbc.Cursor) -> int:
    """Validate category coverage, translation accuracy, and consistency."""

    sql_path = Path(__file__).with_name("translations.sql")
    sql = sql_path.read_text(encoding="utf-8")

    cursor.execute(sql)
    missing, incorrect, inconsistent = cursor.fetchone()

    print(f"TRANSLATIONS | Missing categories: {missing}")
    print(f"TRANSLATIONS | Incorrect translations: {incorrect}")
    print(f"TRANSLATIONS | Inconsistent products: {inconsistent}")

    return missing + incorrect + inconsistent


def main() -> None:
    with pyodbc.connect(CONNECTION_STRING) as connection:
        cursor = connection.cursor()

        errors = 0
        errors += reconcile_keys(cursor)
        errors += reconcile_financials(cursor)
        errors += reconcile_dates(cursor)
        errors += reconcile_translations(cursor)

    if errors:
        raise SystemExit("RECONCILIATION FAILED")

    print("RECONCILIATION PASSED")


if __name__ == "__main__":
    main()