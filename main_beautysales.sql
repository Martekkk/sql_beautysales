--PROJEKT ANALIZY PRODUKTÓW BEAUTY


--TWORZENIE TABEL 

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(80),
    city VARCHAR(50),
    email VARCHAR(120),
    registration_date DATE
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    contact_email VARCHAR(120)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(120),
    category VARCHAR(60),
    cost NUMERIC(10, 2),
    price NUMERIC(10, 2),
    supplier_id INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY REFERENCES products(product_id),
    stock INT,
    replenishment_lead_days INT
);

CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    discount_percentage NUMERIC(5, 2),
    valid_from DATE,
    valid_to DATE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    status VARCHAR(20) DEFAULT 'zrealizowane'
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(10, 2)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_method VARCHAR(50),
    amount NUMERIC(12, 2),
    payment_date DATE
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_date DATE,
    comment TEXT
);

-- GENEROWANIE DANYCH

-- 1. Ustawienie seed'a dla powtarzalności
SELECT setseed(0.42);

-- 2. Słowniki do generowania danych
WITH names AS (
    SELECT unnest(ARRAY[
      'Anna Kowalska','Piotr Nowak','Ewa Wiśniewska','Jan Kaczmarek','Karolina Zielińska',
      'Michał Lewandowski','Agnieszka Wójcik','Tomasz Kamiński','Magdalena Nowicka','Kamil Maj',
      'Natalia Król','Paweł Duda','Monika Kubiak','Łukasz Kamiński','Alicja Szymańska',
      'Mateusz Piotrowski','Julia Jabłońska','Kinga Ostrowska','Grzegorz Mazur','Sandra Wysocka',
      'Rafał Walczak','Barbara Chmielewska','Olga Pawlak','Sebastian Jankowski','Zuzanna Sikora',
      'Adam Kozłowski','Beata Stępień','Marta Michalska','Jakub Górski','Patryk Sadowski',
      'Dorota Bąk','Norbert Wrona','Sylwia Głowacka','Weronika Nowakowska','Hubert Lis',
      'Daniel Rutkowski','Izabela Zając','Katarzyna Piątek','Radosław Szulc','Lena Tomaszewska',
      'Oskar Brzeziński','Paulina Krawczyk','Szymon Urban','Iwona Pawłowska','Marcin Kosiński',
      'Elżbieta Pawlik','Adrian Kruk','Helena Sławińska','Mateusz Zawadzki','Bianka Malinowska',
      'Cezary Borkowski','Edyta Polak','Mariusz Jankowski','Klaudia Kubicka','Mirosław Wójcik'
    ]) AS name
),
cities AS (
    SELECT unnest(ARRAY['Warszawa','Kraków','Gdańsk','Wrocław','Poznań','Łódź','Szczecin','Lublin','Białystok','Rzeszów']) AS city
)

-- 3. Wstawianie danych klientów
INSERT INTO customers (name, city, email, registration_date)
SELECT
    name,
    (ARRAY['Warszawa','Kraków','Gdańsk','Wrocław','Poznań','Łódź','Szczecin','Lublin'])[(1 + floor(random()*8))::int],
    lower(regexp_replace(name, '\s','.', 'g')) || '@beauty.pl',
    (date '2022-01-01' + (floor(random()*730))::int)
