INSERT INTO employees (employee_id, name, position, hire_date) VALUES 
    (1, 'Jan Smok', 'Sales Manager', TO_DATE('2020-01-15', 'YYYY-MM-DD'));

INSERT INTO games (serial, title, platform) VALUES ('ABC123', 'Game One', 'PS3');
INSERT INTO games (serial, title, platform) VALUES ('ABC234', 'Game Two', 'PS3');
INSERT INTO inventory (game_id, stock) VALUES ('ABC123', 50);
INSERT INTO inventory (game_id, stock) VALUES ('ABC234', 10);
INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES ('ABC123', SYSDATE, 1, 10.20, NULL, 1);
INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES ('ABC234', SYSDATE, 2, 20.40, NULL, 1);
INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES ('ABC123', SYSDATE, 3, 30.60, NULL, 1);
    
INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES ('ABC123', TO_DATE('2025-01-01', 'YYYY-MM-DD'), 3, 30.60, NULL, 1);

SELECT * FROM v_monthly_sales;
SELECT * FROM v_employee_sales;
SELECT * FROM v_yearly_sales;

DECLARE
    new_id INT;
BEGIN
    new_id := pkg_store.sale_now('ABC234', 1, 10.00, NULL, NULL);
    DBMS_OUTPUT.PUT_LINE('Nowa sprzedaż: ' || new_id);
END;
/

DELETE FROM sales WHERE sale_id = 7;


BEGIN
    gen_reports.generate_monthly_sales_report();
END;
/
BEGIN
    gen_reports.generate_quarterly_sales_report();
END;
/
BEGIN
    gen_reports.generate_yearly_sales_report();
END;
/

SELECT * FROM sales_report;