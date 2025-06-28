--TRIGGER: trg_log_order_insert
CREATE OR REPLACE TRIGGER trg_log_order_insert
AFTER INSERT ON OrderHeader
FOR EACH ROW
BEGIN
    INSERT INTO OrderAudit (
        OrderID,
        OldStatus,
        NewStatus,
        ChangeDate,
        ChangedBy
    ) VALUES (
        :NEW.OrderID,
        'N/A',
        :NEW.OrderStatus,
        SYSDATE,
        USER
    );
END;
/
--Test
INSERT INTO OrderHeader (CustomerID, OrderDate, OrderStatus)
VALUES (1, SYSDATE, 'Placed');
-- Then
SELECT * FROM OrderAudit;

-- TRIGGER: trg_order_status_update
CREATE OR REPLACE TRIGGER trg_order_status_update
AFTER UPDATE OF OrderStatus ON OrderHeader
FOR EACH ROW
WHEN (OLD.OrderStatus <> NEW.OrderStatus)
BEGIN
    INSERT INTO OrderAudit (
        OrderID,
        OldStatus,
        NewStatus,
        ChangeDate,
        ChangedBy
    ) VALUES (
        :OLD.OrderID,
        :OLD.OrderStatus,
        :NEW.OrderStatus,
        SYSDATE,
        USER
    );
END;
/
--Test
UPDATE OrderHeader
SET OrderStatus = 'Shipped'
WHERE OrderID = 1;

--check the audit log
SELECT * FROM OrderAudit
WHERE OrderID = 1
ORDER BY ChangeDate DESC;


--trg_auto_generate_bill 1. Fires AFTER INSERT on OrderHeader
--2. Calculates total using fn_TotalOrderValue
--3. Inserts a bill into the Billing table with 'Pending' status

CREATE OR REPLACE TRIGGER trg_auto_generate_bill
AFTER INSERT ON OrderHeader
FOR EACH ROW
DECLARE
    v_Total NUMBER;
BEGIN
    -- Step 1: Calculate order value using the function
    v_Total := fn_TotalOrderValue(:NEW.OrderID);

    -- Step 2: Insert billing record
    INSERT INTO Billing (
        CustomerID, OrderID, BillDate, TotalAmount, PaymentStatus
    ) VALUES (
        :NEW.CustomerID, :NEW.OrderID, SYSDATE, v_Total, 'Pending'
    );

    DBMS_OUTPUT.PUT_LINE('✅ Bill auto-generated for Order ID ' || :NEW.OrderID);
END;
/

--Test
-- Step 1: Add a new order
INSERT INTO OrderHeader (CustomerID, OrderDate, OrderStatus)
VALUES (1, SYSDATE, 'Placed');

-- Step 2: Add order details manually if needed
-- (make sure OrderDetails has matching OrderID)

-- Step 3: Check if the bill was created
SELECT * FROM Billing
ORDER BY BillDate DESC;