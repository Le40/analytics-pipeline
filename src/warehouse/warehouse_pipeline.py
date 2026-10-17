import pyodbc
from src.config import DWH_LOADS_DIR, CONNECTION_STRING
from src.warehouse.reconciliation.reconcile import reconcile

DW_LOAD_FILES = (
    "load_ref_category_translation.sql",
    "load_dim_date.sql",
    "load_dim_customer.sql",
    "load_dim_location.sql",
    "load_dim_product.sql",
    "load_dim_seller.sql",
    "load_fact_order.sql",
    "load_fact_order_item.sql",
    "load_fact_payment.sql",
    "load_fact_review.sql",
)


def execute_load_scripts(cursor: pyodbc.Cursor) -> None:
    for file_name in DW_LOAD_FILES:
        print(f"Executing {file_name}...", flush=True)

        sql = (DWH_LOADS_DIR / file_name).read_text(encoding="utf-8")
        cursor.execute(sql)

def load_warehouse() -> None:
    connection = pyodbc.connect(CONNECTION_STRING)

    try:
        cursor = connection.cursor()
        execute_load_scripts(cursor)
        errors = reconcile(cursor)

        if errors != 0:
            raise RuntimeError(f"DWH reconciliation failed: {errors} errors")

        connection.commit()
        print("Warehouse loading completed")

    except Exception:
        connection.rollback()
        raise

    finally:
        connection.close()

if __name__ == "__main__":
    load_warehouse()