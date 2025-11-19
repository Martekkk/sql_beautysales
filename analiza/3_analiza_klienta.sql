-- ANALIZA KLIENTA

-- Utworzenie tabeli z data ostatniego zamówienia, częstotliwością amawiania i wartością wszystkich zakupów
WITH customer_metrics AS (
  SELECT c.customer_id, c.name,
    MAX(o.order_date) AS last_order,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(oi.quantity*oi.unit_price) AS monetary
  FROM customers c
  LEFT JOIN orders o ON c.customer_id=o.customer_id
  LEFT JOIN order_items oi ON o.order_id=oi.order_id
  GROUP BY c.customer_id, c.name
)
SELECT *,
  	   (now()::date-last_order) AS recency_days
FROM customer_metrics
ORDER BY monetary DESC;
-- Najczęstrzym klientem jest Anna Kowalska, która wydała 81397.98,
-- natomiast klientem, który zamówił najmniej jest Tomasz Kamiński, który 
-- nie złożył ani jednego zamówienia.

-- Obliczenie średniej wartości zamówienia, średniej liczby zamówień by obliczyć
-- Customer Lifetime Value CLV=średnia wartość zamówienia*średnia liczba zamówień na klienta, 
-- aby przewidzieć całkowity przychód, jaki firma uzyska od klienta przez cały okres współpracy
WITH per_customer AS(
  SELECT c.customer_id,
    	 COALESCE(SUM(oi.quantity*oi.unit_price), 0) AS total_spent,
    	 COUNT(DISTINCT o.order_id) AS orders_count
  FROM customers c
  LEFT JOIN orders o ON c.customer_id=o.customer_id
  LEFT JOIN order_items oi ON o.order_id=oi.order_id
  GROUP BY 1
)
SELECT ROUND(AVG(CASE WHEN orders_count>0 THEN total_spent::numeric/orders_count 
	   ELSE 0 END), 2) AS avg_order_value,
       ROUND(AVG(orders_count)) AS avg_orders_per_customer,
       ROUND(AVG(CASE WHEN orders_count>0 THEN total_spent::numeric/orders_count 
	   ELSE 0 END)*AVG(orders_count), 2) AS approx_clv
FROM per_customer;
-- Średnia wartość zamówienia wynosi 9874.42, średnia liczba zamówień 4, a przewidywane CLV
-- wynosi 39793.92.

-- Nowi vs stali klienci
WITH customer_cohorts AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', MIN(o.order_date)) as first_order_month,
        COUNT(DISTINCT o.order_id) as order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    first_order_month,
    COUNT(*) as new_customers,
    COUNT(CASE WHEN order_count > 1 THEN 1 END) as returning_customers,
    ROUND(COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 / COUNT(*), 2) as retention_rate
FROM customer_cohorts
GROUP BY first_order_month
ORDER BY first_order_month;
/*
Utrzymanie klientów było bardzo wysokie w roku 2023, ale mocno spadło w 2024.  
Najlepsze miesiące osiągały 100% retencji.  
W 2024 pojawiły się miesiące z 0% powrotów.  
Trzy miesiące zanotowały retencję poniżej 40%.  
W przyszłości należy zbadać przyczyny spadku retencji, warto wdrożyć program lojalnościowy.  
Potrzebna jest lepsza komunikacja po zakupie.  
Warto przeanalizować, co powoduje pełną retencję w najlepszych miesiącach.
*/
