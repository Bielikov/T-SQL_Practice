--Homework
CREATE DATABASE Store
COLLATE Cyrillic_General_CI_AS

--ѕереход в новую базу с master базы
USE Store

-- ”даление базы
DROP DATABASE Store

--—оздание таблицы
create table Categories(
CategoryId int not null identity(0,1),
CategoryName nvarchar(20),
[Description] nvarchar(200))

INSERT Categories
(CategoryName, [Description])
VALUES 
('Beverages','Soft drinks, coffees, teas, beers, and ales'),
('Condiments','Sweet and savory sauces, relishes, spreads, and seasonings'),
('Confections','Desserts, candies, and sweet breads')

INSERT Categories
(CategoryName, [Description])
select Northwind.dbo.Categories.CategoryName, Northwind.dbo.Categories.[Description]
from Northwind.dbo.Categories
where Northwind.dbo.Categories.CategoryID > 3

select * from Categories

update Categories
set CategoryName = 'Condiments'
output inserted.CategoryName as newdata, deleted.CategoryName as old
where Categories.CategoryId = 1

delete Categories
where CategoryId = 1

select * from Categories

--ќбъ€вил и инициализировал два параметра
declare @par1 nvarchar(10) = 'Hello'
declare @par2 nvarchar(10) = ' world!'

select @par1 + @par2
