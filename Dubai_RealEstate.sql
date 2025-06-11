SELECT TOP (1000) [transaction_id]
      ,[procedure_id]
      ,[trans_group_id]
      ,[trans_group_ar]
      ,[trans_group_en]
      ,[procedure_name_ar]
      ,[procedure_name_en]
      ,[instance_date]
      ,[property_type_id]
      ,[property_type_ar]
      ,[property_type_en]
      ,[property_sub_type_id]
      ,[property_sub_type_ar]
      ,[property_sub_type_en]
      ,[property_usage_ar]
      ,[property_usage_en]
      ,[reg_type_id]
      ,[reg_type_ar]
      ,[reg_type_en]
      ,[area_id]
      ,[area_name_ar]
      ,[area_name_en]
      ,[building_name_ar]
      ,[building_name_en]
      ,[project_number]
      ,[project_name_ar]
      ,[project_name_en]
      ,[master_project_en]
      ,[master_project_ar]
      ,[nearest_landmark_ar]
      ,[nearest_landmark_en]
      ,[nearest_metro_ar]
      ,[nearest_metro_en]
      ,[nearest_mall_ar]
      ,[nearest_mall_en]
      ,[rooms_ar]
      ,[rooms_en]
      ,[has_parking]
      ,[procedure_area]
      ,[actual_worth]
      ,[meter_sale_price]
      ,[rent_value]
      ,[meter_rent_price]
      ,[no_of_parties_role_1]
      ,[no_of_parties_role_2]
      ,[no_of_parties_role_3]
  FROM [DXB_RealEstate].[dbo].[Transactions]

  SELECT * FROM Transactions

 --*****-------1048575 NO. OF ROWS---------------------------------------------------------------------------------------******
   SELECT COUNT(*) FROM Transactions


SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions';




--1. Checking for nulls 
 SELECT has_parking FROM Transactions
 WHERE has_parking IS NULL OR procedure_id= 'null'

 SELECT has_parking FROM Transactions
 WHERE has_parking IS NULL

 SELECT no_of_parties_role_1 FROM Transactions
 WHERE no_of_parties_role_1 = 'null'

 SELECT * FROM Transactions


 --2. updating nulls and blanks with 0s and 'NA/unknown'

 --nulls: 1. property_sub_type_id, 2. project_number,  3. rent_value, 4.meter_rent_price, 5.no_of_parties_role_1, 6. no_of_parties_role_2, 7.no_of_parties_role_3

 SELECT procedure_id FROM Transactions
 WHERE project_number = 'null'
 ORDER BY procedure_id DESC

 DROP TABLE Transactions

 SELECT * FROM Transactions
 ----------------------------------AGENDA--------------------------------------
 --Save a backup
--change the name of the table
--DELETE THE ARAB RECORDS
--Get the nulls done away with 
--Change the data type
--Data Cleaning
--Understand the data
-- Data Transformation


------------------------*--------STARTING-------*----------------------------


  --Saving a backup of the file (Transactions --> DXB_Prop_Backup)
 SELECT * INTO DXB_Prop_Backup
 FROM Transactions

 
 DROP TABLE DXB_Prop_Backup

 --Counting No, of Columns
 SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions';

ALTER TABLE Transactions
DROP COLUMN 
    trans_group_ar,
    procedure_name_ar,
    property_type_ar,
    property_sub_type_ar,
    property_usage_ar,
    reg_type_ar,
    area_name_ar,
    building_name_ar,
    project_name_ar,
    master_project_ar,
    nearest_landmark_ar,
    nearest_metro_ar,
    nearest_mall_ar,
    rooms_ar;

SELECT * FROM Transactions

SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions';

------------------------*-------1. COUNTERING NULLS and BLANKS

SELECT property_sub_type_id
FROM Transactions
WHERE property_sub_type_id= 'null';

SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions';

SELECT * FROM Transactions 
WHERE meter_rent_price = 0

