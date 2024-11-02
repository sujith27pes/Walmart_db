-- Disable foreign key checks to avoid dependency errors
SET FOREIGN_KEY_CHECKS = 0;

-- Drop and recreate Stores table
DROP TABLE IF EXISTS Stores;
CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    phone VARCHAR(15),
    opening_hours VARCHAR(100)
);

INSERT INTO Stores VALUES
(1, 'Walmart Supercenter #1001', '100 Retail Dr', 'Dallas', 'TX', '75201', '214-555-0101', '24/7'),
(2, 'Walmart Neighborhood Market #1002', '200 Grocery Ave', 'Fort Worth', 'TX', '76101', '817-555-0102', '6AM-12AM'),
(3, 'Walmart Supercenter #1003', '300 Main St', 'Austin', 'TX', '73301', '512-555-0103', '24/7'),
(4, 'Walmart Neighborhood Market #1004', '400 Elm St', 'Houston', 'TX', '77001', '713-555-0104', '6AM-12AM');

-- Drop and recreate Departments table
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    description TEXT,
    manager_id INT
);

INSERT INTO Departments VALUES
(1, 'Grocery', 'Food and household essentials', NULL),
(2, 'Electronics', 'TVs, phones, and gadgets', NULL),
(3, 'Apparel', 'Clothing and accessories', NULL),
(4, 'Home & Garden', 'Home improvement and outdoor', NULL),
(5, 'Pharmacy', 'Medications and health products', NULL);

-- Drop and recreate Employees table
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    dept_id INT,
    store_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10,2),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

INSERT INTO Employees VALUES
(1, 1, 1, 'Jane', 'Doe', 'Store Manager', '2018-06-15', 55000.00, '214-555-1234', 'jane.doe@walmart.com'),
(2, 2, 1, 'John', 'Smith', 'Electronics Associate', '2019-08-10', 35000.00, '214-555-5678', 'john.smith@walmart.com'),
(3, 3, 2, 'Alice', 'Johnson', 'Apparel Associate', '2020-05-20', 32000.00, '817-555-0102', 'alice.johnson@walmart.com'),
(4, 4, 3, 'Bob', 'Brown', 'Home & Garden Associate', '2021-09-01', 34000.00, '512-555-1234', 'bob.brown@walmart.com');

-- Drop and recreate Customers table
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    membership_status ENUM('Regular', 'Walmart+'),
    join_date DATE
);

INSERT INTO Customers VALUES
(1, 'Michael', 'Green', 'michael.green@gmail.com', '555-1234', '123 Maple St', 'Dallas', 'TX', '75201', 'Walmart+', '2023-01-15'),
(2, 'Sarah', 'Connor', 'sarah.connor@gmail.com', '555-5678', '456 Oak St', 'Fort Worth', 'TX', '76101', 'Regular', '2022-05-22'),
(3, 'David', 'Lee', 'david.lee@gmail.com', '555-8765', '789 Pine St', 'Austin', 'TX', '73301', 'Walmart+', '2023-02-12');

-- Drop and recreate Products table
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    dept_id INT,
    product_name VARCHAR(100),
    brand VARCHAR(100),
    description TEXT,
    retail_price DECIMAL(10,2),
    wholesale_price DECIMAL(10,2),
    walmart_plus_price DECIMAL(10,2),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Products VALUES
(1, 1, 'Great Value Milk', 'Great Value', 'Whole milk, 1 gallon', 3.48, 2.50, 3.33, 'Dairy', 'Milk'),
(2, 1, 'Coca-Cola', 'Coca-Cola', 'Soda, 12-pack', 4.98, 3.50, 4.25, 'Beverages', 'Soda'),
(3, 2, 'Samsung TV', 'Samsung', '55 inch 4K UHD Smart TV', 649.99, 500.00, 620.00, 'Electronics', 'TV'),
(4, 3, 'Nike Running Shoes', 'Nike', 'Men size 10 running shoes', 89.99, 70.00, 85.00, 'Apparel', 'Footwear');

-- Drop and recreate Product_Inventory table
DROP TABLE IF EXISTS Product_Inventory;
CREATE TABLE Product_Inventory (
    inventory_id INT PRIMARY KEY,
    store_id INT,
    product_id INT,
    quantity INT,
    shelf_location VARCHAR(20),
    last_restocked DATETIME,
    minimum_stock INT,
    maximum_stock INT,
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Product_Inventory VALUES
(1, 1, 1, 50, 'A1', '2024-10-01 10:00:00', 10, 100),
(2, 1, 2, 20, 'A2', '2024-10-01 10:00:00', 5, 50),
(3, 2, 3, 15, 'B1', '2024-10-02 12:00:00', 2, 20),
(4, 3, 4, 30, 'C1', '2024-10-03 15:00:00', 10, 50);

-- Drop and recreate Shopping_Cart table
DROP TABLE IF EXISTS Shopping_Cart;
CREATE TABLE Shopping_Cart (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    created_at DATETIME,
    is_active BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Shopping_Cart VALUES
(1, 1, '2024-10-15 14:00:00', TRUE),
(2, 2, '2024-10-15 15:00:00', TRUE);

-- Drop and recreate Cart_Items table
DROP TABLE IF EXISTS Cart_Items;
CREATE TABLE Cart_Items (
    cart_id INT,
    product_id INT,
    quantity INT,
    added_at DATETIME,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES Shopping_Cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Cart_Items VALUES
(1, 1, 2, '2024-10-15 14:05:00'),
(1, 2, 1, '2024-10-15 14:10:00'),
(2, 3, 1, '2024-10-15 15:05:00');

-- Drop and recreate Orders table
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    store_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    order_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled'),
    order_type ENUM('In-Store', 'Online', 'Pickup'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

INSERT INTO Orders VALUES
(NULL, 1, 1, '2024-10-15 16:00:00', 12.94, 'Credit Card', 'Completed', 'In-Store'),
(NULL, 2, 2, '2024-10-15 17:00:00', 649.99, 'Debit Card', 'Pending', 'Online');

-- Drop and recreate Order_Items table
DROP TABLE IF EXISTS Order_Items;
CREATE TABLE Order_Items (
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Order_Items VALUES
(1, 1, 2, 3.48, 6.96),
(1, 2, 1, 4.98, 4.98),
(2, 3, 1, 649.99, 649.99);

-- Insert sample data into Order_Activity_Log
INSERT INTO order_activity_log (order_id, activity_description) VALUES
(1, 'Order created'),
(2, 'Order created'),
(3, 'Order created');


