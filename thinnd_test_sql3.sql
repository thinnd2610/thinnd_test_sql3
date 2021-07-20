create database test3_sql
use test3_sql
go
create table Category
( CatID int primary key identity not null,
  CatName nvarchar(50) ,
  CatStatus bit
)
go
create table ManuFacturer
( 
ManID int primary key identity not null,
ManName nvarchar(50),
Website nvarchar(150),
Status bit  
)
go
create table Products
(
pID int primary key identity not null,
CatID int ,
CONSTRAINT fk_CatID
  FOREIGN KEY (CatID)
  REFERENCES Category (CatID),
ManID int ,
CONSTRAINT fk_ManID
  FOREIGN KEY (ManID)
  REFERENCES ManuFacturer (ManID),
pName nvarchar(50),
Quantity int ,
Price float,
pImage nvarchar(200)
)
go
----thêm dữ liệu----
insert into dbo.ManuFacturer values
('Nokia','https://www.thegioididong.com/dtdd-nokia',1),
('IBM','https://www.ibm.com/vn-en',1),
('DELL','https://fptshop.com.vn/may-tinh-xach-tay/dell',0)
insert into dbo.Category values
('Mobile',1),
('Laptop',0)
insert into dbo.Products values
(1,1,'Nokia 8998',10,350000,'n8989.jpg'),
(2,2,'Nokia Lumina 800',15,400000,'n8989.jpg'),
(2,1,'IBM Lenovo T410',30,350000,'n8989.jpg'),
(1,2,'IBM Thinkpad T444',50,350000,'n8989.jpg'),
(2,1,'Dell',40,350000,'n8989.jpg')
--2: Viêt cau lenh cap nhat thong tin gia cua san pham co ma la 1 tang len 10%
update Products
set Price = Price * 10
where CatID = 1
--3: Viết câu lênh select ra danh sách sản phẩm như sau
select p.pID as [ID],p.pName as [Product Name],p.Quantity as [Quantity],p.Price as [Price]
from Products p
--4.Tạo Index trên bảng product có tên P_index_pName
CREATE INDEX P_index_pName
ON products (pName);
--5.Tạo view vwProductInfo sao cho kết quả như sau
create VIEW vwProductInfo
as
select 
p.pName as [Product name],
c.CatName as [Category Name],
m.ManName as [Manufacturer Name],
p.Quantity as [Quantity],
p.Price as [Price]
from Products p , Category c,ManuFacturer m

where p.CatID=c.CatID
and
p.ManID = m.ManID
--6 tao thu thuc cap nhat san pham với tên pProductUpdate sao cho Số luongj không được nhỏ hơn 0
--Khi goi thủ tuc truyền vào 2 tham số là pID và Quantity
create proc pProductUpdate
(@pID int,
@quantity int)
as
begin
	if(@quantity>0)
	begin
	update Products
	set quantity=@quantity
	where @pID= pID
	end
	else
	begin
	print 'Khong duoc nho hon 0'
	end
end
exec pProductUpdate 5,5
--7: Tạo trigger trProductInsert thêm mới sản phẩm không cho phép chọn các Manufacturer có trạng thái khác 0
create Trigger trProductInsert
On dbo.Products 
For Insert
As
begin
	if(select  m.Status from ManuFacturer m ) = 0
	begin
	print N'Đã insert không thành công'
	rollback tran
	end
	else 
	begin
	print N'Insert thành công'
	end
end