UPDATE Transactions
SET meter_rent_price =0 WHERE meter_rent_price IS NULL OR meter_rent_price = '' OR  meter_rent_price = 'null';

--done
--NULL UPDATED
--CHANGE DATA TYPE

SELECT *
FROM Transactions 
WHERE rooms_en = 'unknown'


UPDATE Transactions
SET rooms_en = 'unknown'
WHERE rooms_en IS NULL OR rooms_en = '' OR rooms_en = 'null';


SELECT TOP 10 * FROM DXB_Prop_Backup


----------Adding a table_New
SELECT * INTO Transaction_bk
 FROM Transaction_backup


 --Working on Transaction_bk
 --CREATED BACKUP TAKING PRECATUTIONS

 SELECT *
 FROM Transaction_bk


 --dROPPING TABLE Transactions
DROP TABLE Transactions


 --Updating values
 UPDATE Transaction_bk
 SET property_type_id_real = 
 CASE WHEN property_type_id = 'null' THEN NULL ELSE 
 TRY_CAST(property_type_id AS INT) END;

ALTER TABLE Transaction_bk
ALTER COLUMN no_of_parties_role_3 INT;

ALTER TABLE Transaction_bk
ALTER COLUMN meter_rent_price FLOAT NOT NULL;

ALTER TABLE Transaction_bk
ALTER COLUMN no_of_parties_role_2 INT;

 ALTER TABLE Transaction_bk
 DROP COLUMN property_type_id_real 


--test
SELECT * FROM Transaction_bk

SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transaction_bk';


--Dropping Column_property_sub_type_id
 ALTER TABLE Transactions DROP COLUMN property_sub_type_id;

 UPDATE Transaction_bk
 SET instance_date = TRY_CONVERT(DATE, instance_date, 105);

 ALTER TABLE Transaction_bk
 ALTER COLUMN instance_date DATE;


 --Chnaging the names of the columns
EXEC sp_rename 'dbo.Transaction_bk.reg_type_en', 'reg_type', 'column';
EXEC sp_rename 'dbo.Transaction_bk.[procedure]', 'procedure', 'column';


--Backup next stage_clean
SELECT * INTO Transaction_clean
 FROM Transaction_bk

ALTER TABLE Transaction_bk
ALTER COLUMN project NVARCHAR(200);

ALTER TABLE Transaction_bk
ALTER COLUMN [procedure] NVARCHAR(200);

SELECT *
FROM Transaction_bk

SELECT *
FROM Transaction_bk
WHERE procedure_id = 102

SELECT COUNT(distinct project)
FROM Transaction_bk
WHERE master_project='Dubai Marina' 

SELECT distinct project, nearest_landmark, nearest_mall, nearest_metro
FROM Transaction_bk

SELECT COUNT(*)
FROM (select project_num,project, master_project, building_name, nearest_landmark, nearest_mall, nearest_metro FROM Transaction_bk)
AS T

select project_num,project, master_project, building_name, nearest_landmark, nearest_mall, nearest_metro FROM Transaction_bk

	  
----------------*----CHECKING IF THERE IS ANY RELATIONSHIOP BETWEEN building_name with nearest_landmark, nearest_mall, AND nearest_metro
--

SELECT nearest_mall, COUNT(DISTINCT nearest_metro)
FROM Transaction_bk
GROUP BY nearest_mall
HAVING COUNT(DISTINCT nearest_metro) > 1;

--Checking if there is association of nearest_landmark with nearest_mall, nearest_metro

SELECT nearest_mall, COUNT(DISTINCT project_num)
FROM Transaction_bk
GROUP BY nearest_mall
HAVING COUNT(DISTINCT project_num)>1

--Checking if there is association of project_num with project, master_project

SELECT master_project, COUNT(DISTINCT project_num)
FROM Transaction_bk
GROUP BY master_project
HAVING COUNT(DISTINCT project_num)>1

SELECT * FROM Transaction_bk

EXEC sp_rename 'dbo.Transaction_bk.[procedure]', 'procedure_type', 'COLUMN';

