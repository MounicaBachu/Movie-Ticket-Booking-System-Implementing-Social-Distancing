DROP PROCEDURE IF EXISTS createCustomer;

DELIMITER $$

CREATE PROCEDURE createCustomer( 
	IN  c_CUST_LastName	VARCHAR(50) ,
	IN  c_CUST_FirstName	VARCHAR(50) ,
	IN	c_CUST_Age	INTEGER	,
	IN	c_CUST_Username	VARCHAR(50),
	IN	c_CUST_Pwd	VARCHAR(15),
	IN	c_CUST_Email	VARCHAR(50),
	IN c_CUST_Contact	VARCHAR(10)
)

BEGIN
	INSERT INTO CUSTOMER(CUST_LastName,CUST_FirstName,CUST_Age,CUST_Username,CUST_Pwd,CUST_Email,CUST_Contact,
		CUST_DOJ) VALUES(c_CUST_LastName,c_CUST_FirstName,c_CUST_Age,c_CUST_Username,c_CUST_Pwd,c_CUST_Email,
		c_CUST_Contact,DATE_FORMAT(NOW(),'%Y-%m-%d'));
        
END$$

DELIMITER ;
