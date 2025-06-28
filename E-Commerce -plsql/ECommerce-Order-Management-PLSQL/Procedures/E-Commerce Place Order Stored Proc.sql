--Procedure When called with (CustomerID & List of ProductID & Quantity)

--Will: 1.Check availabile stock 

--2. Insert into OrderHeader --3. Insert corresponding rows in OrderDetails

--4. Deduct stock from Product --5. Return OrderID

CREATE OR REPLACE PROCEDURE PlaceOrder (
    p_CustomerID    IN  Customer.CustomerID%TYPE,
    p_ProductID     IN  Product.ProductID%TYPE,
    p_Quantity      IN  NUMBER,
    p_OrderID       OUT OrderHeader.OrderID%TYPE
)
IS
    v_StockQty      Product.StockQty%TYPE;
    v_UnitPrice     Product.Price%TYPE;
BEGIN
    -- Step 1: Check if product exists and has enough stock
    SELECT StockQty, Price
    INTO v_StockQty, v_UnitPrice
    FROM Product
    WHERE ProductID = p_ProductID;

    IF v_StockQty < p_Quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Not enough stock available.');
    END IF;

    -- Step 2: Insert into OrderHeader
    INSERT INTO OrderHeader (CustomerID, OrderDate, OrderStatus)
    VALUES (p_CustomerID, SYSDATE, 'Placed')
    RETURNING OrderID INTO p_OrderID;

    -- Step 3: Insert into OrderDetails
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (p_OrderID, p_ProductID, p_Quantity, v_UnitPrice);

    -- Step 4: Update Product stock
    UPDATE Product
    SET StockQty = StockQty - p_Quantity
    WHERE ProductID = p_ProductID;

    DBMS_OUTPUT.PUT_LINE('Order placed successfully. OrderID: ' || p_OrderID);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Product not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

--TO RUN
DECLARE
    v_order_id NUMBER;
BEGIN
    PlaceOrder(p_CustomerID => 1, p_ProductID => 2, p_Quantity => 1, p_OrderID => v_order_id);
    DBMS_OUTPUT.PUT_LINE('New Order ID: ' || v_order_id);
END;
/

--FINAL E-COMMERCE PROCEDURE: GENERATEBILL
CREATE OR REPLACE PROCEDURE GenerateBill (
    p_CustomerID   IN  Customer.CustomerID%TYPE,
    p_OrderID      IN  OrderHeader.OrderID%TYPE
)
IS
    v_TotalAmount  NUMBER;
BEGIN
    -- 1. Calculate total from OrderDetails
    v_TotalAmount := fn_TotalOrderValue(p_OrderID);

    -- 2. Insert a new bill
    INSERT INTO Billing (CustomerID, OrderID, BillDate, TotalAmount, PaymentStatus)
    VALUES (p_CustomerID, p_OrderID, SYSDATE, v_TotalAmount, 'Pending');

    DBMS_OUTPUT.PUT_LINE('🧾 Bill Generated: ₹' || v_TotalAmount);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Error: ' || SQLERRM);
END;
/

--TO RUN 

BEGIN
    GenerateBill(p_CustomerID => 1, p_OrderID => 101);
END;
/
--TO TEST:
SELECT * FROM Billing WHERE CustomerID = 1;
