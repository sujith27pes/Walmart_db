-- Drop triggers if they exist
DROP TRIGGER IF EXISTS update_inventory;

DELIMITER //

-- Trigger to update product inventory after an order is processed
CREATE TRIGGER update_inventory
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Product_Inventory
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //

DELIMITER ;

