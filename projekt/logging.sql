CREATE OR REPLACE PACKAGE pkg_logging AS
    PROCEDURE log_action(p_action IN VARCHAR2);
END pkg_logging;
/

CREATE OR REPLACE PACKAGE BODY pkg_logging AS
    PROCEDURE log_action(p_action IN VARCHAR2) IS
    BEGIN
        INSERT INTO operation_logs (action, action_date)
        VALUES (p_action, SYSDATE);
    END log_action;
END pkg_logging;
/

--log
CREATE OR REPLACE TRIGGER log_trigger
AFTER INSERT OR UPDATE OR DELETE ON sales
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        pkg_logging.log_action('Dodano sprzedaż: ' || :NEW.sale_id);
    ELSIF UPDATING THEN
        pkg_logging.log_action('Zaktualizowano sprzedaż: ' || :NEW.sale_id);
    ELSIF DELETING THEN
        pkg_logging.log_action('Usunięto sprzedaż: ' || :OLD.sale_id);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER log_trigger2
AFTER INSERT OR UPDATE OR DELETE ON inventory
FOR EACH ROW
BEGIN
    IF DELETING THEN
        pkg_logging.log_action('Usunięto z magazynu: ' || :OLD.game_id);
    ELSE
        pkg_logging.log_action('Zmiana stanu magazynu: ' || :NEW.game_id || ' - ' || :NEW.stock);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER log_trigger3
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
BEGIN
    IF DELETING THEN
        pkg_logging.log_action('Usunięto klienta: ' || :OLD.customer_id);
    ELSIF INSERTING THEN
        pkg_logging.log_action('Dodano klienta: ' || :NEW.customer_id);
    ELSE
        pkg_logging.log_action('Zmiana stanu klienta: ' || :NEW.customer_id);
    END IF;
END;
/


CREATE TABLE sales_archive (
    sale_id INT,
    game_id VARCHAR(32) NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    customer_id INT,
    employee_id INT
);
CREATE OR REPLACE TRIGGER archive_deleted_sales
BEFORE DELETE ON sales
FOR EACH ROW
BEGIN
    INSERT INTO sales_archive (sale_id, game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES (:OLD.sale_id, :OLD.game_id, :OLD.sale_date, :OLD.quantity, :OLD.price, :OLD.customer_id, :OLD.employee_id);
END;
/