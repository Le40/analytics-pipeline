import os
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
SQL_DIR = PROJECT_ROOT / "sql"
DWH_LOADS_DIR = SQL_DIR / "loads"

SQL_SERVER = os.getenv("SQL_SERVER", r"(localdb)\MSSQLLocalDB")
SQL_DATABASE = os.getenv("SQL_DATABASE", "EcommerceAnalytics")

CONNECTION_STRING = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={SQL_SERVER};"
    f"DATABASE={SQL_DATABASE};"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)
