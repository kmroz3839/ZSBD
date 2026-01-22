CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL
);

CREATE TABLE games (
    serial VARCHAR(32) NOT NULL,
    title VARCHAR(300) NOT NULL,
    platform VARCHAR(8) NOT NULL,
    PRIMARY KEY (serial)
);
CREATE TABLE games_staging (
    serial VARCHAR(32) NOT NULL,
    title VARCHAR(300) NOT NULL,
    platform VARCHAR(8) NOT NULL,
    PRIMARY KEY (serial)
);

CREATE TABLE inventory (
    game_id VARCHAR(32) PRIMARY KEY,
    stock INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(serial)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    game_id VARCHAR(32) NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    customer_id INT,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (game_id) REFERENCES games(serial)
);

CREATE TABLE operation_logs (
    action VARCHAR(255),
    action_date DATE NOT NULL
);