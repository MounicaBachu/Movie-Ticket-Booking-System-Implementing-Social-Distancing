DROP PROCEDURE IF EXISTS createMovie;

DELIMITER $$

CREATE PROCEDURE createMovie(
	IN	m_MOVIE_Title 	VARCHAR(50)  , 
	IN	m_MOVIE_Desc 	VARCHAR(400), 
	IN	m_MOVIE_Genre	VARCHAR(50),
	IN m_MOVIE_Language	VARCHAR(50),
	IN 	m_MOVIE_Duration TIME,
	IN 	m_MOVIE_Release	DATE,
	IN 	m_MOVIE_Rating	DECIMAL(5,2)
)

BEGIN
	INSERT INTO MOVIE(MOVIE_Title ,MOVIE_Desc,MOVIE_Genre,MOVIE_Language,MOVIE_Duration ,MOVIE_Release,MOVIE_Rating) 
	VALUES(m_MOVIE_Title,m_MOVIE_Desc,m_MOVIE_Genre,m_MOVIE_Language,m_MOVIE_Duration,m_MOVIE_Release,m_MOVIE_Rating);
    
END$$

DELIMITER ;
