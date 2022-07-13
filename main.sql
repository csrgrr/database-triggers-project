SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

CREATE TRIGGER customer_updated
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE PROCEDURE log_customers_change();

UPDATE customers
SET first_name = 'Steve'
WHERE last_name = 'Hall';
 
SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

UPDATE customers
SET years_old = 10
WHERE last_name = 'Hall';
 
SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

CREATE TRIGGER customer_insert
    AFTER INSERT ON customers
    FOR EACH STATEMENT
    EXECUTE PROCEDURE log_customers_change();

CREATE OR REPLACE FUNCTION log_customers_change() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            IF (NEW.first_name <> OLD.first_name OR NEW.last_name <> OLD.last_name) THEN
                INSERT INTO customers_log (changed_by, time_changed, change_type) VALUES (User, DATE_TRUNC('minute',NOW()), 'UPDATE');
            END IF;
        END IF;
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO customers_log (changed_by, time_changed, change_type) VALUES (User, DATE_TRUNC('minute',NOW()), 'INSERT');
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

INSERT INTO customers (first_name, last_name,years_old)
VALUES
    ('Jeffrey','Cook',66),
    ('Arthur','Turner',49),
    ('Nathan','Cooper',72);
 
SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

CREATE TRIGGER customer_min_age
    BEFORE UPDATE ON customers
    FOR EACH ROW
    WHEN (NEW.years_old < 13)
    EXECUTE PROCEDURE override_with_min_age();

UPDATE customers
SET years_old = 12
WHERE last_name = 'Campbell';
 
UPDATE customers
SET years_old = 24
WHERE last_name = 'Cook';
 
SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

UPDATE customers
SET years_old = 9,
    first_name = 'Dennis'
WHERE last_name = 'Hall';
 
SELECT *
FROM customers
ORDER BY customer_id;
 
SELECT *
FROM customers_log;

DROP TRIGGER IF EXISTS customer_min_age ON customers;
SELECT * FROM information_schema.triggers;

