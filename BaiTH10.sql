--a. Viết thủ tục/hàm dùng để lấy ra danh sách các quyển sách có trong thư viện.
--thủ tục:
create proc sp_DanhSach_Sach_ThuVien
as
	select * 
	from Sachmuon
--lời gọi:
sp_DanhSach_Sach_ThuVien
--Hàm:
create function func_DanhSach_Sach_ThuVien()
returns table
as
	return(select * 
			from Sachmuon)
--lời gọi:
select * from dbo.func_DanhSach_Sach_ThuVien()

--b. Viết thủ tục/hàm với tham số truyền vào là ngày. Thủ tục/hàm dùng để lấy ra danh sách
--các quyển sách được mượn cùng các độc giả mượn sách trong ngày truyền vào.
--Thủ tục:
create proc sp_DanhSach_SachMuon_Ngay
	@ngay datetime 
as
	select Muon.masach, tensach, Muon.madg, tendg
	from Muon join Sachmuon on Muon.masach = Sachmuon.masach
				join Docgia on Muon.madg = Docgia.madg
	where ngaymuon = @ngay
--lời gọi:
sp_DanhSach_SachMuon_Ngay '2024-11-10'
--Hàm:
create function func_DanhSach_SachMuon_Ngay(@ngay datetime)
returns table
as
	return(select Muon.masach, tensach, Muon.madg, tendg
			from Muon join Sachmuon on Muon.masach = Sachmuon.masach
						join Docgia on Muon.madg = Docgia.madg
			where ngaymuon = @ngay
			)
--lời gọi:
select * from dbo.func_DanhSach_SachMuon_Ngay('2024-11-10')
--c. Viết thủ tục/hàm với tham số truyền vào là tên độc giả. Thủ tục/hàm dùng để lấy ra các
--độc giả có tên tương tự với tên truyền vào.
--Thủ tục:
create proc sp_DocGia_Ten
	@tendg nvarchar(50)
as
	select madg, tendg
	from Docgia
	where tendg like'%' + @tendg + '%'
--lời gọi:
sp_DocGia_Ten N'Mai'

--hàm:
create function func_DocGia_Ten(@tendg nvarchar(50))
returns table
as
	return(select madg, tendg
			from Docgia
			where tendg like'%' + @tendg + '%'
			)
--Lời lợi:
select * from dbo.func_DocGia_Ten(N'Mai')

--d. Viết thủ tục/ hàm với tham số truyền vào là mã tác giả, thủ tục/hàm dùng để lấy ra danh
--sách các quyển sách mà tác giả này sáng tác.
--Thủ tục:
create proc sp_DanhSach_Sach_Tacgia_Matg
	@matg nvarchar(10)
as
	select Sachmuon.*
	from Tacgia join Sachmuon on Tacgia.matg = Sachmuon.matg
	where Tacgia.matg = @matg
--lời gọi:
sp_DanhSach_Sach_Tacgia_Matg 'TG002'

--Hàm:
create function func_DanhSach_Sach_Tacgia_Matg(@matg nvarchar(10))
returns table
as
	return(select Sachmuon.*
			from Tacgia join Sachmuon on Tacgia.matg = Sachmuon.matg
			where Tacgia.matg = @matg
			)
--lời gọi:
select * from dbo.func_DanhSach_Sach_Tacgia_Matg('TG002')

--e. Viết thủ tục/hàm dùng để lấy ra danh sách các độc giả chưa trả sách.
--Thủ tục:
create proc sp_DanhSach_DocGia_ChuaTraSach
as
	select Docgia.*
	from Docgia join Muon on Docgia.madg = Muon.madg
	where ngaytra is null
--lời gọi:
sp_DanhSach_DocGia_ChuaTraSach

--Hàm:
create function func_DanhSach_DocGia_ChuaTraSach()
returns table
as
	return(select Docgia.*
			from Docgia join Muon on Docgia.madg = Muon.madg
			where ngaytra is null
			)
--lời gọi:
select * from dbo.func_DanhSach_DocGia_ChuaTraSach()

--f. Viết hàm dùng để lấy ra số các quyển sách có trong thư viện.
create function func_So_Sach_ThuVien()
returns int
as
begin
	return(select count(masach) as SoSach
			from Sachmuon
			)
end
--lời gọi:
select dbo.func_So_Sach_ThuVien()

--g. Viết hàm với tham số truyền vào là ngày(dd/mm/yyyy), hàm dùng để lấy xem có bao
--nhiêu độc giả tới mượn sách trong ngày này.
alter function func_Dem_DocGia_MuonSach_Ngay(@ngay datetime)
returns int
as
begin
	return (select count(madg)
			from Muon
			where ngaymuon = @ngay
			)
end
--lời gọi:
select dbo.func_Dem_DocGia_MuonSach_Ngay('2024-11-10')

