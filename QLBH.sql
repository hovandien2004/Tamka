--Viết hàm thống kê số lượng khách hàng đã tới mua hàng
create function func_KhachHang_SLKhachHangDenMua()
returns int
as
begin
	return (select  count(distinct makh)
			from tbl_HoaDon		
			)
end
--lời gọi:
select dbo.func_KhachHang_SLKhachHangDenMua()
--Viết hàm với tham số truyền vào là tháng, năm. Hàm dùng để thống kê doanh thu của tháng năm truyền vào
create function func_HoaDon_DoanhThu_TheoThangNam
(
	@thang int,
	@nam int
)
returns int
as
begin
	return (select sum(SL*DonGia)
			from tbl_HoaDon inner join tbl_CTHD on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
			where MONTH(NgayLap) = @thang
			and YEAR(NgayLap) = @nam
		    )
end

--lời gọi:
select dbo.func_HoaDon_DoanhThu_TheoThangNam(1,2022)
--Viết hàm với tham số truyền vào tháng, năm.Hàm dùng để lấy ra tên 1 mặt hàng được bán nhiều nhất trong tháng, năm truyền vào
alter function func_Hang_TenHang_BanChayNhat
(
	@thang int,
	@nam int
)
returns nvarchar(50)
as
begin
	return (select top 1 TenHang
			from tbl_Hang inner join tbl_CTHD on tbl_Hang.MaHang = tbl_CTHD.MaHang
						  inner join tbl_HoaDon on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
			where MONTH(NgayLap) = @thang
			and YEAR(NgayLap) = @nam
			group by TenHang
			order by sum(tbl_CTHD.SL) desc
		    )
end
--lời gọi
select dbo.func_Hang_TenHang_BanChayNhat(1,2022)

--viết hàm lấy ra các mặt hàng chưa được bán lần nào
create function func_Hang_Select_HangChuaDuocBan()
returns table
as
return (select tbl_Hang.*
		from tbl_Hang left join tbl_CTHD on tbl_Hang.MaHang = tbl_CTHD.MaHang
		where MaHD is null
		)
--lời gọi
select *
from dbo.func_Hang_Select_HangChuaDuocBan()

--viết hàm với tham số truyền vào là năm. hàm dùng để thống kê mỗi tháng, doanh thu là bao nhiêu trong năm truyền vào
alter function func_HoaDon_DoanhThuThan_Nam(@nam int)
returns table
as
return (select month(NgayLap) as da,sum(SL*DonGia) as fd
		from tbl_HoaDon inner join tbl_CTHD on tbl_HoaDon.MaHD = tbl_CTHD.MaHD
		where year(NgayLap) = @nam
		group by month(NgayLap)
		)
--lời gọi
select *
from dbo.func_HoaDon_DoanhThuThan_Nam(2022)

--viết hàm với tham số truyền vào là năm. hàm dùng để thống kê mối khách hàng đến mua bao nhiêu lần trong năm truyên vào
create function func_KhachHang_SoLanDenMua_Nam(@nam int)
returns table
as
return (select tbl_KhachHang.MaKH,TenKH, count(MaHD) as solan
		from tbl_KhachHang inner join tbl_HoaDon on tbl_KhachHang.MaKH = tbl_HoaDon.MaKH
		where year(ngaylap) = @nam
		group by tbl_KhachHang.MaKH,TenKH

		)
select *
from dbo.func_KhachHang_SoLanDenMua_Nam(2022)
--viết hàm với tham số truyền vào là năm, hàm dùng để lấy ra danh sách khách hàng đến mua nhiều lần nhất trong năm truyền vào
--cách 1:
create function func_Khachhang_SoLanDenMuaMax_Nam(@nam int)
returns table
as
return (
		select tbl_KhachHang.MaKH,TenKH, count(MaHD) as solan
		from tbl_KhachHang inner join tbl_HoaDon on tbl_KhachHang.MaKH = tbl_HoaDon.MaKH
		where year(ngaylap) = @nam
		group by tbl_KhachHang.MaKH,TenKH
		having count(MaHD) = (
								select top 1 count(MaHD) as solan
								from tbl_KhachHang inner join tbl_HoaDon on tbl_KhachHang.MaKH = tbl_HoaDon.MaKH
								where year(ngaylap) = @nam
								group by tbl_KhachHang.MaKH,TenKH
								order by solan desc
							 )
		)
--loigoi:
select *
from dbo.func_Khachhang_SoLanDenMuaMax_Nam(2022)

--cach 2:
alter function func_Khachhang_SoLanDenMuaMax_Nam_2(@nam int)
returns table
as
return (select *
		from func_KhachHang_SoLanDenMua_Nam(@nam)
		where solan = (select max(solan)
						from dbo.func_Khachhang_SoLanDenMuaMax_Nam(@nam)
						)
		)
--lời gọi
select *
from dbo.func_Khachhang_SoLanDenMuaMax_Nam(2022)
--viết hàm với tham số truyền vào là năm. hàm dùng để thống kê mỗi tháng, doanh thu là boa nhiêu trong năm truyền vào. nếu tháng nào không hoạt đọng thì ghi là  0
--c1:
create function func_HoaDon_DoanhThuThang_Nam(@nam int)
returns @tblDoanhThu table(Thang int, DoanhThu int)
as
begin
	declare @thang int = 1
	while @thang <= 12
	begin	
		declare @doanhthu int
		set @doanhthu = dbo.func_HoaDon_DoanhThu_TheoThangNam(@thang, @nam)

		insert into @tblDoanhThu
		values (@thang, @doanhthu)

		set @thang +=1
	end
	return 
end

--lời gọi:
select *
from func_HoaDon_DoanhThuThang_Nam(2022)
--c2:
create function func_HoaDon_DoanhThucacThang_Nam(@nam int)
returns @tblDoanhThu table(Thang int, DoanhThu int)
as
begin
	declare @thang int = 1
	while @thang <= 12
	begin	
		declare @doanhthu int
		set @doanhthu = isnull(dbo.func_HoaDon_DoanhThu_TheoThangNam(@thang, @nam),0)

		insert into @tblDoanhThu
		values (@thang, @doanhthu)

		set @thang +=1
	end
	return 
end
--lời gọi:
select *
from func_HoaDon_DoanhThucacThang_Nam(2022)


--c3:
alter function func_HoaDon_DoanhThucacThang_Nam_c3(@nam int)
returns @tblDoanhThu table(Thang int, DoanhThu int)
as
begin
	declare @tblThang table (Thang int)
	declare @thang int  = 1
	while(@thang <= 12)
	begin
		insert into @tblThang values(@thang)
		set @thang +=1
	end
	insert into @tblDoanhThu
	select t1.Thang, isnull(t2.DoanhThu, 0) as DoanhThu
	from @tblThang t1 left join dbo.func_HoaDon_DoanhThuThang_Nam(@nam) t2 on t1.Thang = t2.Thang
	return 
end

--lời gọi:
--lời gọi:
select *
from func_HoaDon_DoanhThucacThang_Nam_c3(2022)