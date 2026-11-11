# Data Warehouse — Table Notes & Annotations

## FACT ORDER

**Grain:** One row per Olist `order_id` — representing a fulfillment record, not necessarily a complete customer purchase or one physical shipment.

**Foreign keys:**
- Customer
- Location
- Date — purchase
- Date — delivery

**Design notes:**
- Only purchase and delivery dates have dimension relationships.
- Other timestamps are retained for operational analysis.

**Risks / limitations:**
- One purchase may include multiple fulfillments.
- Counting `order_id` may therefore inflate purchase counts, repeat purchases, customer loyalty metrics, etc.
- Not every order is delivered → delivery date can be `NULL`.
- `order_status` represents the current order status in the source snapshot.

**Derived measures:**

| Measure | Calculation | Meaning |
|---|---|---|
| Seller processing duration | Carrier handoff − approval | Time before fulfillment leaves the seller |
| Shipping duration | Delivery − carrier handoff | Time from carrier handoff to delivery |
| Total delivery time | Delivery − purchase | Total time taken to deliver goods |
| Delivery variance | Delivery − estimated delivery | Positive = late; negative = early |

---

## FACT ORDER ITEM

**Grain:** One item within one fulfillment.

**PK:** `order_id + order_item_id` (item sequence within fulfillment).

**Foreign keys:**
- Product
- Seller
- Customer
- Location
- Date — purchase

**Design notes:**
- Only the purchase date has a date-dimension relationship.
- `shipping_limit_date` is an item-level shipping deadline related to the purchase.

**Risks / limitations:**
- One fulfillment can contain multiple items.
- Joining `fact_order_item` directly with `fact_payment` can multiply rows and inflate both item prices and payment totals.
- Shipping limit is an **item-level deadline**, while carrier handoff is recorded at the **fulfillment level**.
- Dispatch punctuality is therefore not fully reliable for seller-level analysis. One fulfillment can contain items from multiple sellers, so we cannot reliably determine which seller caused a delay.

**Base measures:**

| Measure | Calculation | Meaning |
|---|---|---|
| Product sales value | `SUM(price)` | Total value of products sold |
| Freight charged | `SUM(freight_value)` | Total shipping charges |
| Items sold | `COUNT(*)` | Number of order-item records |

**Derived measures:**
- **Dispatch punctuality:** Carrier handoff − shipping limit
  - Positive = late dispatch
  - Negative = early / on time
  - Limited reliability because of the difference in grain.

---

## FACT PAYMENT

**Grain:** One payment record within one fulfillment.

**PK:** `order_id + payment_sequential` (payment sequence).

**Foreign keys:**
- Customer
- Location
- Date — purchase

**Design notes:**
- Purchase date refers to when the fulfillment was placed, not when the payment was processed.
- We don't have an actual payment timestamp.

**Risks / limitations:**
- One fulfillment can contain multiple payment records.
- Joining `fact_order_item` directly with `fact_payment` can multiply rows and inflate both item prices and payment totals.
- `payment_value` represents the amount paid, not necessarily product revenue.
- `payment_installments` must not be confused with the number of payment records.

**Base measures:**

| Measure | Calculation | Meaning |
|---|---|---|
| Total paid | `SUM(payment_value)` | Total payment value |
| Payment count | `COUNT(*)` | Number of payment records |

**Derived measures:**
- **Payment method distribution:** Group by `payment_type` — payment preferences.
- **Multi-payment fulfillments:** Count fulfillments with multiple payment records — understand combined payment methods.

---

## FACT REVIEW

**Grain:** One row per `review_id`.

**PK:** `review_id`

**Foreign keys:**
- Customer
- Date — review sent/created
- Date — review answered

**Design notes:**
- A review appears to belong more naturally to a purchase-level entity, which doesn't exist explicitly in our model, than to an individual fulfillment.
- The table was deduplicated by `review_id`, retaining one record per review.
- Duplicate review IDs in the source can be associated with different fulfillments belonging to the same broader purchase.

**Risks / limitations:**
- The original source can associate one review with multiple fulfillments.
- Our warehouse retains only one fulfillment association, potentially losing information.
- Without a reliably reconstructed purchase entity or a review-to-fulfillment bridge, product-, seller-, and fulfillment-level satisfaction analysis can be misleading.

**Base measures:**
- **Review score:** Satisfaction rating (1–5). Average, not sum.
- **Review count:** `COUNT(*)` — one row per unique review.

**Derived measures:**

