USE TSQL_ASSIGNMENT;
/*
    GO

    IF OBJECT_ID('XXXXXXXXX') IS NOT NULL
    DROP PROCEDURE XXXXXXXXX
    GO

    CREATE PROCEDURE XXXXXXXXX ____ AS
    BEGIN
        BEGIN TRY
            
        END TRY

        BEGIN CATCH
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

*/

-- TASK 1 ADD_CUSTOMER

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
            IF ERROR_NUMBER() = 2627
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

-- TASK 2 DELETE_ALL_CUSTOMERS
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

-- TASK 3 ADD_PRODUCT

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

-- TASK 4 DELETE_ALL_PRODUCTS

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

-- TASK 5 GET_CUSTOMER_STRING

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

-- TASK 6 UPD_CUST_SALESYTD

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
            IF @@ROWCOUNT = 0
                THROW 50070, 'Customer ID not found', 1
            ELSE IF @PAMT < -999.99 OR @PAMT > 999.99
                THROW 50080, 'Amount out of range', 1
        END TRY

        BEGIN CATCH
            IF ERROR_NUMBER() = 50070
                THROW
            ELSE IF ERROR_NUMBER() = 50080
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
    END

-- TASK 7 GET_PROD_STRING

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
                THROW 50090, 'Product ID not found', 1

        END TRY 

        BEGIN CATCH
            IF ERROR_NUMBER() = 50090
                THROW
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

-- TASK 8 UPD_PROD_SALESYTD

    GO

    IF OBJECT_ID('UPD_PROD_SALESYTD') IS NOT NULL
    DROP PROCEDURE UPD_PROD_SALESYTD
    GO

    CREATE PROCEDURE UPD_PROD_SALESYTD @PPRODID INT, @PAMT MONEY AS
    BEGIN
        BEGIN TRY
            UPDATE PRODUCT
            SET SALES_YTD = @PAMT
            WHERE @PPRODID = PRODID;

            IF @@ROWCOUNT = 0
                THROW 50100, 'Product ID not found', 1
            ELSE IF @PAMT < -999.99 OR @PAMT > 999.99
                THROW 50110, 'Amount out of range', 1
        END TRY

        BEGIN CATCH
            IF ERROR_NUMBER() = 50100
                THROW
            ELSE IF ERROR_NUMBER() = 50110
                THROW
            ELSE 
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH

    END

-- TASK 9 UPD_CUSTOMER_STATUS

    GO

    IF OBJECT_ID('UPD_CUSTOMER_STATUS') IS NOT NULL
    DROP PROCEDURE UPD_CUSTOMER_STATUS
    GO

    CREATE PROCEDURE UPD_CUSTOMER_STATUS @PCUSTID INT, @PSTATUS NVARCHAR(7) AS

    BEGIN
        BEGIN TRY
            IF (@PSTATUS != 'OK' AND @PSTATUS != 'SUSPEND')
                THROW 50130, 'Invalid Status value', 1

            UPDATE CUSTOMER
            SET [STATUS] = @PSTATUS
            WHERE @PCUSTID = CUSTID

            IF @@ROWCOUNT = 0
                THROW 50120, 'Customer ID not found', 1
            
        END TRY
            
        BEGIN CATCH
            IF ERROR_NUMBER() = 50120
                THROW
            ELSE IF ERROR_NUMBER() = 50130
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
    END

