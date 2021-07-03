use demo2006;
-- 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
select orderdetail.orderId, sum(orderdetail.quantity*product.price) as total
from orderdetail, product
group by orderdetail.orderId;

-- 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select orderdetail.orderId, sum(orderdetail.quantity*product.price) as totalPrice
from orderdetail, product, demo2006.order
where orderdetail.productId = product.id
and month(demo2006.order.time) = 6
group by orderdetail.orderId;

-- 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007.
select customer.id, customer.name
from customer, demo2006.order
where customer.id = demo2006.order.customerId
-- and demo2006.order.time like '2006-06-20%';
and date(demo2006.order.time)= 2006/06/20;

-- 10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select product.id, product.name
from product, customer,demo2006.order,orderdetail
where customer.id = demo2006.order.customerId
and demo2006.order.id = orderdetail.orderId
and orderdetail.productid = product.id
and customer.name like 'Nguyen Van A'
and demo2006.order.time like '2006-10%';

-- 11. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select orderdetail.orderId
from orderdetail inner join product
on orderdetail.productId = product.id
and (product.name like 'Máy giặt' or product.name like 'Tủ lạnh')
group by orderdetail.orderid;
-- from orderdetail, product
-- where orderdetail.productId = product.id
-- and (product.name like 'Máy giặt' or product.name like 'Tủ lạnh');

-- 12. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select demo2006.order.id, product.id, product.name, orderdetail.quantity
from product
join orderdetail on product.id = orderdetail.productId
join demo2006.order on orderdetail.orderId = demo2006.order.id
where (product.name like 'Máy giặt' or product.name like 'tủ lạnh')
and orderdetail.quantity between 10 and 20;

-- 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
create view may_giat as
SELECT o.id, p.name, o.time, od.quantity
FROM orderDetail od, product p, demo206.order o
where od.productId = p.id 
and o.id = od.orderid 
and p.name like 'Máy Giặt%' 
and od.quantity >=10 
and od.quantity <=20;
create view tu_lanh as
SELECT o.id, p.name, o.time, od.quantity
FROM orderDetail od, product p, demo206.order o
where od.productId = p.id 
and o.id = od.orderid 
and p.name like 'Tủ lạnh%' 
and od.quantity >=10 
and od.quantity <=20;
select * from may_giat;
select tu_lanh.id from tu_lanh, may_giat where tu_lanh.id = may_giat.id;

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select product.id, product.name
from product, orderdetail
where product.id not in ( select productId from orderdetail)
group by product.id;

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
-- select product.id, product.name
-- from product inner join orderdetail
-- on product.id = orderdetail.productId
-- where orderdetail.orderId not in (select id from demo2006.order where year(demo2006.order.time) = 2006 )

select product.id, product.name
from product
join orderdetail on product.id = orderdetail.productId
join `order` on `order`.id = orderdetail.orderId
where year(`order`.time) = 2006
group by product.name;

select * from product
where product.id not in ( select product.id
from product
join orderdetail on product.id = orderdetail.productId
join `order` on `order`.id = orderdetail.orderId
where year(`order`.time) = 2006
group by product.name);

-- and orderdetail inner join demo2006.order
-- on orderdetail.orderId = demo2006.order.id
-- where year(demo2006.order.time) = 2006;
-- and product.id not in (select orderdetail.productId from orderdetail);


-- 17. In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm 2006.
select product.id, product.name
from product inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
where product.price > 300
and year(demo2006.order.time) = 2006
group by product.id;

-- 18. Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.
select demo2006.order.id
from product inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
where product.price > 200
group by demo2006.order.id;

-- 19. Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.

-- 21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.

create view test as select name from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
where year(demo2006.order.time) = 2006
group by product.name;
-- tạo view
select count(*) from test;

-- 22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
create view giatrihoadon as
select demo2006.order.id, sum(product.price*orderdetail.quantity) as giatri from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
group by demo2006.order.id; 

select max(giatrihoadon.giatri) as giatrilonnhat, min(giatrihoadon.giatri) as giatrinhonhat from giatrihoadon;

-- 23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
create view giatrihoadontheonam as
select demo2006.order.id, sum(product.price*orderdetail.quantity) as giatri, year(demo2006.order.time) as yearorder, count(demo2006.order.id) as ordercount
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
group by year(demo2006.order.time);

select giatrihoadontheonam.giatri/giatrihoadontheonam.ordercount as giatritrungbinh 
from giatrihoadontheonam
where giatrihoadontheonam.yearorder = 2006;

