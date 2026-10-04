import pyodbc
from pathlib import Path
import pandas as pd


CONNECTION_STRING = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=(localdb)\\MSSQLLocalDB;"
    "DATABASE=EcommerceAnalytics;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)


def test_connection() -> None:
    with pyodbc.connect(CONNECTION_STRING) as connection:
        cursor = connection.cursor()
        cursor.execute("SELECT DB_NAME()")
        database_name = cursor.fetchone()[0]

        print(f"Connected to database: {database_name}")

def execute_sql_file(file_path: Path) -> None:
    sql = file_path.read_text()

    with pyodbc.connect(CONNECTION_STRING) as connection:
        cursor = connection.cursor()
        cursor.execute(sql)
        connection.commit()

def load_dataframe(
    df: pd.DataFrame,
    schema_name: str,
    table_name: str,
) -> None:
    columns = list(df.columns)

    column_names = ", ".join(columns)
    placeholders = ", ".join("?" for _ in columns)

    sql = (
        f"INSERT INTO {schema_name}.{table_name} "
        f"({column_names}) "
        f"VALUES ({placeholders})"
    )

    rows = []

    for row in df.itertuples(index=False, name=None):
        converted_row = tuple(
            None if pd.isna(value)
            else value.to_pydatetime() if isinstance(value, pd.Timestamp)
            else value
            for value in row
        )

        rows.append(converted_row)


    with pyodbc.connect(CONNECTION_STRING) as connection:
        cursor = connection.cursor()
        cursor.fast_executemany = True

        cursor.execute(f"TRUNCATE TABLE {schema_name}.{table_name}")
        cursor.executemany(sql, rows)

        connection.commit()

def get_row_count(
    schema_name: str,
    table_name: str,
) -> int:
    with pyodbc.connect(CONNECTION_STRING) as connection:
        cursor = connection.cursor()

        cursor.execute(
            f"SELECT COUNT(*) FROM {schema_name}.{table_name}"
        )

        return cursor.fetchone()[0]