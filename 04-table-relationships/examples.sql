DROP TABLE IF EXISTS reviews;

-- One way to establish a relationship between tables 
-- (Defining the relationship at the same time as when the child table is created)

-- CREATE TABLE reviews (
--   review_id INT PRIMARY KEY,
--   product_id INT NOT NULL,
--   review_text TEXT NOT NULL,
--   datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   CONSTRAINT fk_product_review
--   	foreign KEY (product_id)
--   		REFERENCES product (product_id)
  
-- );

-- Another way to establish a relationship between tables 
-- (Creating both tables separately and then altering the child table using ALTER to create a relationship using the foreign key.)

CREATE TABLE reviews (
  review_id INT PRIMARY KEY,
  product_id INT NOT NULL,
  review_text TEXT NOT NULL,
  datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE reviews
	ADD CONSTRAINT fk_parent_child
      FOREIGN key (product_id) REFERENCES
      product(product_id);