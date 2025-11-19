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
