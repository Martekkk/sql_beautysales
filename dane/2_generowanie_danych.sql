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
    SELECT generate_series(1,100) AS id
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
FROM generate_series(1,12) s(i);

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
    round((p.price*(1-COALESCE(d.discount_percentage,0)/100.0))::numeric, 2) as unit_price
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
    round((p.price*(1-COALESCE(d.discount_percentage, 0)/100.0))::numeric, 2)
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
    CASE WHEN o.status='anulowane' THEN 0.0 
		 WHEN o.status='zwrot' THEN (0.5+random()*0.6) 
		 ELSE 1.0 END)::numeric, 2),
    o.order_date+(floor(random()*8))::int
FROM orders o;

-- 11. Inicjalizacja danych dotyczących ocen/recenzji
INSERT INTO reviews (customer_id, product_id, rating, review_date, comment)
SELECT
    (1+floor(random()*100))::int,
    (1+floor(random()* (SELECT COUNT(*) FROM products) ))::int,
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
FROM generate_series(1,160) s(i);

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
