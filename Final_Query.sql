create database final_project;
use final_project;
CREATE TABLE product_reviews (
    product_id VARCHAR(20),
    product_name TEXT,
    category TEXT,
    discounted_price VARCHAR(10),
    actual_price VARCHAR(10),
    discount_percentage VARCHAR(5),
    rating FLOAT,
    rating_count VARCHAR(10),
    about_product TEXT,
    user_id TEXT,
    user_name TEXT,
    review_id TEXT,
    review_title TEXT,
    review_content TEXT,
    img_link TEXT,
    product_link TEXT
);
SET GLOBAL local_infile = 1;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon.csv'
INTO TABLE product_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select * from product_reviews limit 50;
-- Q1. 
-- apoorv ranjan
SELECT product_id, product_name, category
FROM product_reviews;
-- Q2. 
-- apoorv ranjan
SELECT * FROM product_reviews WHERE rating >= 4.0;
-- Q3. 
-- apoorv ranjan
SELECT product_id, product_name, category, rating
FROM product_reviews WHERE category LIKE 'Computers&Accessories%';
-- Q4. 
-- apoorv ranjan 
SELECT product_id, product_name,about_product
FROM product_reviews
WHERE about_product LIKE '%durable%';
-- Q5. 
-- apoorv ranjan
SELECT COUNT(DISTINCT product_id) AS total_products
FROM product_reviews;
-- Q6. 
-- apoorv ranjan
SELECT AVG(rating) AS average_rating
FROM product_reviews;
-- Q7. 
-- apoorv ranjan 
SELECT product_id, product_name, rating
FROM product_reviews
ORDER BY rating DESC
LIMIT 5;
-- Q8. 
-- apoorv ranjan
SELECT product_id, product_name, COUNT(review_id) AS review_count
FROM product_reviews
GROUP BY product_id, product_name
ORDER BY review_count DESC;
-- Q9. 
-- apoorv ranjan
SELECT p1.product_id, p1.product_name, p1.category, p1.rating, p2.product_id, p2.product_name, p2.rating  
FROM product_reviews p1  
JOIN product_reviews p2  
ON p1.category = p2.category AND p1.product_id <> p2.product_id  
WHERE p1.rating = p2.rating;

-- Q10. 
-- apoorv ranjan
SELECT product_id, product_name, rating,
       CASE 
           WHEN rating >= 4.5 THEN 'Excellent'
           WHEN rating >= 4.0 THEN 'Good'
           ELSE 'Average'
       END AS rating_category
FROM product_reviews
ORDER BY rating DESC;
-- Q11.
-- apoorv ranjan
ALTER TABLE product_reviews 
ADD COLUMN discount_amount DECIMAL(10, 2);
UPDATE product_reviews 
SET discount_amount = COALESCE(actual_price, 0) - COALESCE(discounted_price, 0);
SELECT product_id, product_name, actual_price, discounted_price, discount_amount
FROM product_reviews
LIMIT 10;
-- Q12. 
-- apoorv ranjan
SELECT product_id,
       product_name,
       actual_price,
       discounted_price,
       (actual_price - discounted_price) / actual_price * 100 AS discount_percentage
FROM (
    SELECT product_id,
           product_name,
           actual_price,
           discounted_price,
           RANK() OVER (ORDER BY (actual_price - discounted_price) / actual_price * 100 DESC) AS ranking
    FROM product_reviews
    WHERE actual_price > 0
) AS ranked
WHERE ranking = 1;

-- Q13. 
-- apoorv ranjan
CREATE VIEW HighRatingProducts AS
SELECT product_id,product_name,category,rating,actual_price,discounted_price
FROM product_reviews
WHERE rating >= 4.5;
-- Q14. 
-- apoorv ranjan
SELECT product_id,product_name,category,rating,
RANK() OVER (PARTITION BY category ORDER BY rating DESC) AS product_rank
FROM product_reviews;
-- Q15. 
-- apoorv ranjan
SELECT 
    discounted_price,
    COUNT(*) OVER (ORDER BY discounted_price) AS cumulative_count
FROM product_reviews
GROUP BY discounted_price
ORDER BY discounted_price;
-- Q16. 
-- apoorv ranjan
DELIMITER //  
CREATE PROCEDURE UpdateProductRating(IN prod_id INT, IN new_rating DECIMAL(3,2))  
BEGIN  
    UPDATE product_reviews  
    SET rating = new_rating  
    WHERE product_id = prod_id;  
END //  
DELIMITER ;


-- Q17. 
-- apoorv ranjan 
SELECT category
FROM (
    SELECT category, AVG(rating) AS avg_rating
    FROM product_reviews
    GROUP BY category
    ORDER BY avg_rating DESC
    LIMIT 1
) AS subquery;
-- Q18. 
-- apoorv ranjan 
SELECT 
    p1.product_id AS product_id_1,
    p1.product_name AS product_name_1,
    p1.rating AS rating_1,
    p2.product_id AS product_id_2,
    p2.product_name AS product_name_2,
    p2.rating AS rating_2
FROM 
    product_reviews p1
JOIN 
    product_reviews p2 
ON 
    p1.category = p2.category AND p1.product_id <> p2.product_id
WHERE 
    p1.rating > p2.rating;