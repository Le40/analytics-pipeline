from dataclasses import dataclass

@dataclass
class TableMapping:
    source: str
    target: str
    columns: dict[str, str]  # Source column -> Target column

KEY_CHECKS: list[TableMapping] = [
    # --------------------------------------------------------------------------
    # FACTS:
    # --------------------------------------------------------------------------
    # ORDERS
    TableMapping(
        source="stg.orders",
        target="dw.fact_order",
        columns={
            "order_id": "order_id"
        }
    ),
    # ORDER ITEMS
    TableMapping(
        source="stg.order_items",
        target="dw.fact_order_item",
        columns={
            "order_id": "order_id",
            "order_item_id": "order_item_id"
        }
    ),
    # PAYMENTS
    TableMapping(
        source="stg.payments",
        target="dw.fact_payment",
        columns={
            "order_id": "order_id",
            "payment_sequential": "payment_sequential"
        }
    ),
    # REVIEWS
    TableMapping(
        source="stg.reviews",
        target="dw.fact_review",
        columns={
            "review_id": "review_id"
        }
    ),
    # --------------------------------------------------------------------------
    # DIMENSIONS:
    # --------------------------------------------------------------------------
    # CUSTOMER
    TableMapping(
        source="stg.customers",
        target="dw.dim_customer",
        columns={
            "customer_unique_id": "customer_unique_id"
        }
    ),
    # LOCATION
    TableMapping(
        source="stg.customers",
        target="dw.dim_location",
        columns={
            "customer_zip_code_prefix": "zip_code_prefix",
            "customer_city": "city",
            "customer_state": "state"
        }
    ),
    # PRODUCT
    TableMapping(
        source="stg.products",
        target="dw.dim_product",
        columns={
            "product_id": "product_id"
        }
    ),
    # SELLER
    TableMapping(
        source="stg.sellers",
        target="dw.dim_seller",
        columns={
            "seller_id": "seller_id"
        }
    )
]


FINANCIAL_CHECKS: list[TableMapping] = [
    # ORDER ITEMS
    TableMapping(
        source="stg.order_items",
        target="dw.fact_order_item",
        columns={
            "price": "price",
            "freight_value":"freight_value"
        }
    ),
    # PAYMENTS
    TableMapping(
        source="stg.payments",
        target="dw.fact_payment",
        columns={
            "payment_value": "payment_value"
        }
    )
]