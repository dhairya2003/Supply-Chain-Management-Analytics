Create database Supply_chain;
use supply_chain;

Create table dim_product(
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
	Sub_Category VARCHAR(50),
    Unit_Cost DECIMAL(10,2),
    Unit_Price DECIMAL(10,2),
    Primary_Supplier_ID VARCHAR(50));
    
SET GLOBAL Local_infile=1;


LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain dim product.csv'
INTO TABLE dim_product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Create table dim_supplier(
    Supplier_ID VARCHAR(50),
    Supplier_Name VARCHAR(100),
    Supplier_Country VARCHAR(50),
	Supplier_City VARCHAR(50),
    Supplier_Tier VARCHAR(50),
    Reliability_Score DECIMAL(10,2));
 
LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain Dim Supplier.csv'
INTO TABLE dim_supplier
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


Create table dim_warehouse(
    Wearhouse_ID VARCHAR(50),
    Wearhouse_City VARCHAR(50),
    Wearhouse_Country VARCHAR(50),
	Wearhouse_Region VARCHAR(50),
    Capacity_Unit INT);

LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain Dim Warehouse.csv'
INTO TABLE dim_warehouse
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;



Create table dim_customer(
    Customer_ID VARCHAR(50),
    Customer_Region VARCHAR(50),
	Customer_Country VARCHAR(50),
    Customer_City VARCHAR(50),
	Customer_Segment VARCHAR(50));
    

LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain Dim Customer.csv'
INTO TABLE dim_customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


Create table fact_orders(
    Order_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Supplier_ID VARCHAR(50),
    Wearhouse_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Promised_Delivery_Date DATE,
    Actual_Delivery_Date DATE,
    Ship_Mode VARCHAR(50),
    Carrier VARCHAR(50),
    Order_Quantity INT,
    Shipped_Quantity INT,
    Unit_Price DECIMAL(10,2),
    Unit_Cost DECIMAL(10,2),
    Revenue DECIMAL(10,2),
    COGS DECIMAL(10,2),
    Shipping_Cost DECIMAL(10,2),
    Processing_Day INT,
    Transit_Day INT,
    Delay_Day INT,
    Delivery_Status VARCHAR(50),
    Fill_Rate_Pct DECIMAL(10,2));
    

LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain Fact Orders.csv'
INTO TABLE fact_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


Create table fact_inventory(
    Product_ID VARCHAR(50),
    Wearhouse_ID VARCHAR(50),
    Snapshot_Date DATE,
    Stock_On_Hand INT,
    Recorder_Level INT,
    Safety_Stock INT,
    Units_Recieved INT,
    Units_Shipped INT,
    Days_Of_Supply DECIMAL(10,2),
    Stockout_Flag INT);
   


LOAD DATA LOCAL INFILE 'C:/Temp/Supply chain dataset SQL/Supply Chain Fact Inventory.csv'
INTO TABLE fact_inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;




# 1. Order & Sales KPIs

# Total Orders ---------
SELECT COUNT(Order_ID) AS Total_Orders
FROM fact_orders;

# Total Sales Revenue --------
SELECT CONCAT(ROUND(SUM(Unit_Price * Order_Quantity)/1000000,2),'M') AS Total_Sales_Revenue
FROM fact_orders;


#Average Order Value (AOV)------
SELECT CONCAT(ROUND(SUM(Unit_Price * Order_Quantity) / COUNT(Order_ID)/1000,2),'K') AS Average_Order_Value
FROM fact_orders;




# Orders by Region ------
SELECT COALESCE(c.Customer_Region, 'Grand Total') AS Customer_Region,
COUNT(f.Order_Id) AS Count_of_Orders
FROM fact_orders f
JOIN dim_customer c ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Region WITH ROLLUP
ORDER BY 
CASE WHEN c.Customer_Region IS NULL THEN 1 ELSE 0 END,
Count_of_Orders DESC;


# 2. Inventory & Stock KPIs

# Stock on Hand -----
SELECT CONCAT(ROUND(SUM(Stock_On_Hand)/1000000,2),'M') AS Total_Stock
FROM fact_inventory;


