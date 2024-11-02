-- Drop if exists to avoid errors
DROP PROCEDURE IF EXISTS check_low_stock;
DROP PROCEDURE IF EXISTS create_order;

DELIMITER //

-- Procedure to check stock levels
CREATE PROCEDURE check_low_stock(IN threshold INT)
BEGIN
    SELECT 
        p.product_name,
        pi.quantity,
        s.store_name,
        pi.minimum_stock
    FROM Product_Inventory pi
    JOIN Products p ON pi.product_id = p.product_id
    JOIN Stores s ON pi.store_id = s.store_id
    WHERE pi.quantity < threshold;
END //

-- Procedure to process an order
CREATE PROCEDURE create_order(
    IN p_customer_id INT,
    IN p_store_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_order_id INT;
    
    -- Get product price
    SELECT retail_price INTO v_price 
    FROM Products 
    WHERE product_id = p_product_id;
    
    -- Create order
    INSERT INTO Orders (customer_id, store_id, order_date, total_amount, payment_method, order_status, order_type)
    VALUES (p_customer_id, p_store_id, NOW(), v_price * p_quantity, p_payment_method, 'Processing', 'In-Store');
    
    SET v_order_id = LAST_INSERT_ID();
    
    -- Add order items
    INSERT INTO Order_Items (order_id, product_id, quantity, price_per_unit, subtotal)
    VALUES (v_order_id, p_product_id, p_quantity, v_price, v_price * p_quantity);
    
    -- Update inventory
    UPDATE Product_Inventory
    SET quantity = quantity - p_quantity
    WHERE product_id = p_product_id AND store_id = p_store_id;
    
    SELECT v_order_id AS new_order_id;
END //

DELIMITER ;

