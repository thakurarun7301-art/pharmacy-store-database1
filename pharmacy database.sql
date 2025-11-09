use pharmacysql;
--  Create Tables for Medical Shop Billing System
-- 1️ Medicine Table
CREATE TABLE Medicine (
    Med_ID INT PRIMARY KEY,
    Med_Name VARCHAR(50),
    Company VARCHAR(50),
    Price DECIMAL(10,2),
    Quantity INT,
    Expiry_Date DATE
);
-- 2️ Customer Table
CREATE TABLE Customer (
    Cust_ID INT PRIMARY KEY,
    Cust_Name VARCHAR(50),
    Phone VARCHAR(15),
    Address VARCHAR(100)
);
-- 3️ Supplier Table
CREATE TABLE Supplier (
    Sup_ID INT PRIMARY KEY,
    Sup_Name VARCHAR(50),
    Phone VARCHAR(15),
    City VARCHAR(50)
);
-- 4️ Bill Table
CREATE TABLE Bill (
    Bill_ID INT PRIMARY KEY,
    Cust_ID INT,
    Bill_Date DATE,
    Total_Amount DECIMAL(10,2),
    FOREIGN KEY (Cust_ID) REFERENCES Customer(Cust_ID)
);
-- 5️ Bill_Details Table
CREATE TABLE Bill_Details (
    Bill_ID INT,
    Med_ID INT,
    Quantity INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (Bill_ID) REFERENCES Bill(Bill_ID),
    FOREIGN KEY (Med_ID) REFERENCES Medicine(Med_ID)
);
-- 6️ Purchase Table
CREATE TABLE Purchase (
    Purchase_ID INT PRIMARY KEY,
    Sup_ID INT,
    Med_ID INT,
    Quantity INT,
    Purchase_Date DATE,
    FOREIGN KEY (Sup_ID) REFERENCES Supplier(Sup_ID),
    FOREIGN KEY (Med_ID) REFERENCES Medicine(Med_ID)
);
--  Insert Sample Data into Medicine Table
INSERT INTO Medicine VALUES
(1, 'Paracetamol', 'Cipla', 25.00, 100, '2026-05-10'),
(2, 'Amoxicillin', 'Sun Pharma', 50.00, 80, '2025-11-30'),
(3, 'Cetirizine', 'Dr Reddy', 15.00, 150, '2027-03-12'),
(4, 'Azithromycin', 'Zydus', 70.00, 60, '2026-01-20'),
(5, 'Pantoprazole', 'Cipla', 40.00, 90, '2026-09-14');
--  Insert Data into Customer Table
INSERT INTO Customer VALUES
(101, 'Rahul Sharma', '9876543210', 'Delhi'),
(102, 'Sneha Verma', '9123456780', 'Mumbai'),
(103, 'Amit Kumar', '9898989898', 'Chennai');
--  Insert Data into Supplier Table
INSERT INTO Supplier VALUES
(201, 'MediSupply Co', '9999988888', 'Delhi'),
(202, 'HealthCorp Pvt', '9999977777', 'Pune');
--  Insert Data into Bill Table
INSERT INTO Bill VALUES
(301, 101, '2025-10-01', 115.00),
(302, 102, '2025-10-02', 140.00),
(303, 103, '2025-10-05', 70.00);
--  Insert Data into Bill_Details Table
INSERT INTO Bill_Details VALUES
(301, 1, 2, 50.00),
(301, 3, 3, 45.00),
(302, 2, 2, 100.00),
(302, 5, 1, 40.00),
(303, 4, 1, 70.00);
--  Insert Data into Purchase Table
INSERT INTO Purchase VALUES
(401, 201, 1, 200, '2025-09-15'),
(402, 201, 3, 300, '2025-09-20'),
(403, 202, 4, 150, '2025-09-25');
--  ===========================
--  QUERIES USED IN THE PROJECT
-- ===========================

-- 🔹 1️View all medicines
SELECT * FROM Medicine;

-- 🔹 2️ Show medicines of a specific company (Cipla)
SELECT Med_Name, Price, Quantity
FROM Medicine
WHERE Company = 'Cipla';

-- 🔹 3️ Show customers from a specific city (Mumbai)
SELECT *
FROM Customer
WHERE Address = 'Mumbai';

-- 🔹 4️ Display all bills with customer names
SELECT B.Bill_ID, C.Cust_Name, B.Bill_Date, B.Total_Amount
FROM Bill B
JOIN Customer C ON B.Cust_ID = C.Cust_ID;

-- 🔹 5️ View medicine details of a specific bill (Bill_ID = 301)
SELECT M.Med_Name, BD.Quantity, BD.Amount
FROM Bill_Details BD
JOIN Medicine M ON BD.Med_ID = M.Med_ID
WHERE BD.Bill_ID = 301;

-- 🔹 6️ Count total number of medicines in stock
SELECT SUM(Quantity) AS Total_Medicines
FROM Medicine;

-- 🔹 7️ Find medicines that expire before 2026-12-31
SELECT Med_Name, Expiry_Date
FROM Medicine
WHERE Expiry_Date < '2026-12-31';

-- 🔹 8️ Update stock after a sale (reduce quantity by 2 for Med_ID = 1)
UPDATE Medicine
SET Quantity = Quantity - 2
WHERE Med_ID = 1;

-- 🔹 9️ Calculate total sales revenue
SELECT SUM(Total_Amount) AS Total_Sales
FROM Bill;

-- 🔹 10 Find the best-selling medicine
SELECT M.Med_Name, SUM(BD.Quantity) AS Total_Sold
FROM Bill_Details BD
JOIN Medicine M ON BD.Med_ID = M.Med_ID
GROUP BY M.Med_Name
ORDER BY Total_Sold DESC
LIMIT 1;

-- 🔹 11️ Show total quantity purchased from each supplier
SELECT S.Sup_Name, SUM(P.Quantity) AS Total_Purchased
FROM Purchase P
JOIN Supplier S ON P.Sup_ID = S.Sup_ID
GROUP BY S.Sup_Name;

-- 🔹 12️ List medicines with low stock (less than 50 units)
SELECT Med_Name, Quantity
FROM Medicine
WHERE Quantity < 50;

-- 🔹 13️ Calculate average price of all medicines
SELECT AVG(Price) AS Average_Price
FROM Medicine;

-- 🔹 14️ Find the top customer (who spent the most)
SELECT C.Cust_Name, SUM(B.Total_Amount) AS Total_Spent
FROM Customer C
JOIN Bill B ON C.Cust_ID = B.Cust_ID
GROUP BY C.Cust_Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 🔹 15️ Show suppliers located in Delhi
SELECT *
FROM Supplier
WHERE City = 'Delhi';