-- 24. Tính doanh thu bán hàng trong năm 2006.
select giatrihoadontheonam.giatri as doanhthu2006 
from giatrihoadontheonam
where giatrihoadontheonam.yearorder = 2006;

-- 25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
create view v25 as
select demo2006.order.id, sum(product.price*orderdetail.quantity) as giatri, year(demo2006.order.time) as yearorder
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
group by `order`.id; 

select max(v25.giatri) as max
from v25
where v25.yearorder = 2006;

-- 26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
create view giatrihoadonkhachhang2006 as
select customer.name, sum(product.price*orderdetail.quantity) as giatrihoadon from product 
inner join orderdetail on product.id = orderdetail.productId 
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
inner join customer on demo2006.order.customerId = customer.id
where year(demo2006.order.time) = 2006
group by customer.name;

select max(giatrihoadonkhachhang2006.giatrihoadon) as giatricaonhat from giatrihoadonkhachhang2006;

-- 27. In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).
select customer.id, customer.name, sum(orderdetail.quantity) as quantity from orderdetail
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
inner join customer on demo2006.order.customerId = customer.id
group by customer.id
order by quantity desc
limit 3;

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
create view top3mucgiacaonhat as 
select product.price
from product
group by product.price
order by product.price desc
limit 3;
select product.id, product.name 
from product, top3mucgiacaonhat
where product.price = top3mucgiacaonhat.price;
-- where product.price in (select top3mucgiacaonhat.price from top3mucgiacaonhat);

-- 29. In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select product.id, product.name
from product, top3mucgiacaonhat
where product.price = top3mucgiacaonhat.price
and product.name like 'm%';

-- 32. Tính tổng số sản phẩm giá <300.
create view sanphamgiathaphon300 as
select product.id, product.name, product.price
from product
where product.price < 300;
select count(sanphamgiathaphon300.name) as soluongsanphamgiathaphon300 from sanphamgiathaphon300;

-- 33. Tính tổng số sản phẩm theo từng giá.

-- Cách 1: Không sử dụng View
select product.price, count(product.price) as soluongtheogia
from product
group by product.price;

-- Cách 2: Sử dụng view( về tìm hiểu lại)
-- create view soluongsanphamtheogia as
-- select product.price
-- from product
-- group by product.price;

-- select product.price, count(soluongsanphamtheogia.price) as soluong 
-- from product, soluongsanphamtheogia
-- group by soluongsanphamtheogia.price;

-- 34. Tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm bắt đầu bằng chữ M.
select max(product.price) as max, min(product.price) as min, avg(product.price) as average
from product
where product.name like 'm%';

-- 35. Tính doanh thu bán hàng mỗi ngày.
select demo2006.order.time, sum(product.price*orderdetail.quantity) as doanhthutheongay
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
group by date(demo2006.order.time);

-- 36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
select product.id, product.name, sum(product.id) as tongsanphambantrongthang10
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
where month(demo2006.order.time) = 10
group by product.name;


-- 37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
select month(demo2006.order.time) as thang, sum(product.price*orderdetail.quantity) as doanhso
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
where year(demo2006.order.time) = 2006
group by month(demo2006.order.time);

-- 38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select demo2006.order.id, demo2006.order.time, sum(orderdetail.quantity) as amount
from product
inner join orderdetail on product.id = orderdetail.productId
inner join demo2006.order on orderdetail.orderId = demo2006.order.id
group by demo2006.order.id
having amount >= 4;

-- 39. Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).

select orderdetail.orderId, demo2006.order.time, demo2006.order.customerId, count(productId) as count
from demo2006.order
join orderdetail on demo2006.order.id = orderdetail.orderId 
join product on orderdetail.productId = product.id
where product.price < 300
group by orderdetail.orderId
having count = 3;

-- 40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
select customer.id, customer.name
from customer 
join demo2006.order on customer.id = demo2006.order.customerId
join orderdetail on demo2006.order.id = orderdetail.orderId;


-- 41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
-- 42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
-- 45. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
create view khachmuanhieunhat as
select demo2006.order.customerId, count(demo2006.order.id) as count
from demo2006.order
group by demo2006.order.customerId;

select khachmuanhieunhat.customerId
from khachmuanhieunhat
where khachmuanhieunhat.count = (select max(khachmuanhieunhat.count) from khachmuanhieunhat);

select orderdetail.orderId, sum(product.price*orderdetail.quantity) as total
from orderdetail
join demo2006.product on orderdetail.productId =  product.id 
group by product.id


