--ANALIZA FINANSOWA

-- całkowite przychody (sumarycznie)
SELECT ROUND(SUM(oi.quantity*oi.unit_price),2) AS total_revenue
FROM order_items oi;
-- Całkowita wartość zamówień wyniosła 4025324.12.

-- średnia wartość zamówienia
SELECT ROUND(AVG(order_value), 2) AS avg_order_value
FROM (
  SELECT o.order_id, SUM(oi.quantity*oi.unit_price) AS order_value
  FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
  GROUP BY o.order_id
) tab;
-- Średnia wartość zamówienia wyniosła 9988.40.

-- Obliczenie łącznej marży
SELECT ROUND(SUM(oi.quantity*oi.unit_price)-SUM(oi.quantity*p.cost), 2) AS total_profit
FROM order_items oi 
JOIN products p ON oi.product_id=p.product_id;
-- Całkowita marża wyniosła 1087469.13.

-- Analiza trendów sprzedaży, pokazując jak przychody zmieniają się z miesiąca na miesiąc.
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month,
       ROUND((revenue-LAG(revenue) OVER (ORDER BY month))::numeric, 2) AS change
FROM 
(
  SELECT date_trunc('month', o.order_date)::date AS month,
         ROUND(SUM(oi.quantity*oi.unit_price), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id=oi.order_id
  GROUP BY month
  ORDER BY month
) tab;
-- Występuje duża zmienność, przychody mocno wahają się między miesiącami. Możliwe cykliczne spadki i wzrosty

-- Porównanie sprzedaży z rabatami i bez rabatów 
WITH with_discount AS 
(
  SELECT oi.*,
    p.price,
    CASE WHEN oi.unit_price<p.price THEN 1
	ELSE 0 END AS had_discount
  FROM order_items oi
  JOIN products p ON oi.product_id=p.product_id
)

SELECT had_discount,
       SUM(quantity*unit_price) AS revenue,
       SUM(quantity) AS units,
       ROUND(100.0*SUM(quantity*unit_price)/(SELECT SUM(quantity*unit_price) 
	   		 FROM with_discount), 2) AS revenue_proc,
	   ROUND(100.0*SUM(quantity)/(SELECT SUM(quantity) 
	   		 FROM with_discount), 2) AS revenue_proc
FROM with_discount
GROUP BY had_discount;
-- Jest aż 98.48% przychodów z pełnej ceny. Pomimo wysokiej marży, klienci są gotowi 
-- płacić pełną cenę. Produkty nie potrzebują rabatów, żeby się sprzedawać co mówi 
-- o dobrej jakości produktów. 
-- Rabaty są stosowane bardzo ostrożnie.

-- Sprawdzenie, które produkty były rabatowane
SELECT p.product_name, 
       SUM(oi.quantity) as units_sold,
       ROUND(AVG(p.price-oi.unit_price), 2) as avg_discount
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
WHERE oi.unit_price<p.price
GROUP BY p.product_name;
-- Rabat był udzielany na Serum witaminowe, Krem do stóp, Tonik oczyszczający
-- Błyszczyk do ust, Krem nawilżający, Krem z filtrem SPF50, Balsam do ciała

-- Analiza metod płatności
SELECT 
    payment_method,
    COUNT(*) as transaction_count,
    ROUND(SUM(amount), 2) as total_amount,
    ROUND(AVG(amount), 2) as avg_amount,
    ROUND(100*SUM(amount)/(SELECT SUM(amount) FROM payments), 2) as percentage
FROM payments 
GROUP BY payment_method 
ORDER BY total_amount DESC;
-- Żadna metoda płatności nie dominuje (wartości są w przedziale od 24% do 26%), 
-- co świadczy o dobrym zróżnicowaniu. Pomimo najmniejszej liczby transakcji, 
-- BLIK ma najwyższą średnią wartość (1054.86 PLN). Karta ma najwięcej transakcji (104) 
-- i najwyższą łączną kwotę (105 591.46 PLN). Gotówka ma drugą najwyższą średnią wartość,
-- co może wskazywać na zaufanie klientów.
-- Działania warte podjęcia: promocje dla BLIK(wykorzystać wysoką średnią wartość transakcji),
-- zachęcać do używania kart (już popularne, warto utrzymać tę tendencję), 
-- monitorować przelewy, czy niska średnia to szansa czy ryzyko