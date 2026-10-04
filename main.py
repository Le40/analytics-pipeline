from src.sources import customers, order_items, orders, payments, products, sellers, reviews, category_translation


orders.run()
customers.run()
order_items.run()
payments.run()
reviews.run()
products.run()
sellers.run()
category_translation.run()

print("COMPLETE")