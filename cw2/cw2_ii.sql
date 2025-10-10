--reset
DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE job_grades CASCADE CONSTRAINTS;
DROP TABLE job_history CASCADE CONSTRAINTS;
DROP TABLE jobs CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE regions CASCADE CONSTRAINTS;
DROP TABLE sales CASCADE CONSTRAINTS;



--tabele
CREATE TABLE countries AS SELECT * FROM hr.countries;
CREATE TABLE departments AS SELECT * FROM hr.departments;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE job_grades AS SELECT * FROM hr.job_grades;
CREATE TABLE job_history AS SELECT * FROM hr.job_history;
CREATE TABLE jobs AS SELECT * FROM hr.jobs;
CREATE TABLE locations AS SELECT * FROM hr.locations;
CREATE TABLE products AS SELECT * FROM hr.products;
CREATE TABLE regions AS SELECT * FROM hr.regions;
CREATE TABLE sales AS SELECT * FROM hr.sales;

--klucze główne
ALTER TABLE countries ADD CONSTRAINT pk_countries PRIMARY KEY (country_id);
ALTER TABLE departments ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);
ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);
ALTER TABLE job_grades ADD CONSTRAINT pk_job_grades PRIMARY KEY (grade);
ALTER TABLE job_history ADD CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date);
ALTER TABLE jobs ADD CONSTRAINT pk_jobs PRIMARY KEY (job_id);
ALTER TABLE locations ADD CONSTRAINT pk_locations PRIMARY KEY (location_id);
ALTER TABLE products ADD CONSTRAINT pk_products PRIMARY KEY (product_id);
ALTER TABLE regions ADD CONSTRAINT pk_regions PRIMARY KEY (region_id);
ALTER TABLE sales ADD CONSTRAINT pk_sales PRIMARY KEY (sale_id);

--klucze obce
ALTER TABLE countries ADD CONSTRAINT fk_regions FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE;
ALTER TABLE departments ADD CONSTRAINT fk_locations FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE;
ALTER TABLE departments ADD CONSTRAINT fk_department_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE employees ADD CONSTRAINT fk_employee_job FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE;
ALTER TABLE employees ADD CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE employees ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE;
ALTER TABLE job_history ADD CONSTRAINT fk_jobhistory_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE job_history ADD CONSTRAINT fk_jobhistory_job FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE;
ALTER TABLE job_history ADD CONSTRAINT fk_jobhistory_department FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE;
ALTER TABLE locations ADD CONSTRAINT fk_countries FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE CASCADE;
ALTER TABLE sales ADD CONSTRAINT fk_sales_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE sales ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)