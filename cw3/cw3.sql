--1.
CREATE VIEW v_wysokie_pensje AS
    SELECT * FROM employees
    WHERE salary > 6000;

--2.
DROP VIEW v_wysokie_pensje;
CREATE VIEW v_wysokie_pensje AS
    SELECT * FROM employees
    WHERE salary > 12000;
    
--3.
DROP VIEW v_wysokie_pensje;

--4.
CREATE VIEW employees_finance AS
    SELECT employee_id, last_name, first_name
    FROM employees
    INNER JOIN departments USING(department_id)
    WHERE department_name = 'Finance';

--5.
CREATE VIEW employees_2 AS
    SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
    FROM employees
    WHERE salary >= 5000 AND salary <= 12000;

--6.
--a.
INSERT INTO employees_2 
    VALUES (500, 'Smok', 'Jan', 6000, 'IT_PROG', 'johndragon@example.com', TO_DATE('2024-01-15'));

--b.
UPDATE employees_2
    SET salary = 6500
    WHERE employee_id = 500;
    
--c.
DELETE FROM employees_2
    WHERE employee_id = 500;

--7.
CREATE VIEW depts AS
    SELECT department_id, 
        department_name, 
        COUNT(employee_id) AS num_employees, 
        AVG(salary) AS avg_salary,
        MAX(salary) AS max_salary
    FROM departments
    LEFT JOIN employees USING(department_id)
    GROUP BY department_id, department_name;
    
--a.
INSERT INTO depts (department_id, department_name)
    VALUES (999, 'dział kontroli');

--8.
CREATE VIEW v_wysokie_pensje AS
    SELECT * FROM employees
    WHERE salary > 12000
WITH CHECK OPTION;

--a.
INSERT INTO v_wysokie_pensje 
    VALUES 
        (501, 
        'Kowalski', 
        'Adam', 
        'adam.kowalski@example.com', 
        '000000000', 
        TO_DATE('2024-01-15'), 
        'IT_PROG', 
        4000, 
        NULL, 
        NULL, 
        NULL);

--b.
INSERT INTO v_wysokie_pensje 
    VALUES 
        (502, 
        'Kowalski', 
        'Paweł', 
        'pawel.kowalsk@example.com', 
        '000000000', 
        TO_DATE('2024-01-15'), 
        'IT_PROG', 
        13000, 
        NULL, 
        NULL, 
        NULL);

--9.
CREATE MATERIALIZED VIEW v_managers AS
    SELECT employee_id, first_name, last_name, department_id
    FROM employees
    WHERE employee_id IN (SELECT DISTINCT manager_id FROM departments);

--10.
CREATE VIEW v_najlepiej_oplacani AS
    SELECT employee_id, first_name, last_name, salary
    FROM employees
    ORDER BY salary DESC
    FETCH FIRST 10 ROWS ONLY;