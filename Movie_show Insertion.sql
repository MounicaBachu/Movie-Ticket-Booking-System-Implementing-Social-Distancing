DROP PROCEDURE IF EXISTS createMovieShow;

DELIMITER $$

CREATE PROCEDURE createMovieShow( 
	IN s_SHOW_Date	DATE , 
	IN	s_SHOW_Starttime 	TIME, 
	IN s_SHOW_Endtime	TIME,
	IN s_Is_Sanitized	BOOL,
	IN s_SCREEN_ID	INTEGER,
	IN s_MOVIE_ID	INTEGER
)

BEGIN
	INSERT INTO MOVIE_SHOW(SHOW_Date,SHOW_Starttime ,SHOW_Endtime,Is_Sanitized,SCREEN_ID,MOVIE_ID)
	VALUES(s_SHOW_Date,s_SHOW_Starttime,s_SHOW_Endtime,s_Is_Sanitized,s_SCREEN_ID,s_MOVIE_ID);
    
END$$

DELIMITER ;
