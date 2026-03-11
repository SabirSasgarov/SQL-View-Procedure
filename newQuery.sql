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
	[Date] DATETIME
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
(1,1,'2026-02-13 12:23:00'),
(2,1,'2026-02-14 13:45:00'),
(4,1,'2026-02-11 14:30:00'),
(1,2,'2026-02-15 12:50:00'),
(2,2,'2026-01-13 10:50:00'),
(3,3,'2026-02-13 12:10:20'),
(5,4,'2026-02-14 17:30:00'),
(4,5,'2026-02-16 20:12:00'),
(4,5,GETDATE())



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
SELECT *, (SELECT SUM(m.Price) FROM Orders o JOIN Meals m ON o.MealID = m.id WHERE o.TableID = t.id) AS TotalAmount FROM [Tables] t

SELECT o.TableID, t.No ,SUM(m.Price) FROM Orders o
JOIN Meals m ON o.MealID = m.id
JOIN [Tables] t ON t.id = o.TableID
GROUP BY o.TableID, t.No

--query6
--1-idli masaya verilmis ilk sifarişlə son sifariş arasında neçə saat fərq olduğunu select edən query
SELECT MIN(o.Date),MAX(o.Date) FROM Orders o
WHERE o.TableID = 1

SELECT DATEDIFF(HOUR,MIN(o.Date),MAX(o.Date)) FROM Orders o
WHERE o.TableID = 1

--query7
--ən son 30-dəqədən əvvəl verilmiş sifarişləri select edən query
SELECT * FROM Orders o
WHERE o.[Date] < DATEADD(MINUTE,-30,GETDATE())

--query8
--heç sifariş verməmiş masaları select edən query
SELECT * FROM [Tables] t
WHERE NOT EXISTS (SELECT * FROM Orders o WHERE o.TableID = t.id)

--query9
--son 60 dəqiqədə heç sifariş verməmiş masaları select edən query
SELECT * FROM [Tables] t
WHERE NOT EXISTS (SELECT * FROM Orders o WHERE o.TableID = t.id AND o.[Date] >= DATEADD(MINUTE,-60,GETDATE()))

SELECT t.[No] FROM Orders o
JOIN [Tables] t ON o.TableID = t.id
WHERE o.TableID = t.id AND o.[Date] >= DATEADD(MINUTE,-60,GETDATE())