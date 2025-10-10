--1.
SELECT last_name || ' ' || salary AS wynagrodzenie 
FROM employees
WHERE department_id IN (20, 50)
    AND salary >= 2000 AND salary <= 7000
ORDER BY last_name;

--2.
SELECT hire_date, last_name, &column AS COL
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2005
    AND manager_id IS NOT NULL
ORDER BY COL;

--3.
SELECT (first_name || ' ' || last_name) AS full_name, salary, phone_number
FROM employees
WHERE SUBSTR(last_name,3,1) = 'e'
    AND INSTR(last_name, '&name_part') > 0
ORDER BY full_name DESC, salary ASC;

--4.
SELECT first_name, 
    last_name, 
    ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) AS months_worked,
    CASE
        WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) < 150 THEN 0.1
        WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) > 200 THEN 0.3
        ELSE 0.2
    END AS wysokość_dodatku
FROM employees
ORDER BY months_worked;

--5.
SELECT
    department_id,
    SUM(salary) AS suma, 
    AVG(salary) AS srednia
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 5000;

--6.
SELECT last_name, department_id, job_id
FROM employees
LEFT JOIN departments USING(department_id)
LEFT JOIN locations USING(location_id)
WHERE city = 'Toronto';

--7.


--8.
SELECT department_id
FROM departments
FULL JOIN employees USING(department_id)
GROUP BY department_id
HAVING COUNT(employee_id) = 0;