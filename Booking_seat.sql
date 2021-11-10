DROP PROCEDURE IF EXISTS SEAT_BOOKING;

DELIMITER $$
# Assumption that only available seats are visible to the customer

CREATE PROCEDURE SEAT_BOOKING (
	IN seats INTEGER, 
    IN seat_num VARCHAR(50), 
    IN showid INTEGER, 
	IN theatreid INTEGER, 
    IN custid INTEGER
)

BEGIN
	DECLARE counter1 INTEGER;
    DECLARE counter2 INTEGER;
    DECLARE seatprice DECIMAL(8,2);
    DECLARE book_price DECIMAL(8,2);
    DECLARE rowno VARCHAR(20);
    DECLARE seatno INTEGER;
    DECLARE seat VARCHAR(20);
    DECLARE seatid INTEGER;
    DECLARE bookid INTEGER;
    DECLARE screenid INTEGER;
    DECLARE rowno_seat1 VARCHAR(20);
    DECLARE old_rowno VARCHAR(20);
    DECLARE old_seatno INTEGER;
    DECLARE old_seatid INTEGER;
    
    SET counter1 = 1;
    SET counter2 = 1;
    SET book_price = 0;
	
    # Fetch the screen_id for the given show_id
    
    SET screenid = (SELECT SCREEN_ID FROM MOVIE_SHOW WHERE SHOW_ID = showid);
    
    # Calculate the price for the given seats
    
    seatloop: LOOP 
        IF counter1 <= seats THEN
        
			SET seat = 	 SUBSTRING_INDEX(SUBSTRING_INDEX(seat_num,',',counter1), ',', -1);
			SET rowno =  SUBSTRING_INDEX(SUBSTRING_INDEX(seat,':',1), ':', -1);
            SET seatno = SUBSTRING_INDEX(SUBSTRING_INDEX(seat,':',2), ':', -1);
            
            # Fetch the seat id for the given combination of row no and seat no
            
            SET seatid = (SELECT SEAT_ID FROM SEAT WHERE ROW_No = rowno AND SEAT_No = seatno 
							AND SCREEN_ID = screenid);
			
            # Fetch the price for each price and add to the total booking price
            
			SET seatprice = (SELECT SEAT_Price FROM SEAT WHERE SEAT_ID = seatid);
            SET book_price = book_price + seatprice;
            
		ELSE
			LEAVE seatloop;
            
		END IF;
        SET counter1 = counter1 + 1;
	END LOOP;
    
    
    # Insert the booking details for the given number of seats
    
    INSERT INTO BOOKING (No_Of_Seats,BOOKING_STATUS,BOOKING_Price,BOOKING_Time,SHOW_ID,CUST_ID) VALUES 
		(seats,'Success', book_price, CURRENT_TIMESTAMP, showid, custid);
	
    # Fetch the book_id for the inserted booking details
    
    SET bookid = (SELECT BOOKING_ID FROM BOOKING WHERE CUST_ID = custid AND 
					DATE_FORMAT(BOOKING_Time,'%y-$m-$d %h:%i') = DATE_FORMAT(NOW(),'%y-$m-$d %h:%i') 
					AND No_Of_Seats = seats AND SHOW_ID = showid);
    
	# update the payment table with price and the booking id to process the payment
    
    CALL MAKE_PAYMENT (bookid,book_price);
    
    # Loop is used to split the seat_num to the necessary fields in the tables.
    # seat_num will be in the combination of format of 'rowno:seatno'
    
    seatloop: LOOP 
        IF counter2 <= seats THEN
        
			SET seat = 	 SUBSTRING_INDEX(SUBSTRING_INDEX(seat_num,',',counter2), ',', -1);
			SET rowno =  SUBSTRING_INDEX(SUBSTRING_INDEX(seat,':',1), ':', -1);
            SET seatno = SUBSTRING_INDEX(SUBSTRING_INDEX(seat,':',2), ':', -1);
            
            # Fetch the seat id for the given combination of row no and seat no
            
            SET seatid = (SELECT SEAT_ID FROM SEAT WHERE ROW_No = rowno AND SEAT_No = seatno 
							AND SCREEN_ID = screenid);
            
            # Insert the entries into show_seat table to block the given seats for the corressponding show
            INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
				(0,seatid,showid,bookid);
            
            # Logic to implement blocking of adjacent seats for the given booking starts...
            
            # Assume all the given seats are booked for the rowno of the first given seat.
            
			IF counter2 = 1 THEN
                SET rowno_seat1 = rowno;
			END IF;
            
            IF rowno = rowno_seat1 THEN
            
            # Block the adjacent seats on the left side of the first seat of the given booking
            
				IF counter2 = 1 THEN
					IF seatno <> 1 AND seatno <> 2 THEN
						INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
							(0,seatid-1,showid,bookid);
						INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
							(0,seatid-2,showid,bookid);
                    ELSE 
						IF seatno = 2 THEN
							INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid-1,showid,bookid);
						END IF;
                    END IF;
				END IF;
                
                # Block the adjacent seats on the right side of the last seat of the given booking
                
				IF counter2 = seats THEN
						IF seatno <> 9 AND seatno <> 10 THEN
							INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+1,showid,bookid);
							INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+2,showid,bookid);
						ELSE 
							IF seatno = 9 THEN
								INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+1,showid,bookid);
							END IF;
						END IF;
				END IF;
                
                # Store the previous row-seat combination for futher processing if required 
                
				SET old_rowno = rowno;
				SET old_seatno = seatno;
                SET old_seatid = seatid;
            
            ELSE 
            # Logic to implement if the customer books seats in different rows.
            # Set the new rowno to the temporary variable 
            
				SET rowno_seat1 = rowno;
                
			# Block the adjacent seats on the right side of the previous row
            
                IF old_seatno <> 9 AND old_seatno <> 10 THEN
					INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,old_seatid+1,showid,bookid);
					INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,old_seatid+2,showid,bookid);
				ELSE 
					IF old_seatno = 9 THEN
						INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,old_seatid+1,showid,bookid);
					END IF;
				END IF;
                
			# Block the adjacent seats on the left side of the seat in the new row
            
                IF seatno <> 1 AND seatno <> 2 THEN
					INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,seatid-1,showid,bookid);
					INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,seatid-2,showid,bookid);
				ELSE 
					IF seatno = 2 THEN
						INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
						(0,seatid-1,showid,bookid);
					END IF;
				END IF;
                
                # If this is the only seat in the new row, then block the adjacent seats on the right side 
                # of the seat.
                
                IF counter2 = seats THEN
					IF seatno <> 9 AND seatno <> 10 THEN
							INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+1,showid,bookid);
							INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+2,showid,bookid);
						ELSE 
							IF seatno = 9 THEN
								INSERT INTO SHOW_SEAT (SHOW_SEAT_STATUS,SEAT_ID,SHOW_ID,BOOKING_ID) VALUES 
								(0,seatid+1,showid,bookid);
							END IF;
						END IF;
				 END IF;
              
            END IF;
		
        ELSE
			LEAVE seatloop;
            
		END IF;
        SET counter2 = counter2 + 1;
	END LOOP;
			
			

END$$

DELIMITER ;