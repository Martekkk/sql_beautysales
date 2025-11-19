# Beauty Sales Analytics Project

## Krótki opis projektu
Projekt zawiera kompleksową analizę danych sprzedażowych sklepu beauty z użyciem zaawansowanych zapytań SQL. 
Projekt obejmuje pełny proces, od generowania realistycznych danych transakcyjnych, po szczegółową analitykę biznesową.

## Kluczowe funkcje
Projekt został zaprojektowany tak, aby jak najlepiej odwzorować realne środowisko sprzedażowe i umożliwić wielowymiarową analizę danych.

### **Baza danych:** 9 tabel z relacjami:
* Customers: dane klientów (100 rekordów)
* Products: katalog produktów (38 pozycji) z podziałem na kategorie
* Suppliers: dostawcy produktów
* Inventory: zarządzanie stanami magazynowymi
* Orders: nagłówki zamówień (400+ zamówień)
* Order Items: pozycje zamówień
* Payments: transakcje płatnicze
* Discounts: system promocji i rabatów
* Reviews: oceny i recenzje produktów

### **Generowanie danych:**
Dane zostały przygotowane tak, aby jak najbardziej przypominać scenariusz rzeczywisty:
- 100 klientów z polskimi imionami i nazwiskami
- 400+ zamówień z sezonowością (lata 2023-2024)
- 38 produktów w 4 kategoriach: Makijaż, Pielęgnacja, Włosy, Akcesoria
- Realistyczne wzorce zakupowe: produkty kupowane razem, typowe koszyki
- Dane geograficzne klienci z 8 głównych miast Polski

### **Analityka biznesowa:**
* **Analiza klienta:** CLV (Customer Lifetime Value) - obliczenie wartości życia klienta oraz RFM (Recency, Frequency, Monetary) - segmentacja klientów, najbardziej wartościowi klienci
* **Analiza sprzedaży:** ranking produktów według sprzedaży i przychodów, analiza kategorii i trendów sezonowych, produktów kupowanych razem
* **Analiza finansowa:** obliczenie marży brutto per produkt i łącznie, analiza udziału rabatów w sprzedaży, porównanie cen katalogowych do cen transakcyjnych
* **Analiza zapasów:** rotacja zapasów (od 0.02 do 94.74)

## Użyte technologie i narzędzia
- PostgreSQL
- zaawansowany SQL (Window Functions, CTE, LATERAL JOIN, agregacje)
- Optymalizacja wydajności za pomocą indeksów

## Wyniki i wnioski
### Co działa dobrze:
* 98,5% transakcji odbyło się po cenach regularnych, co wskazuje na niewielką zależność sprzedaży od rabatów
* Wysoka lojalność klientów, klienci wracają średnio 4 razy  
* Silna koncentracja sprzedaży, 4 produkty generują ponad połowę przychodu
* Efektywne zarządzanie magazynem

### Obszary do poprawy:
* Zarządzanie zapasami, niektóre produkty mają zerową rotację  
* Znaczne różnice regionalne, 6-krotna różnica między najlepszym a najsłabszym miastem
* Wysoka sezonowość, duże wahania miesięcznych przychodów  
* Kategoria "Włosy" generuje niską sprzedaż w porównaniu do innych kategorii  

### Rekomendacje:
* Zwiększyć zamówienia dla produktów z wysoką rotacją (Krem SPF50, Baza pod makijaż)  
* Przecenić produkty z niską rotacją i zaplanować akcje marketingowe, aby ograniczyć zamrożony kapitał
* Wzmocnić sprzedaż w słabszych regionach poprzez promocje lokalne i kampanie
* Zoptymalizować asortyment w kategorii włosów  

## Jak uruchomić
1. Otwórz plik "beautysales.sql" w PostgreSQL
2. Wykonaj cały skrypt sekwencyjnie
3. Przejrzyj wyniki analiz na końcu pliku

