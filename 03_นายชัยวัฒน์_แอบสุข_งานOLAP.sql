CREATE PROCEDURE Datamart
AS
BEGIN
	--D_Shop
	IF OBJECT_ID('dbo.D_Shop','U') IS NOT NULL DROP TABLE dbo.D_Shop;
	CREATE TABLE [dbo].[D_Shop](
		[Shop_id] [nvarchar](4) NOT NULL,
		[Shop_name] [nvarchar](50) NULL,
	CONSTRAINT [PK_D_Shop] PRIMARY KEY CLUSTERED
	(
		[Shop_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	insert into D_Shop
	select Shop_No,SHop_Name from DW_Shop

	--D_Year
	IF OBJECT_ID('dbo.D_Year','U') IS NOT NULL DROP TABLE dbo.D_Year;
	CREATE TABLE [dbo].[D_Year](
		[Year_Id] [nvarchar](20) NOT NULL,
		[Year] [nvarchar](20) NULL,
	CONSTRAINT [PK_D_Year] PRIMARY KEY CLUSTERED 
	(
		[Year_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)	ON [PRIMARY]
	insert into D_Year
	values ('Y001',2021),('Y002',2022),('Y003',2023)

	--D_Product
	IF OBJECT_ID('dbo.D_Product','U') IS NOT NULL DROP TABLE dbo.D_Product;
	CREATE TABLE [dbo].[D_Product](
		[Product_id] [nvarchar](20) NOT NULL,
		[Product_Name] [nvarchar](40) NULL,
	CONSTRAINT [PK_D_Product] PRIMARY KEY CLUSTERED
	(
		[Product_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	insert into D_Product
	Select Product_Id,(Product_NameEng+' ('+Product_NameThai+')') as Product_Name From DW_Product

	--D_Employee
	IF OBJECT_ID('dbo.D_Employee','U') IS NOT NULL DROP TABLE dbo.D_Employee;
	CREATE TABLE [dbo].[D_Employee](
		[Emp_id] [nvarchar](20) NOT NULL,
		[Emp_Name] [nvarchar](50) NULL,
		[Emp_Surname] [nvarchar](50) NULL,
	CONSTRAINT [PK_D_Employee] PRIMARY KEY CLUSTERED
	(
		[Emp_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

INSERT INTO D_Employee (Emp_id, Emp_Name, Emp_Surname)
SELECT
    Emp_No,
    LEFT(Emp_Name, CHARINDEX(' ', Emp_Name) - 1)      AS Emp_Name,
    SUBSTRING(Emp_Name, CHARINDEX(' ', Emp_Name) + 1, LEN(Emp_Name)) AS Emp_Surname
FROM DW_Employee;

	--F_Sales
	IF OBJECT_ID('dbo.F_Sales','U') IS NOT NULL DROP TABLE dbo.F_Sales;
	CREATE TABLE [dbo].[F_Sales](
		[Shop_id] [nvarchar](20) NOT NULL,
		[Product_id] [nvarchar](20) NOT NULL,
		[Year_id] [nvarchar](20) NOT NULL,
		[Emp_id] [nvarchar](20) NOT NULL,
		[SaleQty] [int] NULL,
		[Sales_Amount] [float] NULL,
		[Tot_Commission] [float](20) NULL,
	CONSTRAINT [PK_F_Sales] PRIMARY KEY CLUSTERED 
	(
		[Shop_id] ASC,
		[Product_id] ASC,
		[Year_id] ASC,
		[Emp_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

INSERT INTO F_Sales
SELECT 
    MainSales.Shop_No,
    MainSales.Product_Id,
    MainSales.Year_id,
    MainSales.Emp_No,
    MainSales.SaleQty,
    MainSales.Sales_Amount,
    -- นำค่า Commission รวมรายปีของพนักงานมาเฉลี่ยลงตามสัดส่วนสินค้า หรือดึงมาแสดง
    CommData.Yearly_Comm / MainSales.Total_Items_Per_Emp AS Tot_Commission
FROM (
    -- ก้อนที่ 1: คำนวณยอดขายสินค้าปกติ
    SELECT
        S.Shop_No,
        P.Product_Id,
        CAST(YEAR(SA.SDate) AS NVARCHAR(20)) AS Year_id,
        E.Emp_No,
        SUM(SD.Sale_Qty) AS SaleQty,
        SUM(SD.Total_Amt) AS Sales_Amount,
        -- นับจำนวนรายการสินค้าทั้งหมดของพนักงานคนนี้ในปีนั้น เพื่อใช้หารเฉลี่ย Commission
        COUNT(*) OVER(PARTITION BY E.Emp_No, YEAR(SA.SDate)) AS Total_Items_Per_Emp
    FROM DW_Sales SA
    JOIN DW_Sales_Detail SD ON SA.Receipt_No = SD.Receipt_No
    JOIN DW_Shop S          ON SA.Shop_No    = S.Shop_No
    JOIN DW_Product P       ON SD.Product_Id = P.Product_Id
    JOIN DW_Employee E      ON SA.Emp_No     = E.Emp_No
    GROUP BY S.Shop_No, P.Product_Id, YEAR(SA.SDate), E.Emp_No
) AS MainSales
JOIN (
    -- ก้อนที่ 2: คำนวณ Commission รวมรายปีต่อคน (จากตาราง DW_Sales เพื่อให้ยอดตรงกับกราฟ 2)
    SELECT 
        Emp_No, 
        YEAR(SDate) AS SalesYear, 
        SUM(Commission) AS Yearly_Comm
    FROM DW_Sales
    GROUP BY Emp_No, YEAR(SDate)
) AS CommData ON MainSales.Emp_No = CommData.Emp_No AND MainSales.Year_id = CAST(CommData.SalesYear AS NVARCHAR(20));
END
GO
