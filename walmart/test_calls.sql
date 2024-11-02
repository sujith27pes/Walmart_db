-- Create the order_activity_log table if it does not exist
CREATE TABLE IF NOT EXISTS order_activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    activity_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    activity_description VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Drop foreign key constraint if it exists
-- Drop foreign key constraint if it exists
SET FOREIGN_KEY_CHECKS=0; -- Disable foreign key checks
ALTER TABLE order_activity_log DROP FOREIGN KEY order_activity_log_ibfk_1; -- Drop the foreign key
SET FOREIGN_KEY_CHECKS=1; -- Re-enable foreign key checks


-- Test check_low_stock procedure to check for low-stock items
CALL check_low_stock(1);  -- Adjust with appropriate parameters if needed

-- Test create_order procedure by placing a sample order
CALL create_order(1, 1, 1, 2, 'In-Store');  -- Ensure this matches the procedure definition
CALL create_order(2, 2, 3, 1, 'Online');    -- Adjust as needed
CALL create_order(3, 3, 4, 5, 'Pickup');    -- Adjust as needed

-- View low_stock_view for items that need restocking
SELECT * FROM low_stock_view;

-- View customer_order_history_view to get the history of all customer orders
SELECT * FROM customer_order_history_view;

-- View store_sales_summary_view for total sales and order count by store
SELECT * FROM store_sales_summary_view;

-- Testing the trigger for updating inventory after order creation
-- Verify stock levels by querying Product_Inventory after order creation
SELECT * FROM Product_Inventory WHERE product_id = 1;
SELECT * FROM Product_Inventory WHERE product_id = 3;
SELECT * FROM Product_Inventory WHERE product_id = 4;

-- Test the log_order_activity trigger
-- Check the output in order_activity_log table for order creation logs
SELECT * FROM order_activity_log;