# Reorder Status-----
SELECT ROUND(SUM(CASE WHEN Stock_On_Hand < Recorder_Level THEN 1
ELSE 0 END) * 100 / COUNT(*),2) AS Reorder_Percentage
FROM fact_inventory;



#  Average Lead Time --------
SELECT CONCAT(ROUND(AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)), 2),' Days') AS Average_Lead_Time
FROM fact_orders;

# Inventory Turnover Ratio -------
SELECT CONCAT(ROUND(((SELECT SUM(COGS) FROM fact_orders)/
(SELECT AVG(Stock_On_Hand) FROM fact_inventory))/1000,2),'K') AS Inventory_Turnover_Ratio;



# 3. Procurement & Cost KPIs-------

# Procurement Cost ------
SELECT CONCAT(ROUND(SUM(COGS) / 1000000, 2),'M') AS Procurement_Cost
FROM fact_orders;


# Transportation Cost --------
SELECT CONCAT(ROUND(SUM(Shipping_Cost) / 1000000, 2),'M') AS Procurement_Cost
FROM fact_orders;

# Total Supply Chain Cost ------
SELECT CONCAT(ROUND((SUM(COGS) + SUM(Shipping_Cost)) / 1000000, 2),'M') 
AS Total_Supply_Chain_Cost
FROM fact_orders;

# Cost per Unit --------
SELECT ROUND(SUM(COGS) / SUM(Order_Quantity),2) AS Cost_Per_Unit
FROM fact_orders;


# 4. Logistics & Delivery KPIs

# On-Time Delivery % ----
SELECT CONCAT(ROUND(100 * SUM(CASE WHEN Delivery_Status = 'On-Time' THEN 1 ELSE 0 END) / COUNT(*),2),'%')
AS On_Time_Delivery_Percentage
FROM fact_orders;

# Average Delay (days)  -----
SELECT CONCAT(ROUND(AVG(Delay_Day), 2), ' Days') AS Average_Delay_Days
FROM fact_orders;


# Orders by Ship Mode ------
SELECT IFNULL(Ship_Mode, 'Grand Total') AS Ship_Mode,COUNT(*) AS Total_Orders
FROM fact_orders
GROUP BY Ship_Mode WITH ROLLUP;


# Transport Mode Utilization ------
SELECT COALESCE(Ship_Mode, 'Grand Total') AS Ship_Mode,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_orders), 2), '%') AS Transport_Mode_Utilization_Pct
FROM fact_orders
GROUP BY Ship_Mode WITH ROLLUP
ORDER BY 
    CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END,
    COUNT(*) DESC;

# 5. Demand & Fulfillment KPIs

# Forecast Accuracy -------
SELECT 
  COALESCE(Order_Month, 'Grand Total') AS Order_Month,
  CONCAT(ROUND(SUM(Sum_of_Order_Quantity) / 1000, 2), 'K') AS Sum_of_Order_Quantity,
  CONCAT(ROUND(SUM(Sum_of_Shipped_Quantity) / 1000, 2), 'K') AS Sum_of_Shipped_Quantity