SELECT DISTINCT trans_group, trans_group_id
FROM Transaction_bk

DROP TABLE Transaction_clean

------------------------*-------2. CREATING THE DIMENSION TABLES

--dIM_Transaction
CREATE 
TABLE Dim_Transaction(
trans_group_id INT PRIMARY KEY,
trans_group NVARCHAR(50) UNIQUE);

INSERT INTO Dim_Transaction(trans_group_id, trans_group)
SELECT DISTINCT trans_group_id, trans_group
FROM Transaction_bk

--dIM_Procedure
CREATE 
TABLE Dim_Procedure(
procedure_id INT PRIMARY KEY,
procedure_type NVARCHAR(200) UNIQUE);

INSERT INTO Dim_Procedure(procedure_id, procedure_type)
SELECT DISTINCT procedure_id, procedure_type
FROM Transaction_bk


SELECT * FROM  Dim_Procedure
ORDER BY procedure_id

SELECT COUNT(DISTINCT procedure_id)
FROM Transaction_bk

SELECT * FROM Transaction_bk
ORDER BY procedure_id ASC

--dIM_Property_type
CREATE 
TABLE Dim_Property_type(
property_type_id INT PRIMARY KEY,
property_type NVARCHAR(100));


INSERT INTO Dim_Property_type(property_type_id,property_type)
SELECT DISTINCT property_type_id,property_type
FROM Transaction_bk

--Dim_Property_Sub
CREATE 
TABLE Dim_Property_Sub(
property_sub_type_id INT PRIMARY KEY,
property_sub_type NVARCHAR(200));

insert into Dim_Property_Sub(property_sub_type_id,property_sub_type)
SELECT DISTINCT property_sub_type_id ,property_sub_type
FROM Transaction_bk

--Dim_Registration
CREATE 
TABLE Dim_Reg(
reg_type_id INT PRIMARY KEY,
reg_type NVARCHAR(50));

insert into Dim_Reg(reg_type_id,reg_type)
SELECT DISTINCT reg_type_id ,reg_type
FROM Transaction_bk

SELECT * FROM Dim_Reg
DROP TABLE Dim_Reg

--Dim_Project
CREATE 
TABLE Dim_Project(
project_num INT PRIMARY KEY,
project NVARCHAR(200));

insert into Dim_Project(project_num,project)
SELECT DISTINCT project_num ,project
FROM Transaction_bk

--Dim_Area
CREATE 
TABLE Dim_Area(
area_id INT PRIMARY KEY,
area_name NVARCHAR(200));

insert into Dim_Area(area_id,area_name)
SELECT DISTINCT area_id,area_name
FROM Transaction_bk

--Dim_Master_Proj
CREATE 
TABLE Dim_Master_Proj(
master_project_id INT IDENTITY PRIMARY KEY,
master_project NVARCHAR(200));

insert into Dim_Master_Proj(master_project)
SELECT DISTINCT master_project
FROM Transaction_bk

SELECT * FROM Dim_building
WHERE master_project ='unknown'

--Dim_building
CREATE 
TABLE Dim_building(
building_id INT IDENTITY PRIMARY KEY,
building_name NVARCHAR(200));

insert into Dim_building(building_name)
SELECT DISTINCT building_name
FROM Transaction_bk


--Dim_metro
CREATE 
TABLE Dim_metro(
metro_id INT IDENTITY PRIMARY KEY,
nearest_metro NVARCHAR(200));

insert into Dim_metro(nearest_metro)
SELECT DISTINCT nearest_metro
FROM Transaction_bk

--Dim_mall
CREATE 
TABLE Dim_mall(
mall_id INT IDENTITY PRIMARY KEY,
nearest_mall NVARCHAR(500));

insert into Dim_mall(nearest_mall)
SELECT DISTINCT nearest_mall
FROM Transaction_bk

--Dim_landmark
CREATE 
TABLE Dim_landmark(
landmark_id INT IDENTITY PRIMARY KEY,
nearest_landmark NVARCHAR(500));

