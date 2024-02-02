SELECT * FROM stockx


-- change columns name
ALTER TABLE stockx
CHANGE `Order Date` order_date VARCHAR(255),
CHANGE `Brand` brand VARCHAR(255),
CHANGE `Sneaker Name` sneaker_name VARCHAR(255),
CHANGE `Sale Price` sale_price VARCHAR(255),
CHANGE `Retail Price` retail_price VARCHAR(255),
CHANGE `Release Date` release_date VARCHAR(255),
CHANGE `Shoe Size` shoe_size VARCHAR(255),
CHANGE `Buyer Region` buyer_region VARCHAR(255);


-- discover datatype
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'stockx';


-- convert some columns values
UPDATE stockx
SET order_date = STR_TO_DATE(order_date, '%m/%d/%y');
UPDATE stockx
SET release_date = STR_TO_DATE(release_date, '%m/%d/%y');
UPDATE stockx
SET sale_price = CAST(REPLACE(REPLACE(sale_price, '$', ''), ',', '') AS DECIMAL(10, 2));
UPDATE stockx
SET retail_price = CAST(REPLACE(REPLACE(retail_price, '$', ''), ',', '') AS DECIMAL(10, 2));


-- change datatype some columns
ALTER TABLE stockx
MODIFY order_date DATETIME,
MODIFY sale_price FLOAT,
MODIFY retail_price FLOAT,
MODIFY release_date DATETIME,
MODIFY shoe_size FLOAT;


-- check null values
SELECT * 
FROM stockx 
WHERE order_date IS NULL OR brand IS NULL OR sneaker_name IS NULL OR sale_price IS NULL OR retail_price IS NULL OR release_date IS NULL OR shoe_size IS NULL OR buyer_region IS NULL;


-- adding 'profit' column
ALTER TABLE stockx
ADD COLUMN profit DECIMAL(10, 2) AS (sale_price - retail_price) STORED;


-- remove '-' from sneaker name
UPDATE stockx
SET sneaker_name = REPLACE(sneaker_name, '-', ' ');


SELECT * FROM stockx
ORDER BY 1


-- profit from year to year
SELECT YEAR(order_date) AS year, SUM(profit) AS total_profit
FROM stockx
GROUP BY YEAR(order_date);


-- profit from month to month in 2018
SELECT MONTH(order_date) AS month, SUM(profit) AS total_profit
FROM stockx
WHERE YEAR(order_date) = 2018
GROUP BY MONTH(order_date);


-- total of orders from year to year
SELECT YEAR(order_date) AS year, COUNT(order_date) AS total_order
FROM stockx
GROUP BY YEAR(order_date);


-- total of orders from month to month in 2018
SELECT MONTH(order_date) AS month, COUNT(order_date) AS total_profit
FROM stockx
WHERE YEAR(order_date) = 2018
GROUP BY MONTH(order_date);


-- total of orders by brand
SELECT brand, COUNT(*) AS count
FROM stockx
GROUP BY brand;


-- total of sales by region and grouped by brand
SELECT buyer_region, yeezy, off_white
FROM (
    SELECT buyer_region,
           SUM(CASE WHEN brand = 'yeezy' THEN 1 ELSE 0 END) AS yeezy,
           SUM(CASE WHEN brand = 'off-white' THEN 1 ELSE 0 END) AS off_white
    FROM stockx
    GROUP BY buyer_region
) AS subquery
ORDER BY (yeezy + off_white) DESC
LIMIT 10;


-- top 5 most ordered sneakers
SELECT sneaker_name 'Sneaker Name', COUNT(sneaker_name) Total
FROM stockx
GROUP BY sneaker_name
ORDER BY Total DESC
LIMIT 5;