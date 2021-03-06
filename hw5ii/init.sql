CREATE TABLE Customer (
    ID INT PRIMARY KEY NOT NULL,
    Company TEXT NOT NULL,
    LastName TEXT NOT NULL,
    FirstName TEXT NOT NULL,
    Email TEXT NULL,
    JobTitle TEXT NULL,
    BusinessPhone TEXT NOT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY NOT NULL,
    EmployeeID INT NOT NULL,
    CustomerID INT NOT NULL REFERENCES Customer(ID),
    OrderDate DATE NOT NULL,
    ShippedDate DATE NULL,
    ShipperID INT NULL,
    ShipName TEXT NOT NULL,
    ShipAddress TEXT NOT NULL,
    ShipCity TEXT NOT NULL,
    ShipStateOrProvince TEXT NOT NULL,
    ShipPostalCode TEXT NOT NULL,
    StatusID INT NOT NULL
);

CREATE TABLE Products (
    SupplierID INT NOT NULL,
    ID INT PRIMARY KEY NOT NULL,
    ProductCode TEXT NOT NULL,
    ProductName TEXT NOT NULL,
    ProductDescription TEXT NULL,
    StandardCost REAL NOT NULL,
    ListPrice REAL NOT NULL,
    Category TEXT NOT NULL
);

CREATE TABLE PurchaseOrderDetails (
    ID INT PRIMARY KEY NOT NULL,
    PurchaseOrderID INT NOT NULL,
    ProductID INT NOT NULL REFERENCES Products(ID),
    Quantity INT NOT NULL,
    UnitCost REAL NOT NULL,
    DateRecieved DATE NOT NULL,
    InventoryID INT NOT NULL
);

COPY Customer (
        ID,
        Company,
        LastName,
        FirstName,
        Email,
        JobTitle,
        BusinessPhone
) 
FROM '/home/imports/Customers short.csv' DELIMITER ',' CSV HEADER;

COPY Orders (
    OrderID,
    EmployeeID,
    CustomerID,
    OrderDate,
    ShippedDate,
    ShipperID,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipStateOrProvince,
    ShipPostalCode,
    StatusID 
)
FROM '/home/imports/Orders short.csv' DELIMITER ',' CSV HEADER;

COPY Products (
    SupplierID,
    ID,
    ProductCode,
    ProductName,
    ProductDescription,
    StandardCost,
    ListPrice,
    Category
)
FROM '/home/imports/Products short.csv' DELIMITER ',' CSV HEADER;

COPY PurchaseOrderDetails (
    ID,
    PurchaseOrderID,
    ProductID,
    Quantity,
    UnitCost,
    DateRecieved,
    InventoryID
)
FROM '/home/imports/Purchase Order Details short.csv' DELIMITER ',' CSV HEADER;

CREATE FUNCTION reject_duplicates() 
RETURNS trigger AS $func$
BEGIN
    IF (SELECT TRUE FROM Customer AS c WHERE c.ID = NEW.ID) 
    THEN RETURN NULL; /*RAISE EXCEPTION 'Duplicate Customer IDs';*/
    END IF;
    RETURN NEW;
END; 
$func$ LANGUAGE plpgsql;

CREATE TRIGGER check_customer_dups BEFORE INSERT ON Customer
FOR EACH ROW EXECUTE PROCEDURE reject_duplicates();

SELECT tgname FROM pg_trigger;

SELECT * FROM Customer;

INSERT INTO Customer(
    ID,
    Company,
    LastName,
    FirstName,
    BusinessPhone
) VALUES (
    14,
    'Company O',
    'Sanchez',
    'Rick',
    '(555) 555-5555'
);

SELECT * FROM Customer;

INSERT INTO Customer(
    ID,
    Company,
    LastName,
    FirstName,
    BusinessPhone
) VALUES (
    15,
    'Company O',
    'Smith',
    'Morty',
    '(123) 123-1234'
);

SELECT * FROM Customer;