insert into Dim_landmark(nearest_landmark)
SELECT DISTINCT nearest_landmark
FROM Transaction_bk

--Dim_room
CREATE 
TABLE Dim_room(
room_type_id INT IDENTITY PRIMARY KEY,
room NVARCHAR(50));

insert into Dim_room(room)
SELECT DISTINCT rooms
FROM Transaction_bk


--Dim_Property_usage
CREATE
TABLE Dim_property_usage(
property_usage_id INT IDENTITY PRIMARY KEY,
property_usage NVARCHAR(100));

INSERT INTO Dim_property_usage(property_usage)
SELECT DISTINCT property_usage 
FROM Transaction_bk

SELECT * FROM Dim_property_usage


--DIM_DATE----------------------------FOR TIME ANALYSIS------------------------------
CREATE 
TABLE Dim_date(
date_key INT IDENTITY PRIMARY KEY,
instance_date DATE);

insert into Dim_date(instance_date)
SELECT DISTINCT date
FROM Transaction_bk

--changing column name in Dim_date
EXEC sp_rename 'Dim_date.instance_date', 'date', 'COLUMN';

--adding elements in Dim_date making it analytics ready
ALTER TABLE Dim_date ADD 
year INT,
month INT,
day INT,
quarter INT,
day_of_week INT;


--Dropping a column
ALTER TABLE Dim_date
DROP COLUMN day_of_week

--Adding a column
ALTER TABLE Dim_date 
ADD 
day_name NVARCHAR(20),
month_name NVARCHAR(20);

--adding other date analytics elements
UPDATE Dim_date
SET
year = YEAR(DATE),
month = MONTH(DATE),
day = DAY(DATE);

UPDATE Dim_date
SET
day_name = DATENAME(WEEKDAY, DATE),
month_name = DATENAME(MONTH, DATE);

update Dim_date
SET
quarter=DATEPART(QUARTER, DATE)

SELECT COUNT(*) FROM Dim_date



--Testing...................
SELECT * FROM Dim_Project
--1
SELECT project_num FROM Dim_Project
WHERE project IN ('CENTRIUM TOWER', 'OBEROI CENTRE', 'SCALA TOWER') 

--2
SELECT project FROM Dim_Project
WHERE project_num = -1

SELECT project_num FROM Dim_Project
where project = 'SCALA TOWER'


------------------------*-------3. FACT TABLE DESIGNING


