DROP TRIGGER IF EXISTS upd_user;

DELIMITER $$
    CREATE TRIGGER upd_user BEFORE UPDATE ON customer
    FOR EACH ROW BEGIN
      IF (NEW.cust_pwd IS NULL OR NEW.cust_pwd = '') THEN
            SET NEW.cust_pwd = OLD.cust_pwd;
      ELSE
            SET NEW.cust_pwd = NEW.cust_pwd;
      END IF;
    END$$
DELIMITER ;
