--1.

CREATE TABLE REGIONS (
    region_id INT PRIMARY KEY NOT NULL,
    region_name VARCHAR(255)
);

CREATE TABLE COUNTRIES (
    country_id INT PRIMARY KEY NOT NULL,
    country_name VARCHAR2(255),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES REGIONS(region_id) ON DELETE CASCADE
);

CREATE TABLE LOCATIONS (
    location_id INT PRIMARY KEY NOT NULL,
    street_address VARCHAR2(255),
    postal_code VARCHAR2(10),
    city VARCHAR2(255),
    state_province VARCHAR2(255),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id) ON DELETE CASCADE
);

CREATE TABLE DEPARTMENTS (
    department_id INT PRIMARY KEY NOT NULL,
    department_name VARCHAR2(255),
    manager_id INT,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE
);

CREATE TABLE JOBS (
    job_id INT PRIMARY KEY NOT NULL,
    job_title VARCHAR2(255),
    min_salary DECIMAL(10, 2),
    max_salary DECIMAL(10, 2)
);

CREATE TABLE EMPLOYEES (
    employee_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR2(255),
    last_name VARCHAR2(255),
    email VARCHAR2(255),
    phone_number VARCHAR2(20),
    hire_date DATE,
    job_id INT,
    salary DECIMAL(10, 2),
    commission_pct DECIMAL(10, 2),
    manager_id INT,
    department_id INT,
    FOREIGN KEY (job_id) REFERENCES JOBS(job_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE CASCADE
);

CREATE TABLE JOB_HISTORY (
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT,
    PRIMARY KEY (employee_id, start_date),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES JOBS(job_id) ON DELETE CASCADE
    --FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE CASCADE
);

ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);

ALTER TABLE DEPARTMENTS ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id);

--2.
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (1, 'java developer', 30000, 60000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (2, 'sql developer', 25000, 50000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (3, 'python developer', 35000, 70000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (4, 'web developer', 20000, 40000);


--3.
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (1, 'Jan', '---', 'email@address.com', '000000000', TO_DATE('2025-10-02', 'YYYY-MM-DD'), 1, 50000, 0.1, NULL, NULL);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (2, 'Karol', '---', 'email@address.com', '000000000', TO_DATE('2025-10-01', 'YYYY-MM-DD'), 4, 50000, 0.1, NULL, NULL);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (3, 'Paweł', '---', 'email@address.com', '000000000', TO_DATE('2025-09-30', 'YYYY-MM-DD'), 3, 50000, 0.1, NULL, NULL);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES (4, 'Tomasz', '---', 'email@address.com', '000000000', TO_DATE('2025-09-29', 'YYYY-MM-DD'), 2, 50000, 0.1, NULL, NULL);


--4.
UPDATE EMPLOYEES SET manager_id = 1 WHERE employee_id IN (2,3);


--5.
UPDATE JOBS SET min_salary = min_salary + 500, max_salary = max_salary + 500 WHERE job_title LIKE '%b%' OR job_title LIKE '%s%';


--6.
DELETE FROM JOBS WHERE max_salary > 9000;