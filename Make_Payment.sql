DROP PROCEDURE IF EXISTS MAKE_PAYMENT;

DELIMITER $$

#Insert the payment total with tax for the booking id, in order to start the payment process.

CREATE PROCEDURE MAKE_PAYMENT (IN book_id INTEGER, IN subtotal DECIMAL(8,2))

BEGIN
	DECLARE total_with_tax DECIMAL(8,2);
    SET total_with_tax = subtotal + (subtotal * 1.18);
	INSERT INTO PAYMENT (PAYMENT_Sub_Total,Total_With_Tax,BOOKING_ID) VALUES 
		(subtotal,total_with_tax, book_id);
END $$

DELIMITER ;