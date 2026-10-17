import pytest
import pyodbc

from src.config import CONNECTION_STRING
from src.warehouse import warehouse_pipeline


def table_exists() -> bool:
    connection = pyodbc.connect(CONNECTION_STRING)

    try:
        cursor = connection.cursor()
        cursor.execute(
            "SELECT OBJECT_ID('dbo._rollback_test', 'U')"
        )
        return cursor.fetchone()[0] is not None
    finally:
        connection.close()


def test_warehouse_rollback(monkeypatch):

    assert not table_exists()

    # Replace the normal SQL loader with a deliberately failing one
    def failing_loader(cursor):
        cursor.execute("CREATE TABLE dbo._rollback_test (id INT)")
        raise RuntimeError("Simulated failure")

    monkeypatch.setattr(
        warehouse_pipeline,
        "execute_load_scripts",
        failing_loader
    )

    # The warehouse pipeline must propagate the error
    with pytest.raises(RuntimeError, match="Simulated failure"):
        warehouse_pipeline.load_warehouse()

    # The newly created table must have been rolled back
    assert not table_exists()