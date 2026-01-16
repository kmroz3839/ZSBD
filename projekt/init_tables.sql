CREATE TABLE `customers` (
    `customer_id` INT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE `employees` (
    `employee_id` INT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `position` VARCHAR(100) NOT NULL,
    `hire_date` DATE NOT NULL
);

CREATE TABLE `games` (
    `serial` VARCHAR(32) NOT NULL,
    `title` TEXT NOT NULL,
    `platform` TEXT NOT NULL,
    PRIMARY KEY (`serial`)
);

CREATE TABLE `inventory` (
    `game_id` VARCHAR(32) PRIMARY KEY,
    `stock` INT NOT NULL,
    FOREIGN KEY (`game_id`) REFERENCES `games`(`serial`)
);

CREATE TABLE `sales` (
    `sale_id` INT PRIMARY KEY,
    `game_id` VARCHAR(32) NOT NULL,
    `sale_date` DATE NOT NULL,
    `quantity` INT NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `customer_id` INT,
    `employee_id` INT,
    FOREIGN KEY (`employee_id`) REFERENCES `employees`(`employee_id`),
    FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`),
    FOREIGN KEY (`game_id`) REFERENCES `games`(`serial`)
);


--sprawdź czy jest wystarczająco dużo w magazynie i czy id istnieje
CREATE OR REPLACE PROCEDURE validate_sale (
    p_game_id IN VARCHAR2,
    p_quantity IN INT
) AS
    v_stock INT;
DECLARE
    no_stock EXCEPTION;
BEGIN
    SELECT stock INTO v_stock FROM inventory WHERE game_id = p_game_id;
    IF v_stock < p_quantity THEN
        raise no_stock;
    ELSE IF v_stock IS NULL THEN
        RAISE NO_DATA_FOUND;
    END IF;

    EXCEPTION
        WHEN no_stock THEN
            RAISE_APPLICATION_ERROR(-20001, 'brak w magazynie: ' || p_game_id);
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'nie znaleziono id: ' || p_game_id);
END;
/

--trigger przed dodaniem sprzedaży
CREATE SEQUENCE sale_seq START WITH 1;
CREATE OR REPLACE TRIGGER sale_trigger
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    validate_sale(:NEW.game_id, :NEW.quantity);
    --auto increment sale_id
    SELECT sale_seq.NEXTVAL INTO :NEW.sale_id FROM dual;
    decrement_inventory(:NEW.game_id, :NEW.quantity);
END;
/

--trigger przed dodaniem klienta
CREATE SEQUENCE customer_seq START WITH 1;
CREATE OR REPLACE TRIGGER customer_trigger
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    --auto increment customer_id
    SELECT customer_seq.NEXTVAL INTO :NEW.customer_id FROM dual;
END;
/

CREATE OR REPLACE PROCEDURE decrement_inventory (
    p_game_id IN VARCHAR2,
    p_quantity IN INT
) AS
BEGIN
    UPDATE inventory
    SET stock = stock - p_quantity
    WHERE game_id = p_game_id;
END;
/

CREATE OR REPLACE PROCEDURE update_inventory (
    p_game_id IN VARCHAR2,
    p_quantity IN INT
) AS
BEGIN
    UPDATE inventory
    SET stock = p_quantity
    WHERE game_id = p_game_id;
END;
/

CREATE OR REPLACE PROCEDURE sale_now (
    p_game_id IN VARCHAR2,
    p_quantity IN INT,
    p_price IN DECIMAL,
    p_customer_id IN INT,
    p_employee_id IN INT
) AS
BEGIN
    INSERT INTO sales (game_id, sale_date, quantity, price, customer_id, employee_id)
    VALUES (p_game_id, SYSDATE, p_quantity, p_price, p_customer_id, p_employee_id);
END;
/