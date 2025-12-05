-- Question 6 :  Create a database named ECommerceDB and perform the following tasks: 
-- 1. Create the following tables with appropriate data types and constraints: 
-- Create the database
CREATE DATABASE ECommerceDB;

-- Switch to the database
USE ECommerceDB;

-- 1. CREATE TABLE: Categories

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);


-- 2. CREATE TABLE: Products

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-----------------------------------------
-- 3. CREATE TABLE: Customers
-----------------------------------------
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);


-- 4. CREATE TABLE: Orders

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- 2. Insert the following records into each table 
INSERT INTO Categories (CategoryID, CategoryName)
VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity)
VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

INSERT INTO Customers (CustomerID, CustomerName, Email, JoinDate)
VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);

-- Question 7 : Generate a report showing CustomerName, Email, and the TotalNumberofOrders for each customer. Include customers who have not placed any orders, in which case their TotalNumberofOrders should be 0. Order the results  by CustomerName. 
SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberOfOrders
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.CustomerName, c.Email
ORDER BY 
    c.CustomerName;
    
    -- Question 8 :  Retrieve Product Information with Category: Write a SQL query to display the ProductName, Price, StockQuantity, and CategoryName for all products. Order the results by CategoryName and then ProductName alphabetically. 
SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM 
    Products p
INNER JOIN 
    Categories c
    ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName,
    p.ProductName;
    
    -- Question 9 : Write a SQL query that uses a Common Table Expression (CTE) and a Window Function (specifically ROW_NUMBER() or RANK()) to display the CategoryName, ProductName, and Price for the top 2 most expensive products in each CategoryName.
    WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName
            ORDER BY p.Price DESC
        ) AS rn
    FROM 
        Products p
    INNER JOIN 
        Categories c
        ON p.CategoryID = c.CategoryID
)

SELECT 
    CategoryName,
    ProductName,
    Price
FROM 
    RankedProducts
WHERE 
    rn <= 2
ORDER BY 
    CategoryName,
    Price DESC;
    
    -- Question 10 : You are hired as a data analyst by Sakila Video Rentals, a global movie rental company. The management team is looking to improve decision-making by analyzing existing customer, rental, and inventory data. Using the Sakila database,nswer he folowing business questions to support key strategic initiatives
-- 1. Identify the top 5 customers based on the total amount they've spent
CREATE DATABASE Sakila_Video_Rentals;
USE Sakila_Video_Rentals;

-- CUSTOMER TABLE
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- CATEGORY TABLE
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- FILM TABLE
CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(100),
    category_id INT,
    rental_rate DECIMAL(5,2),
    CONSTRAINT fk_cat FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- INVENTORY (FILM COPIES IN STORES)
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    film_id INT,
    store_id INT,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- RENTAL TABLE
CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    inventory_id INT,
    customer_id INT,
    rental_date DATE,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- PAYMENT TABLE
CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    rental_id INT,
    amount DECIMAL(5,2),
    payment_date DATE,
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);

INSERT INTO customer VALUES
(1, 'Alice', 'Wong', 'alice@example.com'),
(2, 'Bob', 'Smith', 'bob@example.com'),
(3, 'Charlie', 'Brown', 'charlie@example.com'),
(4, 'Diana', 'Prince', 'diana@example.com'),
(5, 'Evan', 'Lee', 'evan@example.com');
INSERT INTO category VALUES
(1, 'Action'),
(2, 'Comedy'),
(3, 'Drama');
INSERT INTO film VALUES
(101, 'Fast Cars', 1, 3.99),
(102, 'The Fighter', 1, 4.99),
(103, 'Laugh Out Loud', 2, 2.99),
(104, 'Comedy Nights', 2, 3.49),
(105, 'Life Story', 3, 4.49);
INSERT INTO inventory VALUES
(1, 101, 1),
(2, 102, 1),
(3, 103, 1),
(4, 104, 2),
(5, 105, 2),
(6, 101, 2);
INSERT INTO rental VALUES
(1, 1, 1, '2023-01-10'),
(2, 2, 1, '2023-02-15'),
(3, 3, 2, '2023-03-20'),
(4, 4, 3, '2023-04-12'),
(5, 5, 4, '2023-05-19'),
(6, 6, 1, '2023-05-25'),
(7, 2, 2, '2023-07-18');
INSERT INTO payment VALUES
(1, 1, 3.99, '2023-01-10'),
(2, 2, 4.99, '2023-02-15'),
(3, 3, 2.99, '2023-03-20'),
(4, 4, 3.49, '2023-04-12'),
(5, 5, 4.49, '2023-05-19'),
(6, 6, 3.99, '2023-05-25'),
(7, 7, 4.99, '2023-07-18');
INSERT INTO payment VALUES
(1, 1, 3.99, '2023-01-10'),
(2, 2, 4.99, '2023-02-15'),
(3, 3, 2.99, '2023-03-20'),
(4, 4, 3.49, '2023-04-12'),
(5, 5, 4.49, '2023-05-19'),
(6, 6, 3.99, '2023-05-25'),
(7, 7, 4.99, '2023-07-18');
INSERT INTO payment VALUES
(1, 1, 3.99, '2023-01-10'),
(2, 2, 4.99, '2023-02-15'),
(3, 3, 2.99, '2023-03-20'),
(4, 4, 3.49, '2023-04-12'),
(5, 5, 4.49, '2023-05-19'),
(6, 6, 3.99, '2023-05-25'),
(7, 7, 4.99, '2023-07-18');
-- 1.TOP 5 customers by total amount spent
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    SUM(p.amount) AS total_spent
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;
-- 2.Top 3 categories by rental count
SELECT 
    cat.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM category cat
JOIN film f ON cat.category_id = f.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY cat.category_id
ORDER BY rental_count DESC
LIMIT 3;
-- 3. Films available at each store & how many were never rented
SELECT 
    i.store_id,
    COUNT(i.inventory_id) AS total_films,
    SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS never_rented
FROM inventory i
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY i.store_id;
-- 4.Total revenue per month in 2023
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue
FROM payment
WHERE YEAR(payment_date) = 2023
GROUP BY month
ORDER BY month;
-- 5.Customers with more than 10 rentals in the last 6 months
-- assume today's date = '2023-12-31'.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB('2023-12-31', INTERVAL 6 MONTH)
GROUP BY c.customer_id
HAVING rental_count > 10;












