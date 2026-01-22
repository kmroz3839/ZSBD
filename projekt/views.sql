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