CREATE TABLE Fact_dubai(
transaction_id NVARCHAR(100),
procedure_id INT,
trans_group_id INT,
date_key INT,
property_type_id INT,
property_sub_type_id INT,
property_usage_id INT,
reg_type_id INT,
area_id INT,
master_project_id INT,
project_num INT,
building_id INT,
landmark_id INT,
metro_id INT,
mall_id INT,
room_type_id INT,
has_parking INT,
procedure_area float,
actual_worth float,
meter_sale_price float,
rent_value float,
meter_rent_price float,
no_of_parties_role_1 INT,
no_of_parties_role_2 INT,
no_of_parties_role_3 INT,

    FOREIGN KEY (procedure_id) REFERENCES Dim_procedure(procedure_id),
	FOREIGN KEY (trans_group_id) REFERENCES Dim_transaction_details(trans_group_id),
    FOREIGN KEY (date_key) REFERENCES Dim_date(date_key),
    FOREIGN KEY (property_type_id) REFERENCES Dim_property_type(property_type_id),
    FOREIGN KEY (property_sub_type_id) REFERENCES Dim_property_sub(property_sub_type_id),
    FOREIGN KEY (property_usage_id) REFERENCES Dim_property_usage(property_usage_id),
	FOREIGN KEY (reg_type_id) REFERENCES Dim_reg(reg_type_id),
    FOREIGN KEY (area_id) REFERENCES Dim_area(area_id),
	    FOREIGN KEY (master_project_id) REFERENCES Dim_master_proj(master_project_id),
    FOREIGN KEY (project_num) REFERENCES Dim_project(project_num),
	FOREIGN KEY (building_id) REFERENCES Dim_building(building_id),
    FOREIGN KEY (landmark_id) REFERENCES Dim_landmark(landmark_id),
    FOREIGN KEY (metro_id) REFERENCES Dim_metro(metro_id),
    FOREIGN KEY (mall_id) REFERENCES Dim_mall(mall_id),
    FOREIGN KEY (room_type_id) REFERENCES Dim_room(room_type_id)
	);

		SELECT * FROM Fact_dubai


	---ADDING VALUES TO FACT_TABLE
	INSERT INTO Fact_dubai(transaction_id, procedure_id, trans_group_id, date_key, property_type_id, property_sub_type_id,
	property_usage_id, reg_type_id, area_id, master_project_id, project_num, building_id,landmark_id, metro_id, mall_id,
	room_type_id, has_parking, procedure_area, actual_worth, meter_sale_price, rent_value, meter_rent_price,
	no_of_parties_role_1, no_of_parties_role_2, no_of_parties_role_3
	)

	SELECT
	Main.transaction_id, 
	Pro.procedure_id, 
	Trans.trans_group_id, 
	Date.date_key, 
	Type.property_type_id, 
	Sub.property_sub_type_id,
	Usage.property_usage_id, 
	Reg.reg_type_id, 
	Area.area_id, 
	Master.master_project_id, 
	Project.project_num,
	Build.building_id, 
	Landmark.landmark_id, 
	Metro.metro_id,
	Mall.mall_id,
	Room.room_type_id, 
	Main.has_parking, Main.procedure_area, Main.actual_worth, Main.meter_sale_price, Main.rent_value, Main.meter_rent_price,
	Main.no_of_parties_role_1, Main.no_of_parties_role_2, Main.no_of_parties_role_3

	FROM Transaction_bk Main
	JOIN Dim_area Area ON Main.area_id=Area.area_id
	JOIN Dim_building Build ON Main.building_name= Build.building_name
	JOIN Dim_date Date ON Main.date= Date.date
	JOIN Dim_landmark Landmark ON Main.nearest_landmark=Landmark.nearest_landmark
	JOIN Dim_mall Mall ON Main.nearest_mall= Mall.nearest_mall
	JOIN Dim_metro Metro ON Main.nearest_metro= Metro.nearest_metro
	JOIN Dim_master_proj Master ON Main.master_project= Master.master_project
	JOIN Dim_procedure Pro ON Main.procedure_id= Pro.procedure_id
	JOIN Dim_project Project ON Main.project_num=Project.project_num
	JOIN Dim_property_Sub Sub ON Main.property_sub_type_id=Sub.property_sub_type_id
	JOIN Dim_property_type Type ON Main.property_type_id=Type.property_type_id
	JOIN Dim_property_usage Usage ON Main.property_usage=Usage.property_usage
	JOIN Dim_reg Reg ON Main.reg_type_id= Reg.reg_type_id
	JOIN Dim_room Room ON Main.rooms=Room.room
	JOIN Dim_transaction_details Trans ON Main.trans_group_id=Trans.trans_group_id;


	SELECT * FROM Dim_transaction_details

	SELECT COUNT(*) AS NumberOfColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Fact.dubai'

	--TESTING
	SELECT * FROM Fact_dubai
	SELECT * FROM Transaction_bk


	------------------------*-------4. --CREATING INDEXES