FROM (
    SELECT generate_series(1, 100) AS id
) g
JOIN (
    SELECT unnest(ARRAY[
      'Anna Kowalska','Piotr Nowak','Ewa Wiśniewska','Jan Kaczmarek','Karolina Zielińska',
      'Michał Lewandowski','Agnieszka Wójcik','Tomasz Kamiński','Magdalena Nowicka','Kamil Maj',
      'Natalia Król','Paweł Duda','Monika Kubiak','Łukasz Kamiński','Alicja Szymańska',
      'Mateusz Piotrowski','Julia Jabłońska','Kinga Ostrowska','Grzegorz Mazur','Sandra Wysocka',
      'Rafał Walczak','Barbara Chmielewska','Olga Pawlak','Sebastian Jankowski','Zuzanna Sikora',
      'Adam Kozłowski','Beata Stępień','Marta Michalska','Jakub Górski','Patryk Sadowski',
      'Dorota Bąk','Norbert Wrona','Sylwia Głowacka','Weronika Nowakowska','Hubert Lis',
      'Daniel Rutkowski','Izabela Zając','Katarzyna Piątek','Radosław Szulc','Lena Tomaszewska',
      'Oskar Brzeziński','Paulina Krawczyk','Szymon Urban','Iwona Pawłowska','Marcin Kosiński',
      'Elżbieta Pawlik','Adrian Kruk','Helena Sławińska','Mateusz Zawadzki','Bianka Malinowska',
      'Cezary Borkowski','Edyta Polak','Mariusz Jankowski','Klaudia Kubicka','Mirosław Wójcik',
      'Łucja Rybak','Kazimierz Wolski','Jakub Bednarek','Kamila Wilk','Tadeusz Cichy',
      'Bogumiła Marek','Wiktor Głowacki','Maria Domańska','Olaf Zięba','Jowita Marecka',
      'Przemysław Baran','Rozalia Lisowska','Sebastian Zawada','Aurelia Kurz','Igor Marchlewicz',
      'Weronika Brzozowska','Natalia Michalik','Patrycja Sokołowska','Damian Skowroński','Kornelia Orłowska',
      'Remigiusz Polański','Weronika Kordas','Julian Urbanek','Martyna Giersz','Alan Wilczyński',
      'Zofia Orzechowska','Marta Grzyb','Iga Stankiewicz','Piotr Bielecki','Kamila Rut',
      'Marek Sienkiewicz','Natalia Jastrzębska','Sławomir Piasecki','Marta Walczak'
    ]) AS name
) src ON TRUE
LIMIT 100;

-- 4. Wstawianie danych dostawców
INSERT INTO suppliers (name, city, contact_email)
SELECT
    'Dostawca ' || i,
    (ARRAY['Warszawa','Kraków','Gdańsk','Wrocław','Poznań','Łódź'])[(1 + floor(random()*6))::int],
    lower('dostawca' || i || '@dostawca.pl')
FROM generate_series(1, 12) s(i);

-- 5. Wstawianie danych produktów
INSERT INTO products (product_name, category, cost, price, supplier_id)
SELECT
    p.product_name,
    p.category,
    round((5+random()*195)::numeric, 2),
    round(((5+random()*195)*(1.3+random()*1.7))::numeric, 2),
    (1+floor(random()*12))::int
FROM (VALUES
  ('Błyszczyk do ust', 'Makijaż'),
  ('Pomadka matowa', 'Makijaż'),
  ('Cień do powiek paleta', 'Makijaż'),
  ('Podkład płynny', 'Makijaż'),
  ('Puder prasowany', 'Makijaż'),
  ('Tonik oczyszczający', 'Pielęgnacja'),
  ('Żel do mycia twarzy', 'Pielęgnacja'),
  ('Krem nawilżający', 'Pielęgnacja'),
  ('Serum witaminowe', 'Pielęgnacja'),
  ('Peeling enzymatyczny', 'Pielęgnacja'),
  ('Szampon do włosów A', 'Włosy'),
  ('Szampon do włosów B', 'Włosy'),
  ('Odżywka do włosów', 'Włosy'),
  ('Maska do włosów', 'Włosy'),
  ('Olejek do włosów', 'Włosy'),
  ('Krem pod oczy', 'Pielęgnacja'),
  ('Baza pod makijaż', 'Makijaż'),
  ('Tusze do rzęs', 'Makijaż'),
  ('Lakier do paznokci', 'Paznokcie'),
  ('Zmywacz do paznokci', 'Paznokcie'),
  ('Korektor', 'Makijaż'),
  ('Mgiełka do twarzy', 'Pielęgnacja'),
  ('Sól do kąpieli', 'Pielęgnacja'),
  ('Krem do rąk', 'Pielęgnacja'),
  ('Płatki kosmetyczne', 'Pielęgnacja'),
  ('Krem do stóp', 'Pielęgnacja'),
  ('Balsam do ciała', 'Pielęgnacja'),
  ('Szczotka do włosów', 'Włosy'),
  ('Ręcznik kosmetyczny', 'Akcesoria'),
  ('Etui na pędzle', 'Akcesoria'),
  ('Pędzel do podkładu', 'Akcesoria'),
  ('Puder mineralny', 'Makijaż'),
  ('Spray utrwalający', 'Makijaż'),
  ('Krem z filtrem SPF50', 'Pielęgnacja'),
  ('Olej kokosowy do ciała', 'Pielęgnacja'),
  ('Balsam do ust', 'Pielęgnacja'),
  ('Woda micelarna', 'Pielęgnacja'),
  ('Glinka do twarzy', 'Pielęgnacja')
) p(product_name, category);

