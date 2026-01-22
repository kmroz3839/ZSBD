CREATE SEQUENCE sale_seq START WITH 1;
CREATE OR REPLACE TRIGGER sale_trigger
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    pkg_store.validate_sale(:NEW.game_id, :NEW.quantity);
    SELECT sale_seq.NEXTVAL INTO :NEW.sale_id FROM dual;
    pkg_store.decrement_inventory(:NEW.game_id, :NEW.quantity);
END;
/

CREATE SEQUENCE customer_seq START WITH 1;
CREATE OR REPLACE TRIGGER customer_trigger
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    SELECT customer_seq.NEXTVAL INTO :NEW.customer_id FROM dual;
END;
/