--h. Viết thủ tục dùng để thêm mới một độc giả. Với các thông tin độc giả là tham số truyền
--vào và tham số @Ketqua sẽ trả về chuỗi rỗng nếu thêm mới độc giả thành công, ngược
--lại tham số này trả về chuỗi cho biết lý do không thêm mới được.
create proc sp_insert_DocGia
	@madg nvarchar(10),
	@tendg nvarchar(50),
	@doituong nvarchar(50),
	@ketqua nvarchar(255) output
as
begin
	if exists(select * from Docgia where madg = @madg)
		set @ketqua = N'Doc gia nay da ton tai'
	else
		begin 
			insert into Docgia values(@madg, @tendg, @doituong)
			if @@ERROR <> 0
				set @ketqua = N'Loi cap nhat du lieu'
			else
				set @ketqua = ''	
		end 
end
--lời gọi:
declare @kq nvarchar(255)
execute sp_insert_DocGia 'DG004', N'Nguyen Van Linh', N'Student', @kq output
select @kq

--i. Viết thủ tục với tham số truyền vào là mã sách. Thủ tục dùng để xóa quyển sách này
--trong thư viện.
create proc sp_delete_Xoa_MaSach
	@masach nvarchar(10)
as
	delete Sachmuon
	where masach = @masach
--lời gọi:
sp_delete_Xoa_MaSach 'S004'

--j. Viết thủ tục dùng để cập nhật lại thông tin của tác giả. Với các thông tin muốn cập nhật
--là tham số truyền vào và tham số @Ketqua sẽ trả về chuỗi rỗng nếu cập nhật độc giả
--thành công, ngược lại tham số này trả về chuỗi cho biết lý do không cập nhật được.
create proc sp_Update_TacGia
	@matg nvarchar(10),
	@tentg nvarchar(50),
	@chuyenmon nvarchar(50),
	@ketqua nvarchar(255) output
as
begin
	if not exists(select * from Tacgia where matg = @matg)
		set @ketqua = N'Khong ton tai tac gia nay'
	else
		begin try
				update Tacgia
				set tentg = @tentg,
					chuyenmon = @chuyenmon
				where matg = @matg
				if @@ERROR <> 0
					set @ketqua = N'Loi cap nhat du lieu'
				else
					set @ketqua = N''	
		end try
		begin catch
				set @ketqua = 'Loi cap nhat du lieu'
		end catch
end
--lời gọi:
declare @kq nvarchar(255)
execute sp_Update_TacGia 'TG003', N'Hoang Tung', N'Philosophy', @kq output
select @kq

--k. Viết thủ tục/hàm với tham số truyền vào là tháng, năm. Thủ tục/hàm dùng để thống kê
--mỗi ngày có bao nhiêu người tới mượn sách trong tháng, năm truyền vào
--Thủ tục:
create proc sp_ThongKe_SoNguoi_MuonSach_Thang_Nam
	@thang int,
	@nam int
as
begin
	declare @ngay int
	if(@thang = 1 or @thang = 3 or @thang = 5 or @thang = 7 or @thang = 8 or @thang = 10 or @thang = 12)
		set @ngay = 31
	if(@thang = 4 or @thang = 6 or @thang = 9 or @thang = 11)
		set @ngay = 30 
	if(@nam % 4 = 0 and @nam % 100 != 0 or @nam % 400 = 0)
		begin 
			if(@thang = 2)
				set @ngay = 29
		end
	else
		if(@thang = 2)	
			set @ngay = 28

	declare @ngay1 int = 1
	declare @songuoi int
	declare @dboThongKe table(ngay int, songuoi int)
	
	while(@ngay1 <= @ngay)
		begin
			insert into @dboThongKe values(@ngay1, (select count(madg) as songuoi
													from Muon
													where DAY(ngaymuon) = @ngay1 and MONTH(ngaymuon) = @thang and YEAR(ngaymuon) = @nam
													)
					
										   )
			set @ngay1 += 1
		end
		select * from @dboThongKe
end
--lời gọi:
sp_ThongKe_SoNguoi_MuonSach_Thang_Nam 10, 2024

--Hàm:
create function func_ThongKe_SoNguoi_MuonSach_Thang_Nam(@thang int, @nam int)
returns @dboThongKe table(ngay int, songuoi int)
as
begin
	declare @ngay int
	if(@thang = 1 or @thang = 3 or @thang = 5 or @thang = 7 or @thang = 8 or @thang = 10 or @thang = 12)
		set @ngay = 31
	if(@thang = 4 or @thang = 6 or @thang = 9 or @thang = 11)
		set @ngay = 30 
	if(@nam % 4 = 0 and @nam % 100 != 0 or @nam % 400 = 0)
		begin 
			if(@thang = 2)
				set @ngay = 29
		end
	else
		if(@thang = 2)	
			set @ngay = 28

	declare @ngay1 int  = 1
	while(@ngay1 <= @ngay)
		begin
			insert into @dboThongKe values(@ngay1, (select count(madg) as songuoi
													from Muon
													where DAY(ngaymuon) = @ngay1 and MONTH(ngaymuon) = @thang and YEAR(ngaymuon) = @nam
													)
					
										   )
			set @ngay1 += 1
		end
		return