-- TASK 10 ADD_SIMPLE_SALE

    GO

    IF OBJECT_ID('ADD_SIMPLE_SALE') IS NOT NULL
    DROP PROCEDURE ADD_SIMPLE_SALE
    GO

    CREATE PROCEDURE ADD_SIMPLE_SALE @PCUSTID INT, @PPRODID INT, @PQTY INT AS

    BEGIN
        BEGIN TRY
            DECLARE @STATUS NVARCHAR(7)
            SELECT @STATUS = STATUS FROM CUSTOMER WHERE @PCUSTID = CUSTID;
            IF (@STATUS != 'OK')
                THROW 50150, 'Customer status is not OK', 1
            ELSE IF @PQTY < 1 OR @PQTY > 999
                THROW 50140, 'Sale Quantity outside valid range', 1
            ELSE IF @PCUSTID NOT IN (SELECT CUSTID FROM CUSTOMER)
                THROW 50160, 'Customer ID not found', 1
            ELSE IF @PPRODID NOT IN (SELECT PRODID FROM PRODUCT)
                THROW 50170, 'Product ID not found', 1 

            UPDATE C
                SET C.SALES_YTD = (@PQTY * P.SELLING_PRICE)
            FROM CUSTOMER C
                INNER JOIN PRODUCT P
                    ON P.SALES_YTD = C.SALES_YTD

            UPDATE P
                SET P.SALES_YTD = (@PQTY * P.SELLING_PRICE)
            FROM PRODUCT P   

        END TRY

        BEGIN CATCH
            IF ERROR_NUMBER() = 50140
                THROW
            ELSE IF ERROR_NUMBER() = 50150
                THROW
            ELSE IF ERROR_NUMBER() = 50160
                THROW
            ELSE IF ERROR_NUMBER() = 50170
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
    END

-- TASK 11 SUM_CUSTOMER_SALESYTD
    GO

    IF OBJECT_ID('SUM_CUSTOMER_SALESYTD') IS NOT NULL
    DROP PROCEDURE SUM_CUSTOMER_SALESYTD
    GO

    CREATE PROCEDURE SUM_CUSTOMER_SALESYTD AS
    BEGIN
        BEGIN TRY
            SELECT SUM(SALES_YTD) FROM CUSTOMER
        END TRY

        BEGIN CATCH
            BEGIN

                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1

            END
        END CATCH
    END

-- TASK 12 SUM_PRODUCT_SALESYTD
    GO

    IF OBJECT_ID('SUM_PRODUCT_SALESYTD') IS NOT NULL
    DROP PROCEDURE SUM_PRODUCT_SALESYTD
    GO

    CREATE PROCEDURE SUM_PRODUCT_SALESYTD AS
    BEGIN
        BEGIN TRY
            SELECT SUM(SALES_YTD) FROM PRODUCT
        END TRY

        BEGIN CATCH
            BEGIN

                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1

            END
        END CATCH
    END

-- TASK 13 GET_ALL_CUSTOMERS
    GO

    IF OBJECT_ID('GET_ALL_CUSTOMERS') IS NOT NULL
    DROP PROCEDURE GET_ALL_CUSTOMERS
    GO

    CREATE PROCEDURE GET_ALL_CUSTOMERS @POUTCUR CURSOR VARYING OUT AS
    BEGIN
        BEGIN TRY
            SET @POUTCUR = CURSOR FOR SELECT * FROM CUSTOMER;
            OPEN @POUTCUR;
        END TRY

        BEGIN CATCH
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

-- TASK 14 GET_ALL_PRODUCTS
    GO

    IF OBJECT_ID('GET_ALL_PRODUCTS') IS NOT NULL
    DROP PROCEDURE GET_ALL_PRODUCTS
    GO

    CREATE PROCEDURE GET_ALL_PRODUCTS @POUTCUR CURSOR VARYING OUT AS
    BEGIN
        BEGIN TRY
            SET @POUTCUR = CURSOR FOR SELECT * FROM PRODUCT;
            OPEN @POUTCUR;
        END TRY

        BEGIN CATCH
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