FROM (
  SELECT 
    DATE_FORMAT(Order_Date, '%b') AS Order_Month,
    MONTH(Order_Date) AS Month_Num,
    SUM(Order_Quantity) AS Sum_of_Order_Quantity,
    SUM(Shipped_Quantity) AS Sum_of_Shipped_Quantity
  FROM fact_orders
  GROUP BY DATE_FORMAT(Order_Date, '%b'), MONTH(Order_Date)
) AS monthly_data
GROUP BY Order_Month WITH ROLLUP
ORDER BY 
  CASE WHEN Order_Month IS NULL THEN 1 ELSE 0 END,
  FIELD(Order_Month, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');



# Fill Rate -----
SELECT CONCAT(ROUND(AVG(Fill_Rate_Pct), 2),'%') AS Fill_Rate
FROM fact_orders;


# Backorder Rate -----
SELECT CONCAT(ROUND(100.0 * (SUM(Order_Quantity) - SUM(Shipped_Quantity)) 
/SUM(Order_Quantity), 2),'%') AS Backorder_Rate
FROM fact_orders;

# Demand vs Actual Sales Trend ------
SELECT 
  COALESCE(Order_Month, 'Grand Total') AS Month,
  CONCAT(ROUND(SUM(Sum_Units_Recieved) / 1000, 2), 'K') AS Forecast_Demand,
  CONCAT(ROUND(SUM(Sum_Units_Shipped) / 1000, 2), 'K') AS Actual_Demand
FROM (
  SELECT 
    DATE_FORMAT(Snapshot_Date, '%b') AS Order_Month,
    MONTH(Snapshot_Date) AS Month_Num,
    SUM(Units_Recieved) AS Sum_Units_Recieved,
    SUM(Units_Shipped) AS Sum_Units_Shipped
  FROM fact_inventory
  GROUP BY DATE_FORMAT(Snapshot_Date, '%b'), MONTH(Snapshot_Date)
) AS monthly_data
GROUP BY Order_Month WITH ROLLUP
ORDER BY 
  CASE WHEN Order_Month IS NULL THEN 1 ELSE 0 END,
  FIELD(Order_Month, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');


#  CREATE TABLES

Create table Total_Orders AS SELECT COUNT(Order_ID) AS Total_Orders
FROM fact_orders;


Create table Total_Sales_Revenue AS SELECT CONCAT(ROUND(SUM(Unit_Price * Order_Quantity)/1000000,2),'M') AS Total_Sales_Revenue
FROM fact_orders;



Create table AOV AS SELECT CONCAT(ROUND(SUM(Unit_Price * Order_Quantity) / COUNT(Order_ID)/1000,2),'K') AS Average_Order_Value
FROM fact_orders;



Create table Orders_By_Region AS SELECT COALESCE(c.Customer_Region, 'Grand Total') AS Customer_Region,
COUNT(f.Order_Id) AS Count_of_Orders
FROM fact_orders f
JOIN dim_customer c ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Region WITH ROLLUP
ORDER BY 
CASE WHEN c.Customer_Region IS NULL THEN 1 ELSE 0 END,
Count_of_Orders DESC;


Create table Stock_On_Hand AS SELECT CONCAT(ROUND(SUM(Stock_On_Hand)/1000000,2),'M') AS Total_Stock
FROM fact_inventory;


Create table Reorder_Status AS SELECT ROUND(SUM(CASE WHEN Stock_On_Hand < Recorder_Level THEN 1
ELSE 0 END) * 100 / COUNT(*),2) AS Reorder_Percentage
FROM fact_inventory;


Create table Average_Lead_Time AS SELECT CONCAT(ROUND(AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)), 2),' Days') AS Average_Lead_Time
FROM fact_orders;


Create table Inventory_Turnover_Ratio AS SELECT CONCAT(ROUND(((SELECT SUM(COGS) FROM fact_orders)/
(SELECT AVG(Stock_On_Hand) FROM fact_inventory))/1000,2),'K') AS Inventory_Turnover_Ratio;


Create table Procurement_Cost AS SELECT CONCAT(ROUND(SUM(COGS) / 1000000, 2),'M') AS Procurement_Cost
FROM fact_orders;


Create table Transportation_Cost AS SELECT CONCAT(ROUND(SUM(Shipping_Cost) / 1000000, 2),'M') AS Transportation_Cost
FROM fact_orders;

Create table Total_Supply_Chain_Cost AS SELECT CONCAT(ROUND((SUM(COGS) + SUM(Shipping_Cost)) / 1000000, 2),'M') 
AS Total_Supply_Chain_Cost
FROM fact_orders;

Create table Cost_per_Unit AS SELECT ROUND(SUM(COGS) / SUM(Order_Quantity),2) AS Cost_Per_Unit
FROM fact_orders;


Create table On_Time_Delivery_Pct AS SELECT CONCAT(ROUND(100 * SUM(CASE WHEN Delivery_Status = 'On-Time' THEN 1 ELSE 0 END) / COUNT(*),2),'%')
AS On_Time_Delivery_Percentage
FROM fact_orders;

Create table Average_Delay AS SELECT CONCAT(ROUND(AVG(Delay_Day), 2), ' Days') AS Average_Delay_Days
FROM fact_orders;


