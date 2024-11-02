-- Create and use the database
DROP DATABASE IF EXISTS walmart_dbms;
CREATE DATABASE walmart_dbms;
USE walmart_dbms;

-- Drop existing tables if they exist to avoid conflicts
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cart_Items;
DROP TABLE IF EXISTS Shopping_Cart;
DROP TABLE IF EXISTS Product_Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Stores;

-- Define the 'Stores' table
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

-- Define the 'Departments' table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    description TEXT,
    manager_id INT
);

-- Define the 'Employees' table
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

-- Define the 'Customers' table
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

-- Define the 'Products' table
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

-- Define the 'Product_Inventory' table
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

-- Define the 'Shopping_Cart' table
CREATE TABLE Shopping_Cart (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    created_at DATETIME,
    is_active BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Define the 'Cart_Items' table
CREATE TABLE Cart_Items (
    cart_id INT,
    product_id INT,
    quantity INT,
    added_at DATETIME,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES Shopping_Cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Define the 'Orders' table
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

-- Define the 'Order_Items' table
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
DROP TABLE IF EXISTS order_activity_log;

-- Create table for logging order activities
CREATE TABLE IF NOT EXISTS order_activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    activity_description VARCHAR(255),
    activity_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);