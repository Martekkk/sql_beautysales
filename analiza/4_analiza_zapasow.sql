-- ANALIZA ZAPASÓW

-- Znalezienie produktów z najwyższym wskaźnikiem rotacji, 
-- czyli takich, które sprzedają się najlepiej względem aktualnego stanu magazynowego.
SELECT p.product_id, p.product_name,
       COALESCE(SUM(oi.quantity), 0) AS sold_qty,
       i.stock AS current_stock,
       CASE WHEN i.stock>0 THEN round((COALESCE(SUM(oi.quantity), 0)::numeric/i.stock)::numeric, 2) 
	   ELSE NULL END AS ratio
FROM products p
LEFT JOIN order_items oi ON p.product_id=oi.product_id
LEFT JOIN inventory i ON p.product_id=i.product_id
GROUP BY p.product_id, p.product_name, i.stock
ORDER BY ratio DESC NULLS LAST
LIMIT 20;
-- Największym bestsellerem jest krem z filtrem SPF50 i należy dalej stosować przyjętą strategię.
-- W drugiej kolejności jest baza pod makijaż, wystarczy regularne jej zamawianie
-- produkty z id 4, 18, 3, 27 mają dobrą sprzedaż, ale zapasy mogą być zbyt wysokie 
-- wiele produktów zalega (ratio <1), co sugeruje zwiększenie nacisku na ich marketing.

-- Produkty wymagające pilnego zamówienia
SELECT 
    p.product_name,
    i.stock as current_stock,
    COALESCE(SUM(oi.quantity), 0) as sold_last_30_days,
    ROUND(COALESCE(SUM(oi.quantity), 0)/30, 2) as avg_daily_sales,
    i.replenishment_lead_days,
    CASE WHEN i.stock<=(COALESCE(SUM(oi.quantity), 0)/30*i.replenishment_lead_days*1.5) THEN 'PILNE ZAMÓWIENIE'
         WHEN i.stock<=(COALESCE(SUM(oi.quantity), 0)/30*i.replenishment_lead_days*2) THEN 'PLANOWANE ZAMÓWIENIE'
         ELSE 'STAN WYSTARCZAJĄCY' END as order_status
FROM products p
JOIN inventory i ON p.product_id=i.product_id
LEFT JOIN order_items oi ON p.product_id=oi.product_id
LEFT JOIN orders o ON oi.order_id=o.order_id AND o.order_date>=CURRENT_DATE-30
GROUP BY p.product_name, i.stock, i.replenishment_lead_days
HAVING COALESCE(SUM(oi.quantity), 0)>0
ORDER BY order_status, current_stock ASC;
/*
Większość produktów ma zbyt małe zapasy w stosunku do sprzedaży.  
Największe braki dotyczą SPF50, Bazy pod makijaż i Pomadki.  
Część produktów sprzedaje się bardzo szybko i wymaga natychmiastowego zamówienia.  
Kilka produktów ma duże zapasy i bardzo niską rotację.  
Czas dostawy wynosi od 3 do 15 dni, co zwiększa ryzyko braków.  
W przyszłości warto zamówić od razu produkty o najwyższej rotacji, dla bestsellerów 
utrzymywać zapas na minimum 2 tygodnie sprzedaży, a produkty z niską rotacją warto przecenić.  
*/

-- Produkty dołączane jako upominek przy zakupach
-- 1. Lista produktów do przeceny (te które nie są zamawiane)
SELECT product_name, stock 
FROM products p 
JOIN inventory i ON p.product_id=i.product_id 
WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM order_items)
ORDER BY stock DESC 
LIMIT 10;

-- 2. Propozycje do jakich produktów powinien być dołączany dany produkt
SELECT 
    bs.product_name as bestseller,
    sm.product_name as product_to_add,
    sm.stock as zapas
FROM 
(
    SELECT p.product_id, p.product_name
    FROM products p
    JOIN order_items oi ON p.product_id=oi.product_id
    GROUP BY p.product_id, p.product_name
    ORDER BY SUM(oi.quantity) DESC
    LIMIT 5
) bs
CROSS JOIN 
(
    SELECT p.product_id, p.product_name, i.stock
    FROM products p
    JOIN inventory i ON p.product_id=i.product_id
    WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM order_items)
    AND i.stock>0
    LIMIT 10
) sm;

-- 3. Ustawienie daty rozpoczęcia promocji
UPDATE products 
SET price=ROUND(price*0.2, 2) 
WHERE product_id IN 
(
    SELECT p.product_id
    FROM products p
    JOIN inventory i ON p.product_id=i.product_id
    WHERE p.product_id NOT IN (SELECT DISTINCT product_id FROM order_items)
    AND i.stock>50
);