-- TASK 15 ADD_LOCATION
    GO

    IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
    DROP PROCEDURE ADD_LOCATION
    GO

    CREATE PROCEDURE ADD_LOCATION @PLOCCODE NVARCHAR(MAX), @PMINQTY INT, @PMAXQTY INT AS
    BEGIN
        BEGIN TRY
            IF LEN(@PLOCCODE) != 5
                THROW 50190, 'Location Code length invalid', 1;
            ELSE IF @PMINQTY < 0 OR @PMINQTY > 999
                THROW 50200, 'Minimum Qty out of range', 1;
            ELSE IF @PMAXQTY < 0 OR @PMAXQTY > 999
                THROW 50210, 'Maximum Qty out of range', 1;
            ELSE IF @PMAXQTY < @PMINQTY
                THROW 50220, 'Minimum Qty larger than Maximum Qty', 1;

            INSERT INTO LOCATION (LOCID, MINQTY, MAXQTY)
            VALUES (@PLOCCODE, @PMINQTY, @PMAXQTY);
        END TRY

        BEGIN CATCH
            IF ERROR_NUMBER() = 2627
                THROW 50010, 'Duplicate location ID', 1
            ELSE IF ERROR_NUMBER() = 50190
                THROW
            ELSE IF ERROR_NUMBER() = 50200
                THROW
            ELSE IF ERROR_NUMBER() = 50210
                THROW
            ELSE IF ERROR_NUMBER() = 50220
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
    END

        -- REMOVE LOCATION  
            GO 

            IF OBJECT_ID('DELETE_ALL_LOCATION') IS NOT NULL
            DROP PROCEDURE DELETE_ALL_LOCATION;
            GO

            CREATE PROCEDURE DELETE_ALL_LOCATION AS
            BEGIN
                BEGIN TRY

                    DELETE FROM LOCATION
                    RETURN @@ROWCOUNT

                END TRY

                BEGIN CATCH
                    BEGIN
                        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                            THROW 50000, @ERRORMESSAGE, 1
                    END
                END CATCH
            END

-- TASK 16 ADD_COMPLEX_SALE
    GO

    IF OBJECT_ID('ADD_COMPLEX_SALE') IS NOT NULL
    DROP PROCEDURE ADD_COMPLEX_SALE
    GO

    CREATE PROCEDURE ADD_COMPLEX_SALE @PCUSTID INT, @PPRODID INT, @PQTY INT, @PDATE NVARCHAR(8) AS
    BEGIN
        BEGIN TRY
            DECLARE @STATUS NVARCHAR(7)
            SELECT @STATUS = STATUS FROM CUSTOMER WHERE @PCUSTID = CUSTID;
            IF @PQTY < 1 OR @PQTY > 999
                THROW 50230, 'Sale Quantity outside valid range', 1;

            DECLARE @CONVERTED_DATE DATE;
            BEGIN TRY
                SET @CONVERTED_DATE = CONVERT(DATE, @PDATE, 112);
            END TRY
            BEGIN CATCH
                THROW 50250, 'Date not valid', 1;
            END CATCH 
            IF (@STATUS != 'OK')
                THROW 50240, 'Customer status is not OK', 1;
            ELSE IF @PCUSTID NOT IN (SELECT CUSTID FROM CUSTOMER)
                THROW 50260, 'Customer ID not found', 1
            ELSE IF @PPRODID NOT IN (SELECT PRODID FROM PRODUCT)
                THROW 50270, 'Product ID not found', 1
                
            DECLARE @UNITPRICE MONEY
            SELECT @UNITPRICE = SELLING_PRICE FROM PRODUCT WHERE PRODID = @PPRODID
            

            INSERT INTO SALE(SALEID, CUSTID, PRODID, QTY, PRICE, SALEDATE)
            VALUES (NEXT VALUE FOR SALE_SEQ, @PCUSTID, @PPRODID, @PQTY, @UNITPRICE ,@CONVERTED_DATE)

            SELECT NEXT VALUE FOR SALE_SEQ;

            UPDATE C
                SET C.SALES_YTD = (@PQTY * P.SELLING_PRICE)
            FROM CUSTOMER C
                INNER JOIN PRODUCT P
                    ON P.SALES_YTD = C.SALES_YTD

            UPDATE P
                SET P.SALES_YTD = (@PQTY * P.SELLING_PRICE)
            FROM PRODUCT P
            
        END TRY

        BEGIN CATCH
            IF ERROR_NUMBER() = 50240
                THROW;
            ELSE IF ERROR_NUMBER() = 50230
                THROW;
            ELSE IF ERROR_NUMBER() = 50250
                THROW;
            ELSE IF ERROR_NUMBER() = 50260
                THROW;
            ELSE IF ERROR_NUMBER() = 50270
                THROW;
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                        THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
    END