| Measure | Calculation | Meaning |
|---|---|---|
| Average review score | `AVG(review_score)` | Overall customer satisfaction |
| Review score distribution | Count by score (1–5) | Distribution of customer ratings |
| Survey response time | Answer timestamp − review creation timestamp | Time taken to respond to the survey |

---

## DIM CUSTOMER

**Grain:** One row per distinct `customer_unique_id` (one identifiable customer).

**PK:** `customer_key` — integer surrogate key.

**Business key:** `customer_unique_id` — original identifier from Olist.

**Design notes:**
- The source contains fulfillment-specific `customer_id` values.
- The warehouse consolidates these using `customer_unique_id`, assigning one surrogate `customer_key` per unique customer.
- All customer relationships in the warehouse use `customer_key`.

**Risks / limitations:**
- `order_id` ≠ purchase.
- One customer can have multiple orders/fulfillments that belong to a single purchase.
- Repeat-purchase and loyalty metrics based on `order_id` can therefore be misleading.

**Base measures:**
- **Number of customers:** `COUNT(*)` from `dim_customer` — total customers represented in the dimension.

---

## DIM LOCATION

**Grain:** One row per distinct location combination.

**PK:** `location_key` — integer surrogate key.

**Business key:** `(zip_code_prefix, city, state)` — enforced by a `UNIQUE` constraint.

**Design notes:**
- Each distinct location combination receives its own `location_key`.
- Locations are derived from `stg.customers`.
- Represents the recorded customer location associated with an order/fulfillment, not necessarily a verified delivery address.
- Fulfillment-related facts reference locations through `location_key`.

**Risks / limitations:**
- Geographic correctness of ZIP/city/state combinations hasn't been verified.
- Inconsistent city names or ZIP combinations may create multiple records for the same real-world location.
- Customer location should not automatically be interpreted as the exact delivery destination or permanent residence.

---

## DIM PRODUCT

**Grain:** One row per distinct `product_id`.

**PK:** `product_key` — integer surrogate key.

**Business key:** `product_id` — original Olist identifier.

**Design notes:**
- `product_key` replaces the long `product_id` in fact-table relationships.
- Product attributes include category and physical characteristics.
- English category names come from `ref_category_translation`.
- Product prices belong to `fact_order_item`, not `dim_product`, because prices can vary between sales.

**Risks / limitations:**
- **Translation dependency:** New product categories may lack English translations. The reference table needs maintenance.
- **Missing attributes:** Some products may have `NULL` categories, weights, or dimensions.

---

## DIM SELLER

**Grain:** One row per distinct `seller_id`.

**PK:** `seller_key` — integer surrogate key.

**Business key:** `seller_id` — original Olist identifier.

**Design notes:**
- `seller_key` replaces the long `seller_id` in fact-table relationships.
- Seller location (ZIP prefix, city, state) is stored directly in `dim_seller`, separately from customer locations in `dim_location`.
- A separate seller-location dimension isn't necessary because these attributes can be filtered and grouped directly.

**Risks / limitations:**
- Geographic correctness of ZIP/city/state combinations hasn't been verified.
- Inconsistent city spelling can affect geographic analysis.
- Seller location changes aren't tracked or updated by our current warehouse loading process.

---

## DIM DATE

**Grain:** One row per day.

**PK:** `date_key` — integer in `YYYYMMDD` format.

**Design notes:**
- Standard calendar dimension containing year, quarter, month, weekday, and other date attributes.
- `full_date` stores the actual SQL `DATE` value.
- Generated for every day between the minimum and maximum dates found in the source data.
- Shared across fact tables through their respective date foreign keys.

**Risks / limitations:**
- The date range is based on loaded source data. New dates outside that range require extending the dimension.
- `month_name` and `day_name` depend on SQL Server language settings when generated.

---

## REF CATEGORY TRANSLATION

**Grain:** One row per distinct original Portuguese product category.

**PK:** `product_category_name` — original Portuguese category name.

**Design notes:**
- Reference/lookup table, not a fact or dimension.
- Maps Portuguese product categories to English names.
- Populated from `stg.category_translation`.
- Two missing translations were added manually:
  - `pc_gamer`
  - `portateis_cozinha_e_preparadores_de_alimentos`
- Used to populate `dim_product.category_name_english`.
- The English name is stored directly in the product dimension for easier reporting.

**Risks / limitations:**
- New product categories may not have translations. The mapping must be maintained.
- Incorrect translations propagate into `dim_product`.
- Current loading logic inserts missing translations but doesn't update existing translations when their values change.
- `product_category_name_english` allows `NULL`.