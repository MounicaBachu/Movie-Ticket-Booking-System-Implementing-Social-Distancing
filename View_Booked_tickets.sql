DROP PROCEDURE IF EXISTS View_Booked_seats;

DELIMITER $$

CREATE PROCEDURE View_Booked_seats (IN showid INTEGER)

BEGIN

	SELECT movie_show.SHOW_ID, count(show_seat.SHOW_SEAT_Status) as booked_seats
	FROM seat
	JOIN show_seat on seat.seat_id = show_seat.seat_id 
	JOIN movie_show on movie_show.show_id=show_seat.show_id 
	WHERE show_seat.SHOW_ID=showid
	GROUP BY movie_show.show_id;
	
END $$

DELIMITER ;