-- TASK 17 - GET_ALLSALES
    GO

    IF OBJECT_ID('GET_ALLSALES') IS NOT NULL
    DROP PROCEDURE GET_ALLSALES
    GO

    CREATE PROCEDURE GET_ALLSALES @POUTCUR CURSOR VARYING OUT AS
    BEGIN
        BEGIN TRY
            SET @POUTCUR = CURSOR FOR SELECT * FROM SALE;
            OPEN @POUTCUR;
        END TRY

        BEGIN CATCH
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

-- TASK 18 - COUNT_PRODUCT_SALES
    GO

    IF OBJECT_ID('COUNT_PRODUCT_SALES') IS NOT NULL
    DROP PROCEDURE COUNT_PRODUCT_SALES
    GO

    CREATE PROCEDURE COUNT_PRODUCT_SALES @PDAYS INT AS
    BEGIN
        BEGIN TRY
            SELECT COUNT(SALEDATE) FROM SALE 
                WHERE @PDAYS > DATEDIFF(DAY, SALEDATE, GETDATE());
            

        END TRY

        BEGIN CATCH
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
            END
        END CATCH
    END

/*
-- TESTING

    -- Task 1 TESTS
        EXEC ADD_CUSTOMER @pcustid = 1, @pcustname = 'testdude1';
        EXEC ADD_CUSTOMER @pcustid = 2, @pcustname = 'testdude2';

        -- EXCEPTION - Customer ID Out of range
        EXEC ADD_CUSTOMER @pcustid = 500, @pcustname = 'testdude3';


    -- Task 2 TESTS
        EXEC DELETE_ALL_CUSTOMERS;

    -- Task 3 TESTS
        EXEC ADD_PRODUCT @pprodid = 1000, @pprodname = 'Bill', @pprice = 10
        EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'Bob', @pprice = 10

        -- EXCEPTION - Product ID Out of range
        EXEC ADD_PRODUCT @pprodid = 2501, @pprodname = 'Bob', @pprice = 10
        -- EXCEPTION - Price Out of range
        EXEC ADD_PRODUCT @pprodid = 1001, @pprodname = 'Brad', @pprice = 10000

    -- Task 4 TESTS
        EXEC DELETE_ALL_PRODUCTS;

    -- TASK 5 TESTS
        BEGIN
            DECLARE @RETURNSTRING NVARCHAR(1000) = 'Original value';

            EXEC GET_CUSTOMER_STRING @PCUSTID = 1, @PRETURNSTRING = @RETURNSTRING OUT

        END

        -- EXCEPTION - Customer ID not found
        BEGIN
            DECLARE @RETURNSTRING NVARCHAR(1000) = 'Original value';

            EXEC GET_CUSTOMER_STRING @PCUSTID = 3, @PRETURNSTRING = @RETURNSTRING OUT

        END

    -- TASK 6 TESTS
        EXEC UPD_CUST_SALESYTD @PCUSTID = 1, @PAMT = 10;
        EXEC UPD_CUST_SALESYTD @PCUSTID = 2, @PAMT = 10;

        -- EXCEPTION - Customer ID not found
        EXEC UPD_CUST_SALESYTD @PCUSTID = 3, @PAMT = 10;
        -- EXCEPTION - Amount out of range
        EXEC UPD_CUST_SALESYTD @PCUSTID = 1, @PAMT = 1000;

    -- TASK 7 TESTS
        BEGIN
            DECLARE @RETURNSTRING NVARCHAR(1000) = 'Original value';

            EXEC GET_PROD_STRING @PPRODID = 1000, @PRETURNSTRING = @RETURNSTRING OUT

        END

        -- EXCEPTION - Product ID not found
        BEGIN
            DECLARE @RETURNSTRING NVARCHAR(1000) = 'Original value';

            EXEC GET_PROD_STRING @PPRODID = 1001, @PRETURNSTRING = @RETURNSTRING OUT

        END

    -- TASK 8 TESTS
        EXEC UPD_PROD_SALESYTD @PPRODID = 1000, @PAMT = 500;
        EXEC UPD_PROD_SALESYTD @PPRODID = 1001, @PAMT = 500;

        -- EXCEPTION - Product ID not found
        EXEC UPD_PROD_SALESYTD @PPRODID = 1003, @PAMT = 500;
        -- EXCEPTION - Amount out of range
        EXEC UPD_PROD_SALESYTD @PPRODID = 1000, @PAMT = 1000;

    -- TASK 9 TESTS
        EXEC UPD_CUSTOMER_STATUS @PCUSTID = 1, @PSTATUS = 'OK';
        EXEC UPD_CUSTOMER_STATUS @PCUSTID = 2, @PSTATUS = 'SUSPEND';

        -- EXCEPTION - Customer ID not found
        EXEC UPD_CUSTOMER_STATUS @PCUSTID = 3, @PSTATUS = 'OK';
        -- EXCEPTION - Invalid Status, Not OK or SUSPEND
        EXEC UPD_CUSTOMER_STATUS @PCUSTID = 1, @PSTATUS = 'POO';

    -- TASK 10 TESTS
        EXEC ADD_SIMPLE_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 2;

        -- EXCEPTION - Invalid Customer status
        EXEC ADD_SIMPLE_SALE @PCUSTID = 2, @PPRODID = 1000, @PQTY = 2;
        -- EXCEPTION - Sale quantity out of range
        EXEC ADD_SIMPLE_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 1000;
        -- EXCEPTION - Customer ID not found
        EXEC ADD_SIMPLE_SALE @PCUSTID = 3, @PPRODID = 1000, @PQTY = 2;
        -- EXCEPTION - Product ID not found
        EXEC ADD_SIMPLE_SALE @PCUSTID = 1, @PPRODID = 1003, @PQTY = 2;
    
    -- TASK 11 TESTS
        EXEC SUM_CUSTOMER_SALESYTD;

    -- TASK 12 TESTS
        EXEC SUM_PRODUCT_SALESYTD;

    -- TASK 13 TESTS
        BEGIN
            DECLARE @MYCURSOR CURSOR, @ID INT, @NAME NVARCHAR(100), @SYTD MONEY, @STATUS NVARCHAR(7);

            EXEC GET_ALL_CUSTOMERS @POUTCUR = @MYCURSOR OUT;
            FETCH NEXT FROM @MYCURSOR INTO @ID, @NAME, @SYTD, @STATUS;
            WHILE (@@FETCH_STATUS = 0)
                BEGIN
                    PRINT(CONCAT(@ID, ' ', @NAME, ' ', @SYTD, ' ', @STATUS))
                    FETCH NEXT FROM @MYCURSOR INTO @ID, @NAME, @SYTD, @STATUS;
                END
            CLOSE @MYCURSOR;
            DEALLOCATE @MYCURSOR;
        END

    -- TASK 14 TESTS
        BEGIN
            DECLARE @MYCURSOR CURSOR, @ID INT, @NAME NVARCHAR(100), @PRICE MONEY, @SYTD MONEY;
            EXEC GET_ALL_PRODUCTS @POUTCUR = @MYCURSOR OUT;
            FETCH NEXT FROM @MYCURSOR INTO @ID, @NAME, @PRICE, @SYTD;
            WHILE (@@FETCH_STATUS = 0)
                BEGIN
                    PRINT(CONCAT(@ID, ' ', @NAME, ' ', @PRICE, ' ', @SYTD))
                    FETCH NEXT FROM @MYCURSOR INTO @ID, @NAME, @PRICE, @SYTD;
                END
            CLOSE @MYCURSOR;
            DEALLOCATE @MYCURSOR;
        END

    -- TASK 15 TESTS
        EXEC ADD_LOCATION @PLOCCODE = 'POO12', @PMINQTY = 10, @PMAXQTY = 20;
        
        -- EXCEPTION - Duplicate primary key
        EXEC ADD_LOCATION @PLOCCODE = 'POO12', @PMINQTY = 10, @PMAXQTY = 20;
        -- EXCEPTION - Location Code length invalid
        EXEC ADD_LOCATION @PLOCCODE = 'POOP12', @PMINQTY = 10, @PMAXQTY = 20;
        EXEC ADD_LOCATION @PLOCCODE = 'POO1', @PMINQTY = 10, @PMAXQTY = 20;
        -- EXCEPTION - Minimum Qty out of range
        EXEC ADD_LOCATION @PLOCCODE = 'PEE12', @PMINQTY = 1000, @PMAXQTY = 20;
        EXEC ADD_LOCATION @PLOCCODE = 'PEE12', @PMINQTY = -1, @PMAXQTY = 20;
        -- EXCEPTION - Maximum Qty out of range
        EXEC ADD_LOCATION @PLOCCODE = 'PEE12', @PMINQTY = 10, @PMAXQTY = 1000;
        -- EXCEPTION -Minimum Qty larger than Maximum Qty
        EXEC ADD_LOCATION @PLOCCODE = 'PEE12', @PMINQTY = 20, @PMAXQTY = 10;

        -- DELETE_ALL_LOCATION
        EXEC DELETE_ALL_LOCATION
    -- TASK 16 TEST
        EXEC ADD_COMPLEX_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 10, @PDATE = '20211015';

        -- EXCEPTION - Sale Quantity Out of Range
        EXEC ADD_COMPLEX_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 0, @PDATE = '20211015';
        EXEC ADD_COMPLEX_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 1000, @PDATE = '20211015';
        -- EXCEPTION - Invalid customer status
        EXEC ADD_COMPLEX_SALE @PCUSTID = 2, @PPRODID = 1000, @PQTY = 10, @PDATE = '20211015';
        -- EXCEPTION - Invalid sale date
        EXEC ADD_COMPLEX_SALE @PCUSTID = 1, @PPRODID = 1000, @PQTY = 10, @PDATE = '2021-10-15';
        -- EXCEPTION - Customer ID not found
        EXEC ADD_COMPLEX_SALE @PCUSTID = 3, @PPRODID = 1000, @PQTY = 10, @PDATE = '20211015';
        -- EXCEPTION - Product ID not found
        EXEC ADD_COMPLEX_SALE @PCUSTID = 1, @PPRODID = 2000, @PQTY = 10, @PDATE = '20211015';

    -- TASK 17 TESTS
        BEGIN
            DECLARE @MYCURSOR CURSOR, @SID BIGINT, @CID INT, @PID INT, @QTY INT, @PRICE MONEY, @SDATE DATE;
            EXEC GET_ALLSALES @POUTCUR = @MYCURSOR OUT;
            FETCH NEXT FROM @MYCURSOR INTO @SID, @CID, @PID, @QTY, @PRICE, @SDATE;
            WHILE (@@FETCH_STATUS = 0)
                BEGIN
                    PRINT(CONCAT(@SID, ' ', @CID, ' ', @PID, ' ', @QTY, ' ', @PRICE, ' ', @SDATE))
                    FETCH NEXT FROM @MYCURSOR INTO @SID, @CID, @PID, @QTY, @PRICE, @SDATE;
                END
            CLOSE @MYCURSOR;
            DEALLOCATE @MYCURSOR;
        END

    -- TASK 18 TESTS
        EXEC COUNT_PRODUCT_SALES @PDAYS = 100
*/
select * from customer;
select * from PRODUCT;
SELECT * FROM SALE;
SELECT * FROM [LOCATION];
