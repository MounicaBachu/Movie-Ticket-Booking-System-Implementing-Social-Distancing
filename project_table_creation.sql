CREATE DATABASE IF NOT EXISTS MOVIE_SOCIAL_DISTANCE;
USE MOVIE_SOCIAL_DISTANCE;
#
# Table structure for table 'THEATRE'
#
DROP TABLE IF EXISTS THEATRE;

CREATE TABLE THEATRE (
	Theatre_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	Theatre_Name 	VARCHAR(100)  	NOT NULL, 
	Theatre_Contact VARCHAR(15)		NOT NULL, 
	Theatre_Address VARCHAR(255)    NOT NULL,
    Theatre_Pincode	VARCHAR(6)		NOT NULL,
    CONSTRAINT Theatre_UI1 UNIQUE(Theatre_Contact)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE THEATRE AUTO_INCREMENT = 500;

#
# Table structure for table 'EMPLOYEE'
#
DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE EMPLOYEE (
	EMP_ID 			INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	EMP_LastName 	VARCHAR(100)  	NOT NULL, 
	EMP_FirstName 	VARCHAR(100)	NOT NULL,
    EMP_Age			INTEGER			NOT NULL,
    EMP_Designation VARCHAR(50)		NOT NULL,
	EMP_Email 		VARCHAR(100)    NOT NULL,
	EMP_Contact 	VARCHAR(15)		NOT NULL, 
	Theatre_ID 		INTEGER,
	CONSTRAINT Emp_theatre_FK FOREIGN KEY (Theatre_ID) REFERENCES THEATRE (Theatre_ID),
    CONSTRAINT Employee_UI1 UNIQUE(EMP_Email,EMP_Contact),
    CONSTRAINT Employee_age CHECK(EMP_Age >= 18 AND EMP_AGE <=60)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

#
# Table structure for table 'SCREEN'
#
DROP TABLE IF EXISTS SCREEN;

CREATE TABLE SCREEN (
	SCREEN_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	SCREEN_Name 	VARCHAR(50)  	NOT NULL, 
	Total_Seats 	INTEGER			NOT NULL, 
	Theatre_ID 		INTEGER,
	CONSTRAINT Screen_theatre_FK FOREIGN KEY (Theatre_ID) REFERENCES THEATRE (Theatre_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE SCREEN AUTO_INCREMENT = 1000;

#
# Table structure for table 'SEAT'
#
DROP TABLE IF EXISTS SEAT;

CREATE TABLE SEAT (
	SEAT_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
    ROW_No			CHAR(1)		    NOT NULL,
	SEAT_No 		INTEGER  		NOT NULL,
    Is_Available	BOOL			NOT NULL		DEFAULT 1,
    SEAT_Price		DECIMAL(5,2)	NOT NULL,
	SCREEN_ID 		INTEGER, 
	CONSTRAINT Seat_screen_FK FOREIGN KEY (SCREEN_ID) REFERENCES SCREEN (SCREEN_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE SEAT AUTO_INCREMENT = 10000;

#
# Table structure for table 'MOVIE'
#
DROP TABLE IF EXISTS MOVIE;

CREATE TABLE MOVIE (
	MOVIE_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	MOVIE_Title 	VARCHAR(100)  	NOT NULL, 
	MOVIE_Desc 		VARCHAR(400), 
	MOVIE_Genre		VARCHAR(50),
	MOVIE_Language	VARCHAR(50),
    MOVIE_Duration 	TIME			NOT NULL,
    MOVIE_Release	DATE			NOT NULL,
    MOVIE_Rating	DECIMAL(4,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE MOVIE AUTO_INCREMENT = 7000;

#
# Table structure for table 'Movie_SHOW'
#
DROP TABLE IF EXISTS MOVIE_SHOW;

CREATE TABLE MOVIE_SHOW (
	SHOW_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	SHOW_Date	 	DATE  			NOT NULL, 
	SHOW_Starttime 	TIME			NOT NULL, 
	SHOW_Endtime	TIME			NOT NULL,
    Is_Sanitized	BOOL			NOT NULL		DEFAULT 1,
    SCREEN_ID		INTEGER,
    MOVIE_ID		INTEGER,
	CONSTRAINT Show_Screen_FK FOREIGN KEY (SCREEN_ID) REFERENCES SCREEN (SCREEN_ID),
    CONSTRAINT Show_Movie_FK FOREIGN KEY (MOVIE_ID) REFERENCES MOVIE (MOVIE_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE MOVIE_SHOW AUTO_INCREMENT = 50000;

#
# Table structure for table 'CUSTOMER'
#
DROP TABLE IF EXISTS CUSTOMER;

CREATE TABLE CUSTOMER (
	CUST_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	CUST_LastName	VARCHAR(100)  	NOT NULL,
    CUST_FirstName	VARCHAR(100)  	NOT NULL,
    CUST_Age		INTEGER			NOT NULL,
    CUST_Username	VARCHAR(50)		NOT NULL,
    CUST_Pwd		VARCHAR(50)     NOT NULL,
    CUST_Email		VARCHAR(100)	NOT NULL,
	CUST_Contact	VARCHAR(15)     NOT NULL,
    CUST_DOJ		DATE,
    CONSTRAINT Customer_UI1 UNIQUE(CUST_Username,CUST_Email,CUST_Contact),
    CONSTRAINT Customer_age CHECK(CUST_Age >= 18)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE CUSTOMER AUTO_INCREMENT = 200;

#
# Table structure for table 'BOOKING'
#
DROP TABLE IF EXISTS BOOKING;

CREATE TABLE BOOKING (
	BOOKING_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT, 
	No_Of_Seats	 	INTEGER  		NOT NULL, 
	BOOKING_Status 	VARCHAR(10)		NOT NULL, 
    BOOKING_Price	DECIMAL(8,2)	NOT NULL,
	BOOKING_Time	TIMESTAMP		NOT NULL,
    SHOW_ID			INTEGER,
    CUST_ID			INTEGER,
	CONSTRAINT Booking_Show_FK FOREIGN KEY (SHOW_ID) REFERENCES MOVIE_SHOW (SHOW_ID),
    CONSTRAINT Booking_Customer_FK FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER (CUST_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE BOOKING AUTO_INCREMENT = 30000;

#
# Table structure for table 'SHOW_SEAT'
#
DROP TABLE IF EXISTS SHOW_SEAT;

CREATE TABLE SHOW_SEAT (
	SHOW_SEAT_ID 		INTEGER 		PRIMARY KEY		AUTO_INCREMENT,	 
	SHOW_SEAT_Status	BOOL			NOT NULL 		DEFAULT 1, 
	SEAT_ID				INTEGER,
    SHOW_ID				INTEGER,
    BOOKING_ID			INTEGER,
	CONSTRAINT Showseat_Seat_FK FOREIGN KEY (SEAT_ID) REFERENCES SEAT (SEAT_ID),
    CONSTRAINT Showseat_Movieshow_FK FOREIGN KEY (SHOW_ID) REFERENCES MOVIE_SHOW (SHOW_ID),
    CONSTRAINT Showseat_Booking_FK FOREIGN KEY (BOOKING_ID) REFERENCES BOOKING (BOOKING_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE SHOW_SEAT AUTO_INCREMENT = 70000;

#
# Table structure for table 'PAYMENT'
#
DROP TABLE IF EXISTS PAYMENT;

CREATE TABLE PAYMENT (
	PAYMENT_ID 		  INTEGER 	PRIMARY KEY		AUTO_INCREMENT, 
	PAYMENT_Mode	  VARCHAR(15), 
	PAYMENT_Sub_Total DECIMAL(8,2)	NOT NULL,
    PAYMENT_Status    VARCHAR(10),
	Total_With_Tax    DECIMAL(8,2)	NOT NULL,
    PAYMENT_Time	  TIMESTAMP,
    Remote_Trans_ID	  VARCHAR(21),	
    BOOKING_ID		  INTEGER,
    CONSTRAINT Payment_Booking_FK FOREIGN KEY (BOOKING_ID) REFERENCES BOOKING (BOOKING_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET autocommit=1;

ALTER TABLE PAYMENT AUTO_INCREMENT = 50;