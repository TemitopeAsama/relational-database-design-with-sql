-- SQL Joins

-- Say we want to query our database for products and their corresponsing reviews, we can do that like so:

SELECT name, review_text
From product
JOIN reviews
on product.product_id = reviews.product_id;

-- The JOIN clause computes the cartesian product of two related tables
-- The ON clause picks/selects the rows that meet the specified condition (in our case, product.product_id = reviews.product_id)
-- What is a cartesian product of two two tables? 
-- This is a set of all possible combination of rows between the two columns, 
-- i.e every row in the parent table is combined with every row in the child table.


-- Types of JOINS
-- Consider two related tables: Table 1 (Product) and Table 2 (Review)
-- There are several type of JOINS. They include:
-- 1. INNER JOIN (same as JOIN)

SELECT name, review_text
From product
INNER JOIN reviews
on product.product_id = reviews.product_id;

-- 2. LEFT JOIN - returns all the rows in Table 1 (Product) and matching rows in Table 2 (Review).
-- 
SELECT name, review_text
From product
LEFT JOIN reviews
on product.product_id = reviews.product_id;

-- 3. RIGHT JOIN - returns all the rows in Table 2 and matching rows in Table 2.

SELECT name, review_text
From product
RIGHT JOIN reviews
on product.product_id = reviews.product_id;

-- 4. FULL OUTER JOIN - returns all rows from both tables including non-matching ones

SELECT name, review_text
From product
FULL OUTER JOIN reviews
on product.product_id = reviews.product_id;

-- WHERE vs. JOIN
-- A WHERE clause differs from a join in its notation. It is used to join tables like so:

SELECT name, review_text
From product, reviews
WHERE product.product_id = reviews.product_id;

-- The WHERE clause is not used exclusively to join tables. It may also be used to filter a single table based on a given condition.

SELECT name, product_id
From product
WHERE product_id = 2;


-- Reasons to choose JOIN over WHERE
-- Maintainability - JOINS are explicit and as such are less prone to errors and easier to debug. People make less error reading or writing joins. This makes them easier to maintain than WHERE clauses.
-- Readability - JOINS are also more readable and clear compared to WHERE joins
-- Optimization - JOINS are more optimized by database engines than WHERE clauses in joining tables. JOINS give your database better performance.