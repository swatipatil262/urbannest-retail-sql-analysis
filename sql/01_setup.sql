CREATE DATABASE IF NOT EXISTS urbannest_retail;
USE urbannest_retail;

DROP VIEW IF EXISTS vw_customer_summary;
DROP VIEW IF EXISTS vw_product_performance;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) UNIQUE NOT NULL,
 city VARCHAR(80),
 state VARCHAR(80),
 signup_date DATE
);

CREATE TABLE products (
 product_id INT PRIMARY KEY,
 product_name VARCHAR(120) NOT NULL,
 category VARCHAR(80) NOT NULL,
 unit_price DECIMAL(10,2) NOT NULL,
 stock_qty INT NOT NULL
);

CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 customer_id INT NOT NULL,
 order_date DATE NOT NULL,
 order_status VARCHAR(30) NOT NULL,
 order_total DECIMAL(12,2) NOT NULL,
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
 order_id INT NOT NULL,
 product_id INT NOT NULL,
 quantity INT NOT NULL,
 unit_price DECIMAL(10,2) NOT NULL,
 PRIMARY KEY (order_id, product_id),
 FOREIGN KEY (order_id) REFERENCES orders(order_id),
 FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
 order_id INT PRIMARY KEY,
 payment_method VARCHAR(40),
 amount DECIMAL(12,2),
 payment_status VARCHAR(30),
 payment_date DATE NULL,
 FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