-- 6. Inventory (stan początkowy)
INSERT INTO inventory (product_id, stock, replenishment_lead_days)
SELECT product_id, (20+floor(random()*180))::int, (2+floor(random()*14))::int
FROM products;

-- 7. Wstawianie danych zniżek
INSERT INTO discounts (product_id, discount_percentage, valid_from, valid_to)
SELECT
    product_id,
    round((5+random()*45)::numeric, 2 ),
    (date '2023-01-01'+(floor(random()*365))::int),
    (date '2023-01-01'+(floor(random()*365))::int+(7+floor(random()*60))::int)
FROM products
WHERE random()<0.4
ORDER BY random()
LIMIT 15;

-- 8. Zamówienia (400) z sezonowością (2023-2024)
INSERT INTO orders (customer_id, order_date, status)
SELECT
    (1+floor(random()*100))::int,
    (date '2023-01-01'+
    (CASE WHEN random()<0.35 THEN floor(random()*365)::int 
             WHEN random()<0.75 THEN (floor(random()*180)+365)::int
             ELSE (365+floor(random()*365))::int
        END
    )),
    (ARRAY['zrealizowane','zrealizowane','zrealizowane','anulowane','zwrot'])[(1+floor(random()*5))::int]
FROM generate_series(1,400) s(i);

-- 9. Pozycje zamówień: dla każdego zamówienia uwzględniamy udzielony rabat dla 1-4 zamówień
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.order_id,
    p.product_id,
    q.qty,
    round((p.price*(1-COALESCE(d.discount_percentage,0)/100))::numeric, 2) as unit_price
FROM orders o
CROSS JOIN LATERAL (SELECT (1+floor(random()*6))::int AS qty) q
JOIN LATERAL (SELECT product_id, price FROM products ORDER BY random() LIMIT (1+floor(random()*10))::int
) p ON TRUE
LEFT JOIN LATERAL (SELECT discount_percentage FROM discounts d
					WHERE d.product_id=p.product_id
				    AND o.order_date BETWEEN d.valid_from AND d.valid_to
				    ORDER BY discount_percentage DESC LIMIT 1
) d ON TRUE;

-- 9b. Trzeba dorobić trochę także dodajemy pozycje
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.order_id,
    p.product_id,
    (1+floor(random()*8))::int,
    round((p.price*(1-COALESCE(d.discount_percentage, 0)/100))::numeric, 2)
FROM orders o
JOIN generate_series(1, 2) g(n) ON (random()<0.7)
JOIN LATERAL (
  SELECT product_id, price 
  FROM products 
  ORDER BY random() 
  LIMIT 1
) p ON TRUE
LEFT JOIN LATERAL (
  SELECT discount_percentage 
  FROM discounts d
  WHERE d.product_id=p.product_id
    AND o.order_date BETWEEN d.valid_from AND d.valid_to
  ORDER BY discount_percentage DESC LIMIT 1
) d ON TRUE;

