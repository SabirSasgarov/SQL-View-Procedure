CREATE DATABASE Restourant
USE Restourant

CREATE TABLE [Tables]
(
	id INT PRIMARY KEY IDENTITY,
	[No] NVARCHAR(10)
)

CREATE TABLE Meals
(
	id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	Price DECIMAL(18,2)
)

CREATE TABLE Orders
(
	id INT PRIMARY KEY IDENTITY,
	MealID INT FOREIGN KEY REFERENCES Meals(id),
	TableID INT FOREIGN KEY REFERENCES [Tables](id),
	[Date] DATE
)

INSERT INTO [Tables]
VALUES
('m1'),
('m2'),
('m3'),
('m4'),
('m5')

INSERT INTO Meals
VALUES
('dolma','3'),
('as qara','15'),
('sac(quzu)','26'),
('paytaxt salati','8'),
('sezar','12')

INSERT INTO Orders
VALUES
(1,1,'2026-02-13'),
(2,1,'2026-02-14'),
(4,1,'2026-02-11'),
(1,2,'2026-02-15'),
(2,2,'2026-01-13'),
(3,3,'2026-02-13'),
(5,4,'2026-02-14'),
(4,5,'2026-02-16')


--query1
SELECT t.id,t.[No], COUNT(o.id) AS countOfOrders FROM [Tables] t
LEFT JOIN Orders o ON o.TableID = t.id
GROUP BY t.id,t.[No]

SELECT * , (SELECT COUNT(*) FROM Orders o WHERE o.TableID = t.id) FROM [Tables] t

--query2
SELECT *,(SELECT COUNT(*) FROM Orders o WHERE o.MealID = m.id) FROM Meals m

--query3
SELECT *,(SELECT m.[Name] FROM Meals m WHERE o.MealID = m.id) FROM Orders o

--query4
SELECT *,(SELECT m.[Name] FROM Meals m WHERE o.MealID = m.id),(SELECT t.[No] FROM [Tables] t WHERE o.TableID = t.id) FROM Orders o

--query5
-- Bütün masa datalarını yanında o masının sifarişlərinin ümumi məbləği ilə select edən query 
SELECT *,(SELECT (SELECT SUM(Price) FROM Meals m WHERE o.MealID = m.id) FROM Orders o WHERE o.TableID = t.id) FROM [Tables] t





