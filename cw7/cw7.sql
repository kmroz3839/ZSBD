
--1.
CREATE OR REPLACE FUNCTION get_job_title (
    p_job_id IN jobs.job_id%TYPE
) RETURN jobs.job_title%TYPE AS
    v_job_title jobs.job_title%TYPE;
BEGIN
    SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
    RETURN v_job_title;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013, 'no job found for id: ' || p_job_id);
END get_job_title;
/


--2.
CREATE OR REPLACE FUNCTION get_yearly_salary (
    p_employee_id IN employees.employee_id%TYPE
) RETURN NUMBER AS
    v_salary NUMBER;
    v_commission_pct NUMBER;
    v_yearly_salary NUMBER;
BEGIN
    SELECT salary, NVL(commission_pct, 0) INTO v_salary, v_commission_pct FROM employees WHERE employee_id = p_employee_id;
    v_yearly_salary := (v_salary * 12) + (v_salary * v_commission_pct);
    RETURN v_yearly_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20014, 'no employee found for id: ' || p_employee_id);
END get_yearly_salary;
/


--3.
CREATE OR REPLACE FUNCTION extract_country_code (
    p_phone IN VARCHAR2
) RETURN VARCHAR2 AS
    v_country_code VARCHAR2(10);
    v_start_pos NUMBER;
    v_end_pos NUMBER;
BEGIN
    v_start_pos := INSTR(p_phone, '(') + 1;
    v_end_pos := INSTR(p_phone, ')');
    IF v_start_pos > 0 AND v_end_pos > v_start_pos THEN
        v_country_code := SUBSTR(p_phone, v_start_pos, v_end_pos - v_start_pos);
        RETURN v_country_code;
    ELSE
        RETURN NULL;
    END IF;
END extract_country_code;
/


--4.
CREATE OR REPLACE FUNCTION capitalize_first_last (
    p_input IN VARCHAR2
) RETURN VARCHAR2 AS
    v_length NUMBER := LENGTH(p_input);
    v_result VARCHAR2(4000);
BEGIN
    IF v_length = 0 THEN
        RETURN p_input;
    ELSIF v_length = 1 THEN
        RETURN UPPER(p_input);
    ELSE
        v_result := UPPER(SUBSTR(p_input, 1, 1)) ||
                    LOWER(SUBSTR(p_input, 2, v_length - 2)) ||
                    UPPER(SUBSTR(p_input, v_length, 1));
        RETURN v_result;
    END IF;
END capitalize_first_last;
/


--5.


--6.
CREATE OR REPLACE FUNCTION get_emp_dept_count (
    p_country_name IN countries.country_name%TYPE
) RETURN VARCHAR2 AS
    v_country_id countries.country_id%TYPE;
    v_employee_count NUMBER;
    v_department_count NUMBER;
    v_result VARCHAR2(100);
BEGIN
    SELECT country_id INTO v_country_id FROM countries WHERE country_name = p_country_name;
    SELECT COUNT(*) INTO v_employee_count FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    WHERE l.country_id = v_country_id;
    SELECT COUNT(*) INTO v_department_count FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    WHERE l.country_id = v_country_id;
    v_result := 'Employees: ' || v_employee_count || ', Departments: ' || v_department_count;
    RETURN v_result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20015, 'country not found: ' || p_country_name);
END get_emp_dept_count;
/


--7.
CREATE OR REPLACE FUNCTION generate_unique_id (
    p_first_name IN employees.first_name%TYPE,
    p_last_name IN employees.last_name%TYPE,
    p_phone IN employees.phone_number%TYPE
) RETURN VARCHAR2 AS
    v_last_name_part VARCHAR2(3);
    v_phone_part VARCHAR2(4);
    v_first_name_part VARCHAR2(1);
    v_unique_id VARCHAR2(20);
BEGIN
    v_last_name_part := SUBSTR(UPPER(p_last_name), 1, 3);
    v_phone_part := SUBSTR(REGEXP_REPLACE(p_phone, '\D', ''), -4);
    v_first_name_part := SUBSTR(UPPER(p_first_name), 1, 1);
    v_unique_id := v_last_name_part || v_phone_part || v_first_name_part;
    RETURN v_unique_id;
END generate_unique_id;
/