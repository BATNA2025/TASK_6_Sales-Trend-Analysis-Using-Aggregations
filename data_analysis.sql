-------------------------------- Sales Analysis -----------------------------------

-- Data Analysis using SQL (customers and orders analysis)


-- 1. What is the distribution of customers by gender and what is their average age?

SELECT gender, 
       COUNT(customer_id) AS customer_count,
       AVG(age) AS avg_age
FROM SQLProject.dbo.Customers
GROUP BY gender

-- 2. From which cities comes customers?

SELECT DISTINCT city
FROM SQLProject.dbo.Customers 

-- 3. What is the distribution of customers by the cities?

SELECT city, COUNT(*) AS total_customers 
FROM SQLProject.dbo.Customers 
GROUP BY city 
ORDER BY 2 DESC

-- 4. Which customers are men and age above 30?

SELECT *
FROM SQLProject.dbo.Customers 
WHERE gender = 'male' AND age >= 30

-- 5. Which customers spent the most (but more than 100)?

SELECT o.customer_id, c.customer_name, SUM(sales) AS total_amount_paid
FROM SQLProject.dbo.Orders o
JOIN SQLProject.dbo.Customers c
    ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING AVG(sales) > 100
ORDER BY total_amount_paid DESC

-- 6. What bought customers and how much paid (information about customers)?

SELECT c.customer_name, p.category, c.city, SUM(sales) AS total_amount_paid
FROM SQLProject.dbo.Orders o
INNER JOIN SQLProject.dbo.Customers c 
     ON o.customer_id = c.customer_id
INNER JOIN SQLProject.dbo.Products p 
     ON p.product_id = o.product_id
GROUP BY c.customer_name, p.category, c.city
ORDER BY customer_name

-- 7. What is the total quantity of each product sold?

SELECT p.product_name, sum(o.quantity) AS total_quantity_sold
FROM SQLProject.dbo.Products p
JOIN SQLProject.dbo.Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC

-- 8. What is the top-selling products based on their total revenue?

SELECT p.product_name, p.category, SUM(o.quantity * p.price) AS total_revenue
FROM SQLProject.dbo.Products p
JOIN SQLProject.dbo.Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC

-- 9. What is the revenue by gender?

SELECT c.gender,  SUM(o.sales) AS revenue_by_gender
FROM SQLProject.dbo.Customers c
JOIN SQLProject.dbo.Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.gender
ORDER BY revenue_by_gender DESC

-- 10. Which city brings in the most revenue?

SELECT c.city,  SUM(o.sales) AS revenue_by_city
FROM SQLProject.dbo.Customers c
JOIN SQLProject.dbo.Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue_by_city DESC

-- 11. What is the total number of products sold for each month in the year 2023?

SELECT MONTH(order_date) AS month, SUM(quantity) AS total_products_sold
FROM SQLProject.dbo.Orders
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date)
ORDER BY month

-- 12. What is the cumulative total of order amounts with giving a running total for each order date?.
-- Solution by window functions.

SELECT
    order_date,
    sales,
    SUM(sales) OVER (ORDER BY order_date) AS sales_total
FROM
    SQLProject.dbo.Orders;

-- 13. What is the average number of orders for each product?
-- Solution by subquery.

SELECT a.product_id, AvgQuantity
FROM
    (SELECT product_id, AVG(quantity) OVER(PARTITION BY product_id) AS AvgQuantity
     FROM SQLProject.dbo.Orders) a
ORDER BY a.product_id

/* 14. Display the value of order based on based on the following criteria:
   - if the total_amount > 1000 then 'High Value'
   - if it is less than or equal to 100 then 'Low Value',
   - else 'Medium Value'.

Solution by CASE STATEMENT.
*/ 

SELECT order_id,product_id, sales,
CASE
    WHEN sales >= 1000 THEN 'high value'
    WHEN sales <= 100 THEN 'low value'
    ELSE 'medium value'
END AS order_value
FROM SQLProject.dbo.Orders

-- 15. Display ranking of the best customers.
-- Solution with CTE (Common table expression).

WITH rank_cust AS(
    SELECT customer_id, 
	   SUM(sales) AS total_sum_paid, 
	   RANK() OVER(ORDER BY SUM(sales)) AS customer_rank
    FROM SQLProject.dbo.Orders
    GROUP BY customer_id
)
SELECT * FROM rank_cust
WHERE customer_rank >= 5
ORDER BY customer_rank DESC

-- 16. What is the average sales on each age group
-- Solution using by CTE with a join.

WITH age_spent AS(
    SELECT c.age,  AVG(o.sales) AS avg_sales,
    CASE
	WHEN age BETWEEN 20 AND 29 THEN '20 - 29'
	WHEN age BETWEEN 30 AND 39 THEN '30 - 39'
	ELSE '>= 40'
    END AS age_group
    FROM SQLProject.dbo.Customers c
    JOIN SQLProject.dbo.Orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.age
)
SELECT age_group, avg_sales
FROM age_spent
ORDER BY avg_sales DESC