CREATE INDEX Idx_fact_dubai_procedure ON Fact_dubai (procedure_id)
CREATE INDEX Idx_fact_dubai_trans_group ON Fact_dubai (trans_group_id)
CREATE INDEX Idx_fact_property_type ON Fact_dubai (property_type_id)
CREATE INDEX Idx_fact_property_sub ON Fact_dubai (property_sub_type_id)
CREATE INDEX Idx_fact_property_usage ON Fact_dubai (property_usage_id)
CREATE INDEX Idx_fact_reg_type ON Fact_dubai (reg_type_id)
CREATE INDEX Idx_fact_area ON Fact_dubai (area_id)
CREATE INDEX Idx_fact_master_proj ON Fact_dubai (master_project_id)
CREATE INDEX Idx_fact_project ON Fact_dubai (project_num)
CREATE INDEX Idx_fact_date ON Fact_dubai (date_key)
CREATE INDEX Idx_fact_building ON Fact_dubai (building_id)
CREATE INDEX Idx_fact_landmark ON Fact_dubai (landmark_id)
CREATE INDEX Idx_fact_metro ON Fact_dubai (metro_id)
CREATE INDEX Idx_fact_mall ON Fact_dubai (mall_id)
CREATE INDEX Idx_fact_room ON Fact_dubai (room_type_id)

SELECT COUNT(*) AS Columncount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Fact_dubai'

--Checking for duplicates within transaction_id
WITH CTE AS ( SELECT *, ROW_NUMBER() OVER(PARTITION BY Transaction_id ORDER BY Transaction_id) AS row_num
				FROM Fact_dubai) 
SELECT transaction_id 
FROM CTE
WHERE row_num>1



	------------------------*-------4. --CREATING VIEWS
	CREATE VIEW vw_Dubai_Real_Estate AS 
	SELECT 
	F.transaction_id, 
	Pro.procedure_id,
	Pro.procedure_type,
	Trans.trans_group_id,
	Trans.trans_group,
	Date.date_key, 
	Date.date,
	Date.day,
	Date.day_name,
	Date.month,
	Date.month_name,
	Date.quarter,
	Date.year,
	Type.property_type_id, 
	Type.property_type,
	Sub.property_sub_type_id,
	Sub.property_sub_type,
	Usage.property_usage,
	Usage.property_usage_id, 
	Reg.reg_type,
	Reg.reg_type_id, 
	Area.area_id, 
	Area.area_name,
	Master.master_project_id, 
	Master.master_project,
	Project.project_num,
	Project.project,
	Build.building_id, 
	Build.building_name,
	Landmark.landmark_id, 
	Landmark.nearest_landmark,
	Metro.metro_id,
	Metro.nearest_metro,
	Mall.mall_id,
	Mall.nearest_mall,
	Room.room_type_id, 
	Room.room,
	F.has_parking, 
	F.procedure_area, 
	F.actual_worth, 
	F.meter_sale_price, 
	F.rent_value, 
	F.meter_rent_price,
	F.no_of_parties_role_1, 
	F.no_of_parties_role_2, 
	F.no_of_parties_role_3

	FROM Fact_dubai F
    JOIN Dim_area Area ON F.area_id=Area.area_id
	JOIN Dim_building Build ON F.building_id= Build.building_id
	JOIN Dim_date Date ON F.date_key= Date.date_key
	JOIN Dim_landmark Landmark ON F.landmark_id=Landmark.landmark_id
	JOIN Dim_mall Mall ON F.mall_id= Mall.mall_id
	JOIN Dim_metro Metro ON F.metro_id= Metro.metro_id
	JOIN Dim_master_proj Master ON F.master_project_id= Master.master_project_id
	JOIN Dim_procedure Pro ON F.procedure_id= Pro.procedure_id
	JOIN Dim_project Project ON F.project_num=Project.project_num
	JOIN Dim_property_Sub Sub ON F.property_sub_type_id=Sub.property_sub_type_id
	JOIN Dim_property_type Type ON F.property_type_id=Type.property_type_id
	JOIN Dim_property_usage Usage ON F.property_usage_id=Usage.property_usage_id
	JOIN Dim_reg Reg ON F.reg_type_id= Reg.reg_type_id
	JOIN Dim_room Room ON F.room_type_id=Room.room_type_id
	JOIN Dim_transaction_details Trans ON F.trans_group_id=Trans.trans_group_id;

	SELECT TOP 10 * FROM vw_Dubai_Real_Estate