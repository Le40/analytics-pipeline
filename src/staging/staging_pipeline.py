from time import perf_counter
from src.staging import ingestion
from src.staging.configs import (
    category_translation, customers, order_items, orders, 
    payments, products, sellers, reviews
)

STAGING_CONFIGS = [
    orders.STAGING_CONFIG,
    customers.STAGING_CONFIG,
    products.STAGING_CONFIG,
    sellers.STAGING_CONFIG,
    order_items.STAGING_CONFIG,
    payments.STAGING_CONFIG,
    reviews.STAGING_CONFIG,
    category_translation.STAGING_CONFIG
]

def load_staging() -> None:
    """Load all configured CSV sources into staging."""

    for config in STAGING_CONFIGS:
        print(f"Loading stg.{config.table_name}...", flush=True)

        start = perf_counter()
        ingestion.load_to_staging(config)

        elapsed = perf_counter() - start
        print(f"Completed stg.{config.table_name} ({elapsed:.1f}s)")


if __name__ == "__main__":
    load_staging()