CREATE OR REPLACE VIEW v_available_games AS
SELECT g.serial, g.title, g.platform, i.stock
FROM games g
INNER JOIN inventory i ON g.serial = i.game_id
WHERE i.stock > 0;


CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS sale_month,
    SUM(s.quantity) AS total_quantity,
    SUM(s.price * s.quantity) AS total_revenue
FROM sales s
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY sale_month;

CREATE OR REPLACE VIEW v_quarterly_sales AS
SELECT
    TO_CHAR(s.sale_date, 'YYYY-"Q"Q') AS sale_quarter,
    SUM(s.quantity) AS total_quantity,
    SUM(s.price * s.quantity) AS total_revenue
FROM sales s
GROUP BY TO_CHAR(s.sale_date, 'YYYY-"Q"Q')
ORDER BY sale_quarter;

CREATE OR REPLACE VIEW v_yearly_sales AS
SELECT
    TO_CHAR(s.sale_date, 'YYYY') AS sale_year,
    SUM(s.quantity) AS total_quantity,
    SUM(s.price * s.quantity) AS total_revenue
FROM sales s
GROUP BY TO_CHAR(s.sale_date, 'YYYY')
ORDER BY sale_year;

CREATE OR REPLACE VIEW v_employee_sales AS
SELECT
    e.employee_id,
    e.name AS employee_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.price * s.quantity) AS total_revenue
FROM employees e
LEFT JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_id, e.name
ORDER BY total_revenue DESC;

CREATE TABLE sales_report (
    period VARCHAR2(30),
    total_quantity NUMBER,
    total_revenue NUMBER
);

CREATE OR REPLACE PACKAGE gen_reports AS
    PROCEDURE generate_monthly_sales_report;
    PROCEDURE generate_quarterly_sales_report;
    PROCEDURE generate_yearly_sales_report;
END gen_reports;
/
CREATE OR REPLACE PACKAGE BODY gen_reports AS
    PROCEDURE generate_monthly_sales_report IS
    BEGIN
        DELETE FROM sales_report;
        INSERT INTO sales_report (period, total_quantity, total_revenue)
        SELECT
            sale_month AS period,
            total_quantity,
            total_revenue
        FROM v_monthly_sales
        ORDER BY period;
    END generate_monthly_sales_report;

    PROCEDURE generate_quarterly_sales_report IS
    BEGIN
        DELETE FROM sales_report;
        INSERT INTO sales_report (period, total_quantity, total_revenue)
        SELECT
            sale_quarter AS period,
            total_quantity,
            total_revenue
        FROM v_quarterly_sales
        ORDER BY period;
    END generate_quarterly_sales_report;

    PROCEDURE generate_yearly_sales_report IS
    BEGIN
        DELETE FROM sales_report;
        INSERT INTO sales_report (period, total_quantity, total_revenue)
        SELECT
            sale_year AS period,
            total_quantity,
            total_revenue
        FROM v_yearly_sales
        ORDER BY period;
    END generate_yearly_sales_report;

END gen_reports;