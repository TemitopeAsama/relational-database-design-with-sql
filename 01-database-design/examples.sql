CREATE TABLE product (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    price REAL
);

INSERT INTO product (product_id, product_name, price)
VALUES
    (1, 'Laptop', 1200.00),
    (2, 'Phone', 800.00),
    (3, 'Tablet', 500.00);

SELECT * FROM product;