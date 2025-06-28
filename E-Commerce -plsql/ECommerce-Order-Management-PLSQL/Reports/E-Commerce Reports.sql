
--Sales Summary Report (Monthly)

SET SERVEROUTPUT ON;

DECLARE
    CURSOR sales_report IS
        SELECT TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
               COUNT(order_id) AS total_orders,
               SUM(total_amount) AS revenue
        FROM Orders
        GROUP BY TO_CHAR(order_date, 'YYYY-MM')
        ORDER BY sales_month;

    v_month        VARCHAR2(10);
    v_orders       NUMBER;
    v_revenue      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Month     | Orders | Revenue');
    DBMS_OUTPUT.PUT_LINE('-----------------------------');

    FOR rec IN sales_report LOOP
        v_month := rec.sales_month;
        v_orders := rec.total_orders;
        v_revenue := rec.revenue;

        DBMS_OUTPUT.PUT_LINE(v_month || ' | ' || v_orders || '     | ' || v_revenue);
    END LOOP;
END;

-- BEGIN
    DBMS_OUTPUT.PUT_LINE('Product Name | Stock Qty');
    DBMS_OUTPUT.PUT_LINE('------------------------');

    FOR rec IN (SELECT product_name, stock_qty 
                FROM Products 
                WHERE stock_qty < 10) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.product_name || ' | ' || rec.stock_qty);
    END LOOP;
END;


--Low Stock Product Report
BEGIN
    DBMS_OUTPUT.PUT_LINE('Product Name | Stock Qty');
    DBMS_OUTPUT.PUT_LINE('------------------------');

    FOR rec IN (SELECT product_name, stock_qty 
                FROM Products 
                WHERE stock_qty < 10) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.product_name || ' | ' || rec.stock_qty);
    END LOOP;
END;


--Top Customers by Spend
BEGIN
    DBMS_OUTPUT.PUT_LINE('Customer Name | Total Spend');
    DBMS_OUTPUT.PUT_LINE('---------------------------');

    FOR rec IN (
        SELECT c.customer_name, SUM(o.total_amount) AS total_spent
        FROM Customers c
        JOIN Orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_name
        ORDER BY total_spent DESC
        FETCH FIRST 5 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.customer_name || ' | ' || rec.total_spent);
    END LOOP;
END;
