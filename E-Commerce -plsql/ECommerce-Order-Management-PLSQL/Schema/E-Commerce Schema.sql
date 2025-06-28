-- ECOMMERCE MANAGEMENT 
-- CREATING  TABLES
-- Customer Table 
CREATE TABLE Customer (
    CustomerID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FirstName VARCHAR2(30),
    LastName VARCHAR2(30),
    Email VARCHAR2(50),
    Phone VARCHAR2(15),
    Address VARCHAR2(100)
);

--Product Table
CREATE TABLE Product (
    ProductID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProductName VARCHAR2(50),
    Category VARCHAR2(30),
    Price NUMBER(10,2),
    StockQty NUMBER,
    ReorderLevel NUMBER
);

--OrderHeader Table
 
CREATE TABLE OrderHeader (
    OrderID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    CustomerID NUMBER,
    OrderDate DATE DEFAULT SYSDATE,
    OrderStatus VARCHAR2(20), -- e.g., Placed, Shipped, Cancelled
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- OrderDetails Table
--(Multiple products per order)
 
CREATE TABLE OrderDetails (
    OrderDetailID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    OrderID NUMBER,
    ProductID NUMBER,
    Quantity NUMBER,
    UnitPrice NUMBER(10,2),
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

--Payment Table
 CREATE TABLE Payment (
    PaymentID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    OrderID NUMBER,
    AmountPaid NUMBER(10,2),
    PaymentMode VARCHAR2(20),  -- e.g., Card, UPI, Cash
    PaymentDate DATE DEFAULT SYSDATE,
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(OrderID)
);

--Shipping Table
CREATE TABLE Shipping (
    ShippingID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    OrderID NUMBER,
    ShippingAddress VARCHAR2(100),
    ShippingStatus VARCHAR2(20), -- e.g., Pending, Shipped, Delivered
    ExpectedDelivery DATE,
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(OrderID)
);

--OrderAudit Table
 CREATE TABLE OrderAudit (
    AuditID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    OrderID NUMBER,
    OldStatus VARCHAR2(20),
    NewStatus VARCHAR2(20),
    ChangeDate DATE DEFAULT SYSDATE,
    ChangedBy VARCHAR2(30)
);

