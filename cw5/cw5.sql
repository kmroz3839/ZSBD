
--1.
DECLARE
    numer_max NUMBER;
    new_department_name departments.department_name%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(department_id) INTO numer_max FROM departments;
    DBMS_OUTPUT.PUT_LINE('maksymalny numer departamentu: ' || numer_max);
    INSERT INTO departments (department_id, department_name) VALUES (numer_max + 10, new_department_name);
END;
/


--2.
DECLARE
    numer_max NUMBER;
    new_department_name departments.department_name%TYPE := 'EDUCATION';
    new_location_id locations.location_id%TYPE := 3000;
BEGIN
    SELECT MAX(department_id) INTO numer_max FROM departments;
    DBMS_OUTPUT.PUT_LINE('maksymalny numer departamentu: ' || numer_max);
    INSERT INTO departments (department_id, department_name, location_id) VALUES (numer_max +
        10, new_department_name, new_location_id);
END;
/


--3.
CREATE TABLE nowa (number_str VARCHAR(3));
DECLARE
    v_number VARCHAR(3);
BEGIN
    FOR i IN 1..10 LOOP
        IF i != 4 AND i != 6 THEN
            v_number := TO_CHAR(i);
            INSERT INTO nowa (number_str) VALUES (v_number);    
        END IF;
    END LOOP;
END;
/


--4.
DECLARE
    v_country countries%ROWTYPE;
BEGIN
    SELECT * INTO v_country FROM countries WHERE country_id = 'CA';
    DBMS_OUTPUT.PUT_LINE('nazwa: ' || v_country.country_name || ', id regionu: ' || v_country.region_id);
END;
/


--5.
DECLARE
    v_job jobs%ROWTYPE;
BEGIN
    FOR rec IN (SELECT * FROM jobs WHERE job_title LIKE '%Manager%') LOOP
        v_job := rec;
        v_job.min_salary := v_job.min_salary * 1.05;
        UPDATE jobs SET min_salary = v_job.min_salary WHERE job_id = v_job.job_id;
    END LOOP;
END;
/

--a.
DECLARE
    v_job jobs%ROWTYPE;
BEGIN
    FOR rec IN (SELECT * FROM jobs WHERE job_title LIKE '%Manager%') LOOP
        v_job := rec;
        v_job.min_salary := v_job.min_salary / 1.05;
        UPDATE jobs SET min_salary = v_job.min_salary WHERE job_id = v_job.job_id;
    END LOOP;
END;
/


--6.
DECLARE
    v_job jobs%ROWTYPE;
BEGIN
    SELECT * INTO v_job FROM jobs WHERE max_salary = (SELECT MAX(max_salary) FROM
        jobs);
    DBMS_OUTPUT.PUT_LINE('job_id: ' || v_job.job_id || ', job_title: ' || v_job.job_title || ', max_salary: ' || v_job.max_salary);
END;
/


--7.
DECLARE
    CURSOR c_countries (p_region_id NUMBER) IS
        SELECT country_name, (SELECT COUNT(*) FROM employees e 
                              INNER JOIN departments d ON d.department_id = e.department_id
                              INNER JOIN locations l ON d.location_id = l.location_id 
                              INNER JOIN countries c ON l.country_id = c.country_id 
                              WHERE c.country_name = co.country_name) AS employee_count
        FROM countries co
        INNER JOIN locations l ON co.country_id = l.country_id
        WHERE co.region_id = p_region_id;
    v_country c_countries%ROWTYPE;
BEGIN
    OPEN c_countries(1);
    LOOP
        FETCH c_countries INTO v_country;
        EXIT WHEN c_countries%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Kraj: ' || v_country.country_name || ', Liczba pracowników: ' || v_country.employee_count);
    END LOOP;
    CLOSE c_countries;
END;
/


--8.
DECLARE
    CURSOR c_employees IS
        SELECT salary, last_name FROM employees WHERE department_id = 50;
    v_employee c_employees%ROWTYPE;
BEGIN
    OPEN c_employees;
    LOOP
        FETCH c_employees INTO v_employee;
        EXIT WHEN c_employees%NOTFOUND;
        IF v_employee.salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_employee.last_name || ' nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_employee.last_name || ' dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE c_employees;
END;
/


--9.
DECLARE
    CURSOR c_employees (p_min_salary NUMBER, p_max_salary NUMBER, p_name_part VARCHAR2) IS
        SELECT salary, first_name, last_name FROM employees
        WHERE salary BETWEEN p_min_salary AND p_max_salary
        AND first_name LIKE '%' || p_name_part || '%';
    v_employee c_employees%ROWTYPE;
BEGIN
    --a.
    OPEN c_employees(1000, 5000, 'a');
    LOOP
        FETCH c_employees INTO v_employee;
        EXIT WHEN c_employees%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('imię: ' || v_employee.first_name || ', nazwisko: ' || v_employee.last_name || ', pensja: ' || v_employee.salary);
    END LOOP;
    CLOSE c_employees;

    --b.
    OPEN c_employees(5000, 20000, 'u');
    LOOP
        FETCH c_employees INTO v_employee;
        EXIT WHEN c_employees%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('imię: ' || v_employee.first_name || ', nazwisko: ' || v_employee.last_name || ', pensja: ' || v_employee.salary);
    END LOOP;
    CLOSE c_employees;
END;
/

--10.
CREATE TABLE STATYSTYKI_MENEDZEROW (manager_id NUMBER, employee_count NUMBER, salary_diff NUMBER);
DECLARE
    v_manager_id employees.manager_id%TYPE;
    v_employee_count NUMBER;
    v_salary_diff NUMBER;
BEGIN
    FOR rec IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL) LOOP
        v_manager_id := rec.manager_id;
        SELECT COUNT(*), (MAX(salary) - MIN(salary)) INTO v_employee_count, v_salary_diff
        FROM employees
        WHERE manager_id = v_manager_id;
        INSERT INTO STATYSTYKI_MENEDZEROW (manager_id, employee_count, salary_diff)
        VALUES (v_manager_id, v_employee_count, v_salary_diff);
    END LOOP;
END;
/