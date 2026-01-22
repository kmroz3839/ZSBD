
--1.
CREATE OR REPLACE PROCEDURE add_job (
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE
) AS
BEGIN
    INSERT INTO jobs (job_id, job_title) VALUES (p_job_id, p_job_title);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20010, 'error: ' || SQLERRM);
END add_job;
/


--2.
CREATE OR REPLACE PROCEDURE update_job_title (
    p_job_id IN jobs.job_id%TYPE,
    p_new_title IN jobs.job_title%TYPE
) AS
    v_rows_updated INT;
BEGIN
    UPDATE jobs SET job_title = p_new_title WHERE job_id = p_job_id;
    v_rows_updated := SQL%ROWCOUNT;
    IF v_rows_updated = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'no jobs updated for id: ' || p_job_id);
    END IF;
END update_job_title;
/


--3.
CREATE OR REPLACE PROCEDURE delete_job (
    p_job_id IN jobs.job_id%TYPE
) AS
    v_rows_deleted INT;
BEGIN
    DELETE FROM jobs WHERE job_id = p_job_id;
    v_rows_deleted := SQL%ROWCOUNT;
    IF v_rows_deleted = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'no jobs deleted for id: ' || p_job_id);
    END IF;
END delete_job;
/


--4.
CREATE OR REPLACE PROCEDURE get_employee_salary (
    p_employee_id IN employees.employee_id%TYPE,
    p_salary OUT employees.salary%TYPE,
    p_last_name OUT employees.last_name%TYPE
) AS
BEGIN
    SELECT salary, last_name INTO p_salary, p_last_name FROM employees WHERE employee_id = p_employee_id;
END get_employee_salary;
/


--5.
CREATE OR REPLACE PROCEDURE add_employee (
    p_first_name IN employees.first_name%TYPE DEFAULT 'Jan',
    p_last_name IN employees.last_name%TYPE DEFAULT 'Smok',
    p_email IN employees.email%TYPE DEFAULT 'a@a.net',
    p_salary IN employees.salary%TYPE DEFAULT 5000
) AS
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20013, 'salary exceeds limit: ' || p_salary);
    END IF;
    INSERT INTO employees (first_name, last_name, email, salary)
    VALUES (p_first_name, p_last_name, p_email, p_salary);
END add_employee;
/


--6.
CREATE OR REPLACE PROCEDURE get_average_subordinate_salary (
    p_manager_id IN employees.manager_id%TYPE,
    p_average_salary OUT NUMBER
) AS
BEGIN
    SELECT AVG(salary) INTO p_average_salary FROM employees WHERE manager_id = p_manager_id;
END get_average_subordinate_salary;
/


--7.
CREATE OR REPLACE PROCEDURE update_department_salaries (
    p_department_id IN employees.department_id%TYPE,
    p_percentage_increase IN NUMBER
) AS
    PRAGMA EXCEPTION_INIT(dept_not_found, -2291);
BEGIN
    UPDATE employees e
    SET salary = salary + (salary * p_percentage_increase / 100)
    WHERE department_id = p_department_id
    AND salary + (salary * p_percentage_increase / 100) BETWEEN
        (SELECT min_salary FROM jobs WHERE job_id = e.job_id) AND
        (SELECT max_salary FROM jobs WHERE job_id = e.job_id);
EXCEPTION
    WHEN dept_not_found THEN
        RAISE_APPLICATION_ERROR(-20014, 'department id not found: ' || p_department_id);
END update_department_salaries;
/


--8.
CREATE OR REPLACE PROCEDURE move_employee_department (
    p_employee_id IN employees.employee_id%TYPE,
    p_new_department_id IN employees.department_id%TYPE
) AS
    v_department_count INT;
    v_employee_count INT;
BEGIN
    SELECT COUNT(*) INTO v_department_count FROM departments WHERE department_id = p_new_department_id;
    IF v_department_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'new department does not exist: ' || p_new_department_id);
    END IF;
    UPDATE employees SET department_id = p_new_department_id WHERE employee_id = p_employee_id;
    v_employee_count := SQL%ROWCOUNT;
    IF v_employee_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20016, 'employee does not exist: ' || p_employee_id);
    END IF;
END move_employee_department;
/


--9.
CREATE OR REPLACE PROCEDURE delete_department_if_empty (
    p_department_id IN departments.department_id%TYPE
) AS
BEGIN
    DELETE FROM departments WHERE department_id = p_department_id
    AND NOT EXISTS (SELECT 1 FROM employees WHERE department_id = p_department_id);
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20017, 'department not empty or does not exist: ' || p_department_id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20018, 'error occurred: ' || SQLERRM);
END delete_department_if_empty;
/