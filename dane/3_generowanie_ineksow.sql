-- GENEROWANIE INDEKSÓW

-- 1. Indeksy pomocnicze
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orderitems_order ON order_items(order_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_customers_city ON customers(city);

-- 2.Sprawdzenie kilku selectów, aby widzieć czy dane są poprawne
SELECT
  (SELECT COUNT(*) FROM customers) AS customers,
  (SELECT COUNT(*) FROM suppliers) AS suppliers,
  (SELECT COUNT(*) FROM products) AS products,
  (SELECT COUNT(*) FROM inventory) AS inventory_rows,
  (SELECT COUNT(*) FROM discounts) AS discounts,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM order_items) AS order_items,
  (SELECT COUNT(*) FROM payments) AS payments,
  (SELECT COUNT(*) FROM reviews) AS reviews;