Create table Orders_By_Ship_Mode AS SELECT IFNULL(Ship_Mode, 'Grand Total') AS Ship_Mode,COUNT(*) AS Total_Orders
FROM fact_orders
GROUP BY Ship_Mode WITH ROLLUP;


Create table Transport_Mode_Utilization AS
SELECT COALESCE(Ship_Mode, 'Grand Total') AS Ship_Mode,
CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_orders), 2), '%') AS Transport_Mode_Utilization_Pct
FROM fact_orders
GROUP BY Ship_Mode WITH ROLLUP
ORDER BY 
    CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END,
    COUNT(*) DESC;


Create table Forecast_Accuracy AS SELECT 
  COALESCE(Order_Month, 'Grand Total') AS Order_Month,
  CONCAT(ROUND(SUM(Sum_of_Order_Quantity) / 1000, 2), 'K') AS Sum_of_Order_Quantity,
  CONCAT(ROUND(SUM(Sum_of_Shipped_Quantity) / 1000, 2), 'K') AS Sum_of_Shipped_Quantity
FROM (
  SELECT 
    DATE_FORMAT(Order_Date, '%b') AS Order_Month,
    MONTH(Order_Date) AS Month_Num,
    SUM(Order_Quantity) AS Sum_of_Order_Quantity,
    SUM(Shipped_Quantity) AS Sum_of_Shipped_Quantity
  FROM fact_orders
  GROUP BY DATE_FORMAT(Order_Date, '%b'), MONTH(Order_Date)
) AS monthly_data
GROUP BY Order_Month WITH ROLLUP
ORDER BY 
  CASE WHEN Order_Month IS NULL THEN 1 ELSE 0 END,
  FIELD(Order_Month, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');



Create table Fill_Rate AS SELECT CONCAT(ROUND(AVG(Fill_Rate_Pct), 2),'%') AS Fill_Rate
FROM fact_orders;


Create table Backorder_Rate AS SELECT CONCAT(ROUND(100.0 * (SUM(Order_Quantity) - SUM(Shipped_Quantity)) 
/SUM(Order_Quantity), 2),'%') AS Backorder_Rate
FROM fact_orders;

Create table Demand_vs_Actual_Sales_Trend AS SELECT 
  COALESCE(Order_Month, 'Grand Total') AS Month,
  CONCAT(ROUND(SUM(Sum_Units_Recieved) / 1000, 2), 'K') AS Forecast_Demand,
  CONCAT(ROUND(SUM(Sum_Units_Shipped) / 1000, 2), 'K') AS Actual_Demand
FROM (
  SELECT 
    DATE_FORMAT(Snapshot_Date, '%b') AS Order_Month,
    MONTH(Snapshot_Date) AS Month_Num,
    SUM(Units_Recieved) AS Sum_Units_Recieved,
    SUM(Units_Shipped) AS Sum_Units_Shipped
  FROM fact_inventory
  GROUP BY DATE_FORMAT(Snapshot_Date, '%b'), MONTH(Snapshot_Date)
) AS monthly_data
GROUP BY Order_Month WITH ROLLUP
ORDER BY 
  CASE WHEN Order_Month IS NULL THEN 1 ELSE 0 END,
  FIELD(Order_Month, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

SELECT * from Total_Orders;
SELECT * from Total_Sales_Revenue;
SELECT * from AOV;
SELECT * from Orders_By_Region;
SELECT * from Stock_On_Hand;
SELECT * from Reorder_Status;
SELECT * from Average_Lead_Time;
SELECT * from Inventory_Turnover_Ratio;
SELECT * from Procurement_Cost;
SELECT * from Transportation_Cost;
SELECT * from Total_Supply_Chain_Cost;
SELECT * from Cost_Per_Unit;
SELECT * from On_Time_Delivery_Pct;
SELECT * from Average_Delay;
SELECT * from Orders_By_Ship_Mode;
SELECT * from Transport_Mode_Utilization;
SELECT * from Forecast_Accuracy;
SELECT * from Fill_Rate;
SELECT * from Backorder_Rate;
SELECT * from Demand_vs_Actual_Sales_Trend;




