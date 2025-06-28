-- ECOMMERCE MANAGEMENT
----RECORD INSERT
--Customer
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address) VALUES
('Arun', 'Kumar', 'arun.k@example.com', '9876543210', 'Chennai'),
('Divya', 'Ramesh', 'divya.r@example.com', '9823123456', 'Coimbatore'),
('Suresh', 'Menon', 'suresh.m@example.com', '9845012345', 'Madurai');

--Product
INSERT INTO Product (ProductName, Category, Price, StockQty, ReorderLevel) VALUES
('Bluetooth Speaker', 'Electronics', 1999.00, 20, 5),
('Office Chair', 'Furniture', 3500.00, 10, 2),
('Wireless Mouse', 'Electronics', 799.00, 50, 10),
('Bookshelf', 'Furniture', 1200.00, 5, 1);

--OrderHeader
INSERT INTO OrderHeader (CustomerID, OrderDate, OrderStatus) VALUES
(1, TO_DATE('2025-06-10','YYYY-MM-DD'), 'Placed'),
(2, TO_DATE('2025-06-11','YYYY-MM-DD'), 'Shipped'),
(3, TO_DATE('2025-06-12','YYYY-MM-DD'), 'Delivered');

--OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 2, 1999.00),  -- Arun bought 2 Bluetooth Speakers
(1, 3, 1, 799.00),   -- Arun also bought 1 Mouse
(2, 2, 1, 3500.00),  -- Divya bought 1 Chair
(3, 4, 1, 1200.00);  -- Suresh bought 1 Bookshelf

--Payment 
INSERT INTO Payment (OrderID, AmountPaid, PaymentMode) VALUES
(1, 4797.00, 'UPI'),
(2, 3500.00, 'Card'),
(3, 1200.00, 'Cash');

--Shipping 
INSERT INTO Shipping (OrderID, ShippingAddress, ShippingStatus, ExpectedDelivery) VALUES
(1, '123 Street, Chennai', 'Pending', TO_DATE('2025-06-12','YYYY-MM-DD')),
(2, '45 Cross, Coimbatore', 'Shipped', TO_DATE('2025-06-13','YYYY-MM-DD')),
(3, '78 Block, Madurai', 'Delivered', TO_DATE('2025-06-14','YYYY-MM-DD'));
