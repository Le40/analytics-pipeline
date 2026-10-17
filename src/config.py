from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
SQL_DIR = PROJECT_ROOT / "sql"
DWH_LOADS_DIR = SQL_DIR / "loads"

CONNECTION_STRING = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=(localdb)\\MSSQLLocalDB;"
    "DATABASE=EcommerceAnalytics;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)
