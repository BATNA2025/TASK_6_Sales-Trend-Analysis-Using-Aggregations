# Sales analysis - SQL Data Analysis

## General info
The project contains the analysis of example sales data with SQL.  The project showcase my knowledge and skils in SQL such as data manipulation, analysis and querying. The analysis was prepared with MS SQL Server database.

### Dataset
The dataset contains sample data about products sales. It includes three tables namely Customers, Products and Orders.

## Summary

### Data Insights

In the dataset asked the following questions:
- Based on the information about customers what is the distribution of customers by gender, age and cities?
- From which cities comes customers?
- Which customers are spent the most?
- What bought customers and how much they paid?
- What is the total quantity of each product sold?
- What is the average number of orders for each product?
- What is the top-selling products based on their total revenue?
- Which city brings in the most revenue?
- What is the revenue by gender?
- How is the ranking of the best customers?
- What is the average sales on each age group?
- What is the total number of products sold for each month?

**SQL Skills Used:**

- create tables and insert data,
- JOINS,
- aggregate functions,
- subqueries,
- window functions,
- common table expressions (CTE).

## Project includes:
- script for create database - **create_data.sql**
- sales data analysis - **data_analysis.sql**
   
## Technologies
The project is created with:
- SQL (T-SQL),
- Microsoft SQL Server (SQL Server Management Studio).

**Running the project:**

To use this project:
- clone the repository or download .sql files;
- ensure you have a SQL database set up to execute the provided SQL code;
- use your chosen SQL client to execute the code snippets (e.g. SQL Server Management Studio, MySQL Workbench).







# SQL Interview Questions – Grouping, Aggregates, and Date Functions

## 1. How do you group data by month and year?
Use `GROUP BY` with date functions.

**MySQL Example:**
```sql
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, COUNT(*) AS orders
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date);
```

**PostgreSQL Example:**
```sql
SELECT DATE_PART('year', order_date) AS year, DATE_PART('month', order_date) AS month, COUNT(*) AS orders
FROM sales
GROUP BY year, month;
```

---

## 2. What's the difference between `COUNT(*)` and `COUNT(DISTINCT col)`?
- **`COUNT(*)`** → Counts all rows, including duplicates and rows with NULL values in the column.
- **`COUNT(DISTINCT col)`** → Counts only unique, non-NULL values.

Example table:

| col  | COUNT(*) | COUNT(DISTINCT col) |
|------|----------|----------------------|
| A    | 3        | 1                    |
| NULL | 3        | 1                    |
| A    | 3        | 1                    |

---

## 3. How do you calculate monthly revenue?
```sql
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS monthly_revenue
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
```
💡 **SUM** aggregates the total sales for each month.

---

## 4. What are aggregate functions in SQL?
Aggregate functions perform calculations on multiple rows and return a single value.

Common aggregate functions:
- `SUM()` → Total of values
- `AVG()` → Average of values
- `MIN()` → Minimum value
- `MAX()` → Maximum value
- `COUNT()` → Number of rows or non-NULL values

---

## 5. How to handle NULLs in aggregates?
- Most aggregate functions **ignore NULLs** (except `COUNT(*)`).
- Use `COALESCE()` or `IFNULL()` to replace NULLs with a default value.

Example:
```sql
SELECT SUM(COALESCE(sales_amount, 0)) AS total_sales
FROM sales;
```

---

## 6. What's the role of `ORDER BY` and `GROUP BY`?
- **`GROUP BY`** → Groups rows with the same values into summary rows.
- **`ORDER BY`** → Sorts the results in ascending or descending order.

Example:
```sql
SELECT product_category, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product_category
ORDER BY total_sales DESC;
```

---

## 7. How do you get the top 3 months by sales?
```sql
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS monthly_sales
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY monthly_sales DESC
LIMIT 3;
```
- In SQL Server, use:
```sql
SELECT TOP 3 YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS monthly_sales
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY monthly_sales DESC;
```
