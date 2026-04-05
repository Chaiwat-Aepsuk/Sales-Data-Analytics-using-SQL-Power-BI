# Data Analytics & Visualization using SQL Server
# การวิเคราะห์และแสดงผลข้อมูลโดยใช้ SQL Server
สำหรับแสดงผลงานระหว่างการเรียนวิชา Business Intelligence in Data Science
Project นี้เป็นการนำข้อมูลร้านค้าพนักงานและสินค้าต่างๆ มาทำการวิเคระห์เพื่อตอบโจทย์ความต้องการของลูกค้า 

[Dash_01](https://github.com/Chaiwat-Aepsuk/Sales-Data-Analytics-using-SQL-Power-BI/blob/bb1cac4d031d97b4dd28cf1b2fdf51c3bb22f148/Dash_01.pbix) เป็นการวิเคราะห์ยอดขายและผลงานพนักงาน

[Dash_02](https://github.com/Chaiwat-Aepsuk/Sales-Data-Analytics-using-SQL-Power-BI/blob/bb1cac4d031d97b4dd28cf1b2fdf51c3bb22f148/Dash02.pbix) เป็นการแสดง 10 อันดับสินค้าที่ขายได้ดี กับขายได้ไม่ดี และทำนายยอดขายในอนาคต ของแต่ละสาขาหรือสินค้าต่อละชิ้นในอีก 5 ปี
# ขั้นตอนในการทำงาน
1.ดึงข้อมูลจาก Data base มาสร้าง Data Warehouse ชื่อ Datamart 
2.ทำการตรวจสอบตารางว่าข้อมูลหรือตารางมีอยู่หรือไม่ และสร้าง Dimension Tables คือ 
- D_Shop
- D_Year
- D_Product
- D_Employee
3.Extract + Load data จาก Data base และทำการ Transformation Data
4.สร้าง Fact Table (F_Sales) เพื่อทำการวิเคราห์สิ่งที่เราต้องการด้วยการ JOIN และคำสั่งอื่นๆ เช่น
- SaleQty (จำนวนชิ้น)
- Sales_Amount (จำนวนยอดขาย)
- Tot_Commission (ค่า Commission)
5.Transfer data to Power BI เพื่อแสดง Dashboard

# 📗 ผลสรุป (Summarize)
ระบุได้ว่า:
- ร้านไหนขายดี / ไม่ดี
- สินค้าขายดีที่สุด
- พนักงานที่ทำยอดขายสูง
- แนวโน้มยอดขายรายปี
- ข้อมูลพร้อมใช้งานสำหรับสร้าง Dashboard ใน Power BI

# 🚀 คุณค่าของโปรเจกต์
- เปลี่ยนข้อมูลดิบ → เป็นข้อมูลเชิงวิเคราะห์ (Insight)
- รองรับการตัดสินใจทางธุรกิจ (Business Decision Making)
- สร้างระบบวิเคราะห์แบบ End-to-End (SQL → Data Mart → Dashboard)

# 💡 สะท้อนคิด (Reflection)
- ผมได้เรียนรู้การใช้ SQL มากขึ้น ★★
- เรียนรู้การใช้งานฟังก์ชันต่างๆ ★★
- การสร้าง Dashboard ★★★★
