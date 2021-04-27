/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson II  ******              DDL            ************************
****************************************************************************/
--DDL
----DATABASE
CREATE DATABASE ITVDNdb  -- создание базы данных с параметрами по-умолчанию

ALTER DATABASE ITVDNdb            
COLLATE Cyrillic_General_CI_AS	-- параметры сортировки для базы данных по умолчанию
/*
CaseSensitivity
CI определяет нечувствительность к регистру, CS определяет чувствительность к регистру.

AccentSensitivity
AI означает, что диакритические знаки игнорируются, AS означает, что они учитываются.
*/


DROP DATABASE ITVDNdb

----TABLE
CREATE DATABASE ITVDNdb
COLLATE Cyrillic_General_CI_AS

USE ITVDNdb

---- CTRL + K, X  - snippets
CREATE TABLE Students
(
    Id int NOT NULL IDENTITY,
    FName nvarchar(20),
	LName nvarchar(20),
	Phone char(12),
	EMail varchar(20),
);

ALTER TABLE Students
ALTER COLUMN LName nvarchar(30) NOT NULL

ALTER TABLE Students
ADD MName nvarchar(30) -- NOT NULL

ALTER TABLE Students
DROP COLUMN MName

DROP TABLE Students

--DML
----INSERT #1
INSERT INTO Students 
--(FName, LName, Phone, EMail)
	VALUES
		(N'Александр', N'Македонский', '(012)3456789', 'alex@imperium.com'),
		(N'Диоген', N'Синопский', NULL, 'sinop@pithos.com')

		
-- даем разрешение на добавление/изменение IDENTITY значения
SET IDENTITY_INSERT Students ON

INSERT INTO Students 
(Id, FName, LName, Phone, EMail)
	VALUES
		(3, NULL, N'Семирамида', '(012)3456788', 'assyria@imperium.com')
		
-- запрещаем добавление/изменение IDENTITY значения
SET IDENTITY_INSERT Students OFF

----SELECT
SELECT * FROM Students

SELECT LName, EMail FROM Students

SELECT LName, EMail FROM Students
	WHERE Id = 1
	
----INSERT #2
CREATE TABLE StudentPhones
(
    Id int,
	LastName nvarchar(20),
	PhoneNumber char(12)
);

INSERT StudentPhones
	SELECT Id, LName, Phone FROM Students

SELECT * FROM StudentPhones
----UPDATE
--#1
UPDATE Students
	SET Phone = NULL
	--WHERE Id = 1
--#2
UPDATE Students
	SET Phone = sp.PhoneNumber
	FROM Students s 
	JOIN StudentPhones sp ON s.Id = sp.Id

----DELETE
DELETE Students
	--WHERE Id = 1

----TRUNCATE (DDL)
/*Инструкция TRUNCATE TABLE является более быстрой версией инструкции DELETE без предложения WHERE. 
Эта инструкция удаляет все строки таблицы более быстро, чем инструкция DELETE, поскольку она удаляет 
содержимое постранично, тогда как инструкция DELETE делает это построчно. Инструкция TRUNCATE TABLE 
является расширением Transact-SQL стандарта SQL. Еще одним важным отличием этой инструкции является то, 
что она сбрасывает индекс столбца, для которого указано свойство автоинкремента IDENTITY.
*/

TRUNCATE TABLE Students
TRUNCATE TABLE StudentPhones

----OUTPUT
/*Предложение OUTPUT дает возможность получить информацию по строкам, которые были добавлены, удалены 
или изменены в результате выполнения DML команд INSERT, DELETE, UPDATE и MERGE. Результаты выполненных 
операций соответствующих инструкций предложение OUTPUT выводит в таблицах inserted и deleted.
*/
INSERT Students (FName, LName, Phone, EMail)
OUTPUT inserted.*
	VALUES
		(N'Александр', N'Македонский', '(012)3456789', 'alex@imperium.com'),
		(N'Диоген', N'Синопский', NULL, 'sinop@pithos.com'),
		(NULL, N'Семирамида', '(012)3456788', 'assyria@imperium.com')

DELETE Students
OUTPUT deleted.Id, deleted.LName
	WHERE Id = 1
	
UPDATE Students
	SET Phone = '(012)3456789'
	OUTPUT inserted.Id, inserted.LName, inserted.Phone AS [Новый телефон], deleted.Phone "Старый телефон"
	WHERE Id = 2
	
DELETE Students
OUTPUT deleted.Id, deleted.LName, deleted.Phone INTO StudentPhones

-- table variable
DECLARE @deleteTable table (Id int, LastName nvarchar(20));	

DELETE Students
OUTPUT deleted.Id, deleted.LName INTO @deleteTable

SELECT * FROM @deleteTable