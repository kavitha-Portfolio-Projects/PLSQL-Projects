--FUNCTION DEFINITION
CREATE OR REPLACE FUNCTION fn_TotalOrderValue (
    p_OrderID IN OrderHeader.OrderID%TYPE
) RETURN NUMBER
IS
    v_Total NUMBER := 0;
BEGIN
    SELECT SUM(Quantity * UnitPrice)
    INTO v_Total
    FROM OrderDetails
    WHERE OrderID = p_OrderID;

    RETURN v_Total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN -1;  -- signal error
END;
/
--TO CALL
SELECT fn_TotalOrderValue(1) AS TotalAmount FROM dual;

--IN AN ANONYMOUS BLOCK:

DECLARE
    v_total NUMBER;
BEGIN
    v_total := fn_TotalOrderValue(1);
    DBMS_OUTPUT.PUT_LINE('Total Order Value: ₹' || v_total);
END;
/