-- 10. Inicjalizacja danych płatności
INSERT INTO payments (order_id, payment_method, amount, payment_date)
SELECT
    o.order_id,
    (ARRAY['Karta','Przelew','BLIK','Gotówka'])[(1+floor(random()*4))::int],
    round((COALESCE((SELECT SUM(oi.quantity*oi.unit_price) FROM order_items oi WHERE oi.order_id=o.order_id), 0)* 
    CASE WHEN o.status='anulowane' THEN 0
		 WHEN o.status='zwrot' THEN (0.5+random()*0.6) 
		 ELSE 1 END)::numeric, 2),
    o.order_date+(floor(random()*8))::int
FROM orders o;

-- 11. Inicjalizacja danych dotyczących ocen/recenzji
INSERT INTO reviews (customer_id, product_id, rating, review_date, comment)
SELECT
    (1+floor(random()*100))::int,
    (1+floor(random()*(SELECT COUNT(*) FROM products)))::int,
    (1+floor(random()*5))::int,
    (date '2023-01-01'+floor(random()*730)::int),
    (ARRAY[
      'Świetny produkt, polecam.',
      'Dobry jakościowo.',
      'Trochę za drogie.',
      'Nie spełnił oczekiwań.',
      'Opakowanie uszkodzone.',
      'Szybka wysyłka, produkt ok.',
      'Bardzo nawilża, super.',
      'Przeciętny efekt.',
      'Kupuję ponownie.',
      'Dawno nie widziałam tak dobrego produktu.'
    ])[(1+floor(random()*10))::int]
FROM generate_series(1, 160) s(i);

-- 12.Aby mieć jakieś zestawy najczęściej kupowane, ręcznie wprowadzamy dane
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2023-06-15', 'zrealizowane'),
(2, '2023-07-20', 'zrealizowane'),
(3, '2023-08-10', 'zrealizowane');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(401, 1, 2, (SELECT price*0.9 FROM products WHERE product_id=1)), 
(401, 2, 1, (SELECT price FROM products WHERE product_id=2)),        
(401, 4, 1, (SELECT price FROM products WHERE product_id=4)), 
(402, 6, 1, (SELECT price FROM products WHERE product_id=6)), 
(402, 7, 1, (SELECT price FROM products WHERE product_id=7)), 
(402, 8, 1, (SELECT price FROM products WHERE product_id=8)),
(403, 11, 1, (SELECT price FROM products WHERE product_id=11)), 
(403, 13, 1, (SELECT price FROM products WHERE product_id=13)), 
(403, 6, 1, (SELECT price*0.85 FROM products WHERE product_id=6)); 

-- GENEROWANIE INDEKSÓW

-- 13. Indeksy pomocnicze
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orderitems_order ON order_items(order_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_customers_city ON customers(city);

-- 14.Sprawdzenie kilku selectów, aby widzieć czy dane są poprawne
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

--ANALIZA FINANSOWA

-- całkowite przychody (sumarycznie)
SELECT ROUND(SUM(oi.quantity*oi.unit_price), 2) AS total_revenue
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
       ROUND(100*SUM(quantity*unit_price)/
	   		(SELECT SUM(quantity*unit_price) 
	   		 FROM with_discount), 2) AS revenue_proc,
	   ROUND(100*SUM(quantity)/
	   		(SELECT SUM(quantity) 
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
-- monitorować przelewy, czy niska średnia to szansa czy ryzyko.

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
zadecydować co zrobić z kategorią włosy*/


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
    JOIN orders o ON c.customer_id=o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    first_order_month,
    COUNT(*) as new_customers,
    COUNT(CASE WHEN order_count>1 THEN 1 END) as returning_customers,
    ROUND(COUNT(CASE WHEN order_count>1 THEN 1 END)*100/COUNT(*), 2) as retention_rate
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