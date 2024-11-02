-- Drop views if they already exist
DROP VIEW IF EXISTS low_stock_view;
DROP VIEW IF EXISTS customer_order_history_view;
DROP VIEW IF EXISTS store_sales_summary_view;

-- View to display products with low stock levels at each store
CREATE VIEW low_stock_view AS
SELECT
    s.store_name,
    p.product_name,
    pi.quantity AS stock_quantity,
    pi.minimum_stock
FROM
    Product_Inventory pi
    JOIN Stores s ON pi.store_id = s.store_id
    JOIN Products p ON pi.product_id = p.product_id
WHERE
    pi.quantity <= pi.minimum_stock;

-- View to retrieve a customer's order history
CREATE VIEW customer_order_history_view AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.order_status
FROM
    Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY
    c.customer_id, o.order_date DESC;

-- View to summarize total sales by store
CREATE VIEW store_sales_summary_view AS
SELECT
    s.store_id,
    s.store_name,
    SUM(o.total_amount) AS total_sales,
    COUNT(o.order_id) AS number_of_orders
FROM
    Orders o
    JOIN Stores s ON o.store_id = s.store_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    s.store_id, s.store_name;

