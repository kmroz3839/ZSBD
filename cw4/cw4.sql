--1.
SELECT first_name, last_name, salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

--2. 
SELECT first_name, last_name, salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    SUM(salary) OVER () AS total_salary
FROM employees;

--3.


--4.
SELECT last_name, product_name, price, sale_date,
    COUNT(quantity) OVER (PARTITION BY sale_date) AS total_sales_per_day,
    price
FROM sales
INNER JOIN products USING(product_id)
INNER JOIN employees USING(employee_id);