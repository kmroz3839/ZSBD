CREATE OR REPLACE PACKAGE pkg_store AS
    PROCEDURE check_game_id(p_game_id IN VARCHAR2);
    PROCEDURE validate_sale(p_game_id IN VARCHAR2, p_quantity IN INT);
    PROCEDURE decrement_inventory(p_game_id IN VARCHAR2, p_quantity IN INT);
    PROCEDURE update_inventory(p_game_id IN VARCHAR2, p_quantity IN INT);
    FUNCTION sale_now(p_game_id IN VARCHAR2, p_quantity IN INT, p_price IN DECIMAL, p_customer_id IN INT, p_employee_id IN INT) RETURN INT;
END pkg_store;
/

CREATE OR REPLACE PACKAGE BODY pkg_store AS

    PROCEDURE check_game_id(p_game_id IN VARCHAR2) IS
        v_count INT;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM games WHERE serial = p_game_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'nieprawidłowe id gry: ' || p_game_id);
        END IF;
    END check_game_id;

    PROCEDURE validate_sale(p_game_id IN VARCHAR2, p_quantity IN INT) IS
        v_stock INT;
    BEGIN
        check_game_id(p_game_id);
        SELECT stock INTO v_stock FROM inventory WHERE game_id = p_game_id;
        IF v_stock < p_quantity THEN
            RAISE_APPLICATION_ERROR(-20001, 'brak w magazynie: ' || p_game_id);
        ELSIF v_stock IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'nie znaleziono id: ' || p_game_id);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'nie znaleziono id: ' || p_game_id);
    END validate_sale;

    PROCEDURE decrement_inventory(p_game_id IN VARCHAR2, p_quantity IN INT) IS
    BEGIN
        UPDATE inventory
        SET stock = stock - p_quantity
        WHERE game_id = p_game_id;
    END decrement_inventory;

    PROCEDURE update_inventory(p_game_id IN VARCHAR2, p_quantity IN INT) IS
    BEGIN
        UPDATE inventory
        SET stock = p_quantity
        WHERE game_id = p_game_id;
    END update_inventory;

    FUNCTION sale_now(p_game_id IN VARCHAR2, p_quantity IN INT, p_price IN DECIMAL, p_customer_id IN INT, p_employee_id IN INT) RETURN INT IS
        v_sale_id INT;
    BEGIN
        INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
        VALUES (p_game_id, SYSDATE, p_quantity, p_price, p_customer_id, p_employee_id)
        RETURNING sale_id INTO v_sale_id;
        RETURN v_sale_id;
    END sale_now;

END pkg_store;
/


CREATE OR REPLACE TRIGGER inventory_check_id
BEFORE INSERT ON inventory
FOR EACH ROW
BEGIN
    pkg_store.check_game_id(:NEW.game_id);
END;
/

CREATE OR REPLACE TRIGGER validate_game_id_trigger
BEFORE INSERT OR UPDATE ON games
FOR EACH ROW
BEGIN
    IF :NEW.serial IS NULL OR TRIM(:NEW.serial) = '' THEN
        RAISE_APPLICATION_ERROR(-20004, 'nieprawidłowe id');
    END IF;
END;
/