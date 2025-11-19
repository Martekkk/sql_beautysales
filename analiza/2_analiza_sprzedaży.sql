-- ANALIZA SPRZEDAŻY

-- Top 10 najlepiej sprzedających się produktów
SELECT p.product_name, p.category,
       SUM(oi.quantity) AS total_sold,
       ROUND(SUM(oi.quantity*oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_name, p.category
ORDER BY 3 DESC
LIMIT 10;
--ranking top 10 najlepiej sprzedających się produktów prezętuje się następująco
-- 1. "Pomadka matowa"	"Makijaż"	4404	817998.96
-- 2. "Baza pod makijaż"	"Makijaż"	4400	611160.00
-- 3. "Krem z filtrem SPF50"	"Pielęgnacja"	3600	625629.06
-- 4. "Tonik oczyszczający"	"Pielęgnacja"	3514	704731.00
-- 5. "Cień do powiek paleta"	"Makijaż"	3200	358912.00
-- 6. "Podkład płynny"	"Makijaż"	2491	22070.26
-- 7. "Płatki kosmetyczne"	"Pielęgnacja"	1044	136920.60
-- 8. "Krem nawilżający"	"Pielęgnacja"	804	76455.32
-- 9. "Krem do stóp"	"Pielęgnacja"	800	127040.00
-- 10. "Balsam do ciała"	"Pielęgnacja"	800	256383.18

-- Ranking miast pod względem dochodu
SELECT c.city, round(SUM(oi.quantity*oi.unit_price),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
GROUP BY c.city
ORDER BY revenue DESC;
-- Na pierwszym miejscu plasuje się Lublin z dochodem równym 219031.71, 
-- a na ostatnim (8 miejscu) Łódź z dochodem równym 36531.72.

-- Obliczenie top 10 pozycji pod względem przychodu wraz z wyliczonym dochodem i kosztami produktów
SELECT p.product_name,
       ROUND(SUM(oi.quantity*oi.unit_price)-SUM(oi.quantity * p.cost),2) AS profit,
       ROUND(SUM(oi.quantity*oi.unit_price), 2) AS revenue,
       ROUND(SUM(oi.quantity*p.cost),2) AS tot_cost
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 10;
-- Na pierwszym miejscu mamy Tonik oczyszczający z przychodem 559813.64, dochodem 704731.00 oraz kosztem 144917.36
-- na drugim miejscu mamy bazę pod makijaż, która była również na 2 miejscu w przypadku rankingu 
-- najczęściej sprzedających się produktów. Krem z filtrem SPF50 również nie zmienił
-- swojej pozycji w rankigu. A więc często za ilością idzie też większy zysk, chociaż nie w 
-- każdym przypadku

-- Zestawienie najczęściej kupowanych produktów razem
WITH pairs AS (
  SELECT oi1.product_id AS base_product, oi2.product_id AS bought_with, 
  		 COUNT(DISTINCT oi1.order_id) AS cnt
  FROM order_items oi1
  JOIN order_items oi2 ON oi1.order_id=oi2.order_id AND oi1.product_id<>oi2.product_id
  WHERE oi1.product_id=1
  GROUP BY oi1.product_id, oi2.product_id
)
SELECT p.product_name AS base_name, p2.product_name AS with_name, cnt
FROM pairs
JOIN products p ON pairs.base_product=p.product_id
JOIN products p2 ON pairs.bought_with=p2.product_id
ORDER BY cnt DESC
LIMIT 10;
/* Najczęściej kupowanymi razem produktami są:
Błyszczyk do ust i Tonik oczyszczający
Błyszczyk do ust i Podkład płynny
Błyszczyk do ust i Krem nawilżający
Błyszczyk do ust i Pomadka matowa*/

-- Analiza kategorii produktów
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) as product_count,
    SUM(oi.quantity) as total_sold,
    ROUND(SUM(oi.quantity*oi.unit_price), 2) as revenue,
    ROUND(SUM(oi.quantity*oi.unit_price)-SUM(oi.quantity*p.cost), 2) as profit,
    ROUND(AVG(oi.unit_price), 2) as avg_sale_price,
    ROUND(SUM(oi.quantity*oi.unit_price)*100/ 
         (SELECT SUM(quantity*unit_price) FROM order_items), 2) as revenue_percentage,
    ROUND((SUM(oi.quantity*oi.unit_price)-SUM(oi.quantity*p.cost))*100/
          (SELECT SUM(oi2.quantity*oi2.unit_price-oi2.quantity*p2.cost) 
           FROM order_items oi2 JOIN products p2 ON oi2.product_id=p2.product_id), 2) as profit_percentage,
    ROUND((SUM(oi.quantity*oi.unit_price)-SUM(oi.quantity*p.cost))*100/ 
          SUM(oi.quantity*oi.unit_price), 2) as profit_margin_percent
FROM products p
JOIN order_items oi ON p.product_id=oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;
/* Pielęgnacja przynosi najwięcej przychodu (51.22%).
Makijaż znajduje się na drugim miejscu, zysk to tylko 67 975 (gdzie 3.5% marży).
A więc występuje wysoka sprzedaż (15 000 sztuk), ale prawie zero zysku.
Włosy stanowią 0.05% udziału w całkowitej sprzedaży. Jest bardzo wysoka marża i bardzo 
mała sprzedaż.
W przyszłości warto inwestować w pielęgnację, zwiekszyć marżę na produkty z kategorii makijaż,
zadecydować co zrobić z kategorią włosy/