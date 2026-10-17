import pyodbc
from src.config import CONNECTION_STRING
from src.warehouse import warehouse_pipeline


def get_row_counts() -> dict[str, int]:
    counts = {}

    connection = pyodbc.connect(CONNECTION_STRING)

    try:
        cursor = connection.cursor()

        # Get all warehouse tables
        cursor.execute("""
            SELECT t.name
            FROM sys.tables t
            JOIN sys.schemas s ON t.schema_id = s.schema_id
            WHERE s.name = 'dw'
        """)

        tables = [row[0] for row in cursor.fetchall()]

        # Count records in each table
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM dw.[{table}]")
            counts[f"dw.{table}"] = cursor.fetchone()[0]

    finally:
        connection.close()

    return counts


def test_warehouse_idempotency():
    before = get_row_counts()

    warehouse_pipeline.load_warehouse()

    after = get_row_counts()

    assert before == after