end 
-- lời gọi:
select * from dbo.func_ThongKe_SoNguoi_MuonSach_Thang_Nam(10,2024)

--l. Viết thủ tục/hàm dùng để thống kê mỗi độc giả đã tới thư viện mượn bao nhiêu lần.
--Thủ tục:
create proc sp_ThongKe_DocGia_Muon_BaoNhieuLan
as
begin
	select madg, count(madg) as SoLanMuonSach
	from Muon
	group by madg
end
--lời gọi:
sp_ThongKe_DocGia_Muon_BaoNhieuLan

--Hàm:
alter function func_ThongKe_DocGia_Muon_BaoNhieuLan()
returns table
as
	return (select madg, count(madg) as SoLanMuonSach
			from Muon
			group by madg
			)
--Lời gọi:
select * from dbo.func_ThongKe_DocGia_Muon_BaoNhieuLan()
--m. Viết thủ tục/hàm với tham số truyền vào là số lần mượn sách. Thủ tục/hàm dùng để lấy
--ra danh sách các độc giả đã tới mượn sách có số lần lớn hơn tham số truyền vào.
--Thủ tục:
create proc sp_DanhSach_DocGia_MuonSach_NhieuHon
	@soLanMuon int
as
	select Docgia.madg, Docgia.tendg, COUNT(Docgia.madg) as haha
	from Muon join Docgia on Muon.madg = Docgia.madg
	group by Docgia.madg, Docgia.tendg
	having count(Docgia.madg) > @soLanMuon
--Lời gọi:
sp_DanhSach_DocGia_MuonSach_NhieuHon 1

--hàm:
create function func_DanhSach_DocGia_MuonSach_NhieuHon(@soLanMuon int)
returns table
as
	return (select Docgia.madg, Docgia.tendg, COUNT(Docgia.madg) as haha
			from Muon join Docgia on Muon.madg = Docgia.madg
			group by Docgia.madg, Docgia.tendg
			having count(Docgia.madg) > @soLanMuon
			)
--Lời gọi:
select * from dbo.func_DanhSach_DocGia_MuonSach_NhieuHon(1)

--n. Viết hàm dùng để ra số quyển sách có trong thư viện.
create function func_SoSach_ThuVien()
returns int
as
begin
	return (select COUNT(masach) as so
			from Sachmuon
			)
end
--Lời gọi:
select dbo.func_SoSach_ThuVien()
--o. Viết thủ tục/hàm dùng để thống kê mỗi quyển sách trong thư viện được mượn bao
--nhiêu lần. Nếu quyển sách nào chưa được mượn lần nào thì ghi số lần là 0.
--Thủ tục:
create proc sp_ThongKe_MoiSach_Muon_BaoNhieuLan
as
	select Sachmuon.masach, Sachmuon.tensach, count(Muon.masach)
	from Sachmuon left join Muon on Sachmuon.masach = Muon.masach
	group by Sachmuon.masach, Sachmuon.tensach
--Lời gọi:
sp_ThongKe_MoiSach_Muon_BaoNhieuLan

--Hàm:
create function func_ThongKe_MoiSach_Muon_BaoNhieuLan()
returns table
as
	return (select Sachmuon.masach, Sachmuon.tensach, count(Muon.masach) as SoLanMuon
			from Sachmuon left join Muon on Sachmuon.masach = Muon.masach
			group by Sachmuon.masach, Sachmuon.tensach
			)
--Lời gọi:
select * from dbo.func_ThongKe_MoiSach_Muon_BaoNhieuLan()

--p. Viết thủ tục/hàm với tham số truyền vào là @ngayA, @ngayB. Thủ tục/hàm dùng để
--thống kê mỗi ngày từ @ngayA đến @ngayB có bao nhiêu người tới mượn sách. Nếu
--ngày nào không có người nào mượn sách thì ghi là 0.
create proc sp_SoNguoiMuonSach_TuA_DenB
	@ngayA datetime,
	@ngayB datetime
as
	select
	from 


--q. Viết thủ tục/hàm với tham số truyền vào là năm. Thủ tục/hàm dùng để lấy ra các tác giả
--không sáng tác một quyển sách nào trong năm truyền vào.
--Thủ tục:
create proc sp_TacGia_KhongSangTac_Nam
	@nam int
as
	select  distinct Tacgia.*
	from Sachmuon right join Tacgia on Sachmuon.matg = Tacgia.matg
	where namxb != @nam
--Lời gọi:
sp_TacGia_KhongSangTac_Nam 2015

--Hàm:
create function func_TacGia_KhongSangTac_Nam(@nam int)
returns table
as
	return (select  distinct Tacgia.*
			from Sachmuon right join Tacgia on Sachmuon.matg = Tacgia.matg
			where namxb != @nam
			)
--Lời gọi:
select * from dbo.func_TacGia_KhongSangTac_Nam(2015)