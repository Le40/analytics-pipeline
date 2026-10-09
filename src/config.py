from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

ORDERS_CSV = RAW_DATA_DIR / "olist_orders_dataset.csv"
ORDER_ITEMS_CSV = RAW_DATA_DIR / "olist_order_items_dataset.csv"
PAYMENTS_CSV = RAW_DATA_DIR / "olist_order_payments_dataset.csv"
REVIEWS_CSV = RAW_DATA_DIR / "olist_order_reviews_dataset.csv"

CUSTOMERS_CSV = RAW_DATA_DIR / "olist_customers_dataset.csv"
SELLERS_CSV = RAW_DATA_DIR / "olist_sellers_dataset.csv"
PRODUCTS_CSV = RAW_DATA_DIR / "olist_products_dataset.csv"
CATEGORY_TRANSLATION_CSV = RAW_DATA_DIR / "product_category_name_translation.csv"

SQL_DIR = PROJECT_ROOT / "sql"
