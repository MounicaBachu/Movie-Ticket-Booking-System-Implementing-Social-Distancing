DROP PROCEDURE IF EXISTS createEmployee;

DELIMITER $$

CREATE PROCEDURE createEmployee(
	e_EMP_LastName	VARCHAR(100) ,
	e_EMP_FirstName	VARCHAR(100) ,
    e_EMP_Age INTEGER,
	e_EMP_Designation VARCHAR(50),
	e_EMP_Email 	VARCHAR(100),
	e_EMP_Contact 	VARCHAR(15)	,
	e_Theatre_ID INTEGER)
BEGIN

	INSERT INTO EMPLOYEE(EMP_LastName,EMP_FirstName,EMP_Age,EMP_DESIGNATION,EMP_Email,EMP_Contact,Theatre_ID)
	VALUES (e_EMP_LastName,e_EMP_FirstName,e_EMP_Age,e_EMP_Designation,e_EMP_Email,e_EMP_Contact,e_Theatre_ID);
    
END$$

DELIMITER ;
