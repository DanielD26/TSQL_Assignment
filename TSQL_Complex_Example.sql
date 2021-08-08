USE TSQL_ASSIGNMENT;

-- TASK 1

IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;
GO

CREATE PROCEDURE ADD_CUSTOMER @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS

BEGIN
    BEGIN TRY

        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS) 
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK');

    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 2627
            THROW 50010, 'Duplicate customer ID', 1
        ELSE IF ERROR_NUMBER() = 50020
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;

END;

GO

EXEC ADD_CUSTOMER @pcustid = 3, @pcustname = 'testdude2';

EXEC ADD_CUSTOMER @pcustid = 497, @pcustname = 'testdude3';


-- TASK 2
GO 

IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;
GO

CREATE PROCEDURE DELETE_ALL_CUSTOMERS AS
BEGIN
    BEGIN TRY

        DELETE FROM CUSTOMER
        RETURN @@ROWCOUNT

    END TRY

    BEGIN CATCH
        BEGIN

            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1

        END
    END CATCH
END

GO

EXEC DELETE_ALL_CUSTOMERS;

-- TASK 3

GO

IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;
GO

CREATE PROCEDURE ADD_PRODUCT @PPRODID INT, @PPRODNAME NVARCHAR(100), @PPRICE MONEY AS

BEGIN 
    BEGIN TRY
        IF @PPRODID < 1000 OR @PPRODID > 2500
            THROW 50040, 'Product ID out of range', 1
        ELSE IF @PPRICE < 0 OR @PPRICE > 999.99
            THROW 50050, 'Price out of range', 1
        
        INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
        VALUES (@PPRODID, @PPRODNAME, @PPRICE, 0)
    END TRY

    BEGIN CATCH
        IF ERROR_NUMBER() = 2627
            THROW 50030, 'Duplicate Product ID', 1
        ELSE IF ERROR_NUMBER() = 50040
            THROW
        ELSE IF ERROR_NUMBER() = 50050
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;

GO

EXEC ADD_PRODUCT @pprodid = 1000, @pprodname = 'Bill', @pprice = 1
EXEC ADD_PRODUCT @pprodid = 2500, @pprodname = 'Bob', @pprice = 1
EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'Brad', @pprice = 1

-- TASK 4

GO 

IF OBJECT_ID('DELETE_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_PRODUCTS;
GO

CREATE PROCEDURE DELETE_ALL_PRODUCTS AS
BEGIN
    BEGIN TRY

        DELETE FROM PRODUCT
        RETURN @@ROWCOUNT

    END TRY

    BEGIN CATCH
        BEGIN

            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1

        END
    END CATCH
END

GO

EXEC DELETE_ALL_PRODUCTS;

-- TASK 5

GO

IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING 
GO

CREATE PROCEDURE GET_CUSTOMER_STRING @PCUSTID INT, @PRETURNSTRING NVARCHAR(1000) OUT AS

BEGIN
    BEGIN TRY
        DECLARE @CNAME NVARCHAR(100);
        DECLARE @STATUS NVARCHAR(7);
        DECLARE @SYTD MONEY;

        SELECT @CNAME = CUSTNAME, @STATUS = STATUS, @SYTD = SALES_YTD FROM CUSTOMER WHERE @PCUSTID = CUSTID;

        SET @PRETURNSTRING = CONCAT('Custid: ', @PCUSTID,  ' Name: ', @CNAME, ' Status: ', @STATUS,  ' SalesYTD: ', @SYTD);
        PRINT @PRETURNSTRING;
  
        IF @PCUSTID NOT IN (SELECT CUSTID FROM CUSTOMER)
            THROW 50060, 'Customer ID not found', 1

    END TRY 

    BEGIN CATCH
        IF ERROR_NUMBER() = 50060
            THROW
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1 
    END CATCH
END


GO

BEGIN
    DECLARE @RETURNSTRING NVARCHAR(1000) = 'Original value';

    EXEC GET_CUSTOMER_STRING @PCUSTID = 3, @PRETURNSTRING = @RETURNSTRING OUT

END


-- TASK 6

GO

IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD
GO

CREATE PROCEDURE UPD_CUST_SALESYTD @PCUSTID INT, @PAMT MONEY AS
BEGIN
    BEGIN TRY
        UPDATE CUSTOMER
        SET SALES_YTD = @PAMT
        WHERE CUSTID = @PCUSTID;
        IF @PCUSTID NOT IN (SELECT CUSTID FROM CUSTOMER)
            THROW 50070, 'Customer ID not found', 1
    END TRY

    BEGIN CATCH
        IF @PAMT < -999.99 OR @PAMT > 999.99
            THROW 50080, 'Amount out of range', 1
        ELSE IF ERROR_NUMBER() = 50080
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH
END

GO

EXEC UPD_CUST_SALESYTD @PCUSTID = 3, @PAMT = 10;

-- TASK 7

GO

IF OBJECT_ID('GET_PROD_STRING') IS NOT NULL
DROP PROCEDURE GET_PROD_STRING 
GO

CREATE PROCEDURE GET_PROD_STRING @PPRODID INT, @PRETURNSTRING NVARCHAR(1000) OUT AS

BEGIN
    BEGIN TRY
        DECLARE @PNAME NVARCHAR(100);
        DECLARE @SELLINGPRICE MONEY;
        DECLARE @SYTD MONEY;

        SELECT @PNAME = PRODNAME, @SELLINGPRICE = SELLING_PRICE, @SYTD = SALES_YTD FROM PRODUCT WHERE @PPRODID = PRODID;

        SET @PRETURNSTRING = CONCAT('ProdID: ', @PPRODID,  ' Name: ', @PNAME, ' Price: ', @SELLINGPRICE,  ' SalesYTD: ', @SYTD);
        PRINT @PRETURNSTRING;
  
        IF @PPRODID NOT IN (SELECT PRODID FROM PRODUCT)
            THROW 50060, 'Customer ID not found', 1

    END TRY 

    BEGIN CATCH
        IF ERROR_NUMBER() = 50060
            THROW
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1 
    END CATCH
END

select * from customer;
select * from PRODUCT;