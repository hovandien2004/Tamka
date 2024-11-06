--a. Viết thủ tục/hàm với tham số truyền vào là ngày A(dd/mm/yyyy), thủ tục/hàm dùng để
--lấy danh sách các trận đấu diễn ra vào ngày ngày A, danh sách được sắp xếp theo
--MaTD, Sân đấu.
--Thủ tục:
create proc sp_a
	@ngay datetime
as
	select MaTD, TrongTai,SanDau, MaDB1, db1.TenDB, MaDB2, db2.TenDB, Ngay 
	from TranDau join DoiBong db1 on TranDau.MaDB1 = db1.MaDB
					 join DoiBong db2 on TranDau.MaDB2 = db2.MaDB
	where TranDau.Ngay = @ngay
	order by MaTD, SanDau
--lời gọi:
sp_a '2024-12-18'

--hàm:
create function func_a(@ngay datetime)
returns table
as
	return(select MaTD, TrongTai,SanDau, MaDB1, db1.TenDB as TenDB1, MaDB2, db2.TenDB as TenDB2, Ngay 
			from TranDau join DoiBong db1 on TranDau.MaDB1 = db1.MaDB
							 join DoiBong db2 on TranDau.MaDB2 = db2.MaDB
			where TranDau.Ngay = @ngay
			
			)
select * from dbo.func_a('2024-12-18')


--b.Viết thủ tục/ hàm với tham số truyền vào là tên A, thủ tục/hàm dùng để lấy ra danh sách
--các cầu thủ có tên tương tự với tên A truyền vào này.
--Thủ tục:
create proc sp_DanhSach_CauThu_Ten
	@ten nvarchar(50)
as
	select *
	from CauThu
	where TenCT like '%' + @ten +'%'
--lời gọi:
sp_DanhSach_CauThu_Ten N'Hậu'

--Hàm:
create function func_DanhSach_CauThu_Ten(@ten nvarchar(50))
returns table
as
	return(select *
			from CauThu
			where TenCT like '%' + @ten +'%'
			)
--lời gọi:
select * from dbo.func_DanhSach_CauThu_Ten(N'Phong') 

--c.Tạo thủ tục/hàm có tham số truyền vào là MaTD. Thủ tục/hàm này dùng để lấy danh
--sách các cầu thủ đã thi đấu trong trận đấu đó. Danh sách gồm có MaCT, TenCT, SoTrai
--Thủ tục:
create proc sp_DanhSach_CauThu_ThiDau
	@matd varchar(50)
as
	select CauThu.MaCT, CauThu.TenCT, SoTrai
	from TranDau join ThamGia on TranDau.MaTD = ThamGia.MaTD
				 join CauThu on ThamGia.MaCT = CauThu.MaCT
	where TranDau.MaTD = @matd
--lời gọi:
sp_DanhSach_CauThu_ThiDau N'Hue-SLNA'
--Hàm:
create function func_DanhSach_CauThu_ThiDau(@matd varchar(50))
returns table
as
	return (select CauThu.MaCT, CauThu.TenCT, SoTrai
			from TranDau join ThamGia on TranDau.MaTD = ThamGia.MaTD
						 join CauThu on ThamGia.MaCT = CauThu.MaCT
			where TranDau.MaTD = @matd
			)
--Lời gọi:
select * from dbo.func_DanhSach_CauThu_ThiDau(N'Hue-SLNA')

--d. Tạo thủ tục/hàm dùng để thống kê mỗi trọng tài đã điều khiển bao nhiêu trận đấu.
--Thủ tục:
create proc sp_ThongKe_TrongTai_SoTranDau
as
	select TrongTai, COUNT(MaTD) as SoTranDau
	from TranDau
	group by TrongTai
--lời gọi:
sp_ThongKe_TrongTai_SoTranDau
--Hàm:
create function func_ThongKe_TrongTai_SoTranDau()
returns table
as
	return (select TrongTai, COUNT(MaTD) as SoTranDau
			from TranDau
			group by TrongTai
			)
--lời gọi:
select * from dbo.func_ThongKe_TrongTai_SoTranDau()
--e. Tạo thủ tục/hàm với tham số truyền vào là ngay1(dd/mm/yyyy) và
--ngay2(dd/mm/yyyy), thủ tục/hàm dùng để thống kê số trận đấu của các đội bóng (làm
--chủ nhà) đã thi đấu trong các ngày từ ngay1 đến ngay2.
--Thủ tục:
alter proc sp_ThongKe_SoTranDau_Ngay1_Ngay2
	@ngay1 datetime,
	@ngay2 datetime
as
	select db1.TenDB, COUNT(MaTD) as SoTranDau
	from TranDau join DoiBong db1 on TranDau.MaDB1 = db1.MaDB
	where Ngay >= @ngay1 and Ngay <= @ngay2
	group by db1.TenDB
--lời gọi:
sp_ThongKe_SoTranDau_Ngay1_Ngay2 '2024-12-01','2024-12-20'
--Hàm:
create function func_ThongKe_SoTranDau_Ngay1_Ngay2(@ngay1 datetime, @ngay2 datetime)
returns table
as
	return (select db1.TenDB, COUNT(MaTD) as SoTranDau
			from TranDau join DoiBong db1 on TranDau.MaDB1 = db1.MaDB
			where Ngay >= @ngay1 and Ngay <= @ngay2
			group by db1.TenDB
			)
--lời gọi:
select * from dbo.func_ThongKe_SoTranDau_Ngay1_Ngay2 ('2024-12-01','2024-12-20')

--f. Viết thủ tục dùng để thêm mới 1 dòng dữ liệu vào bảng đội bóng, bảng cầu thủ, bảng
--trận đấu, và bảng tham gia.	
--Thủ tục:
alter proc sp_insert
as
begin
	insert into DoiBong values(4,'SHB', 4)
	insert into CauThu values('CT04', N'Nguyễn Công Phượng', 4)
	insert into TranDau values('SLNA-Hue', 'Nobita', 'kkkk', 1, 2, '2024-12-25')
	insert into ThamGia values('SLNA-Hue', 'CT04', 5)

end
--lời gọi:
sp_insert

--g. Viết thủ tục dùng để cập nhật dữ liệu của một cầu thủ, với thông tin cầu thủ là tham số
--truyền vào và tham số @ketqua sẽ trả về chuỗi rỗng nếu cập nhật cầu thủ thành công,
--ngược lại tham số này trả về chuỗi cho biết lý do không cập nhật được.
create proc sp_Update
	@mact nvarchar(50),
	@tenct nvarchar(50),
	@madb int,
	@ketqua	nvarchar(50) output
as
	if not exists (select * from CauThu where MaCT = @mact)
		set @ketqua = N'Cầu Thủ này không tồn tại'
	else
	begin
		begin try
				update CauThu
				set MaCT = @mact,
					TenCT = @tenct,
					MaDB = @madb
				where MaCT = @mact
				if @@ERROR <> 0
					set @ketqua = N'Lỗi cập nhật dữ liệu'
				else
					set @ketqua = N'cập nhật dữ liệu thành công'
		end try
		begin catch
					set @ketqua = N'Lỗi cập nhật dữ liệu'
		end catch

	end
--lời gọi:
declare @kq nvarchar(255)
execute sp_Update 'CT04', N'Nguyễn Công Toàn', 4, @kq output
select @kq
--h. Viết hàm với tham số truyền vào là năm, hàm dùng để lấy ra số trọng tài đã tham gia
--điều khiển các trận đấu trong năm truyền vào.
create function func_SoTRongTai_Nam(@nam int)
returns int
as
begin
	return (select count(distinct TrongTai) as SoTrongTai
			from TranDau
			where YEAR(Ngay) = @nam
			)
end
--lời gọi:
select dbo.func_SoTRongTai_Nam(2024)
--i.Viết thủ tục vào tham số truyền vào là mã cầu thủ, thủ tục dùng để xóa cầu thủ này.
--(Gợi ý: nếu cầu thủ này đã từng tham gia ít nhất một trận đấu thì phải xóa dữ liệu ở
--bảng ThamGia trước rồi tiến hành xóa cầu thủ này)
create proc sp_delete_Mact
	@mact varchar(50)
as
begin
	if exists (select * from ThamGia where MaCT = @mact)
		begin
			delete from ThamGia where MaCT = @mact
		end
	delete from CauThu where MaCT = @mact
end
--lời gọi:
sp_delete_Mact 'CT04'

--j. Viết hàm với tham số truyền vào là macauthu, hàm dùng để lấy ra tổng bàn thắng của
--cầu thủ này.
create function func_TongSo_BanThang_CauuThu_Mact(@mact varchar(50))
returns int
as
begin
	return (select sum(SoTrai)
			from ThamGia
			group by MaCT
			having MaCT = @mact
			) 
end
--lời gọi:
select dbo.func_TongSo_BanThang_CauuThu_Mact('CT01')
--k. Viết một hàm trả về tổng bàn thắng mà mỗi cầu thủ ghi được trong tất cả các trận.
create function func_TongBanThang_CauThu()
returns table
as
	return (select ThamGia.MaCT, isnull (sum(SoTrai), 0)
			from CauThu left join ThamGia on CauThu.MaCT = ThamGia.MaCT
			group by ThamGia.MaCT
			)
--lời gọi:
select * from dbo.func_TongBanThang_CauThu()

--Viết thủ tục/hàm lấy danh sách các cầu thủ ghi nhiều bàn thắng nhất.
--hàm:
--c1:
create proc sp_DanhSach_CauThu_NhieuBanThang_Nhat
as
	select ThamGia.MaCT, TenCT, sum(SoTrai)
	from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
	group by ThamGia.MaCT, TenCT
	having sum(SoTrai) >= all (select top 1 sum(SoTrai)
						  from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
						  group by ThamGia.MaCT, TenCT
						  order by sum(SoTrai) desc
						)
--lời gọi:
sp_DanhSach_CauThu_NhieuBanThang_Nhat
--c2
select top 1 with ties ThamGia.MaCT, TenCT, sum(SoTrai)
from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
group by ThamGia.MaCT, TenCT
order by sum(SoTrai) desc

--Hàm:
create function func_DanhSach_CauThu_NhieuBanThang_Nhat()
returns table
as
	return (select top 1 with ties ThamGia.MaCT, TenCT, sum(SoTrai) as TongBanThang
			from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
			group by ThamGia.MaCT, TenCT
			order by sum(SoTrai) desc
			)
--lời gọi:
select * from dbo.func_DanhSach_CauThu_NhieuBanThang_Nhat()

--m. Viết thủ tục/hàm với tham số truyền vào số A, thủ tục/hàm dùng để lấy ra danh sách các
--cầu thủ ghi số bàn thắng lớn hơn số A này.
--Thủ tục:
alter proc sp_DanhSach_CauThu_NhieuBanThang_A
	@A int
as
	select ThamGia.MaCT, TenCT, sum(SoTrai) as TongBanThang
	from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
	group by ThamGia.MaCT, TenCT
	having sum(SoTrai) > @A
--lời gọi:
sp_DanhSach_CauThu_NhieuBanThang_A 2

--Hàm:
create function func_DanhSach_CauThu_NhieuBanThang_A(@A int)
returns table
as
	return (select ThamGia.MaCT, TenCT, sum(SoTrai) as TongBanThang
			from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
			group by ThamGia.MaCT, TenCT
			having sum(SoTrai) > @A
			)
--lời gọi:
select * from dbo.func_DanhSach_CauThu_NhieuBanThang_A(2) 

--n. Viết thủ tục/hàm với tham số truyền vào là @nam. Thủ tục/hàm dùng để thống kê mỗi
--tháng trong năm truyền vào có bao nhiêu trận đấu được diễn ra. Nếu tháng nào không
--có trận đấu nào tổ chức thì ghi là 0.
alter proc sp_ThongKe_SoTranDau_Thang_Nam
	@nam int
as
begin
	declare @thang int = 1
	declare @SoTranDau int
	declare @dboSoTranDau table(thang int, SoTranDau int)
	while (@thang <= 12)
		begin
			insert into @dboSoTranDau values(@thang, (select isnull(COUNT(MaTD), 0)
														from TranDau
														where MONTH(Ngay) = @thang and YEAR(Ngay) = @nam
													  )
											)
			set @thang += 1
		end
	select * from @dboSoTranDau
end
--lời gọi:
sp_ThongKe_SoTranDau_Thang_Nam 2024

--Hàm:
create function func_ThongKe_SoTranDau_Thang_Nam(@nam int)
returns @dboSTD table(Thang int, SoTranDau int)
as
begin
	declare @Thang int = 1
	while (@Thang <= 12)
		begin
			insert into @dboSTD values (@Thang,
										(select isnull(COUNT(MaTD), 0)
										 from TranDau
										 where MONTH(Ngay) = @thang and YEAR(Ngay) = @nam
										)
										)
			set @Thang += 1
		end
		return

end
--lời gọi:
select * from dbo.func_ThongKe_SoTranDau_Thang_Nam(2024)

--o. Viết một thủ tục dùng để tạo ra một bảng mới có tên CauThu_BanThang, bảng này
--chứa tổng số bàn thắng mà mỗi cầu thủ ghi được. Nếu cầu thủ nào chưa ghi bàn thắng
--nào thì ghi số bàn thắng là 0.
alter proc sp_TaoBang_CauThu_BanThang
as
begin
	declare @CauThu nvarchar(50)
	declare @BanThang int
	declare @dboCauThu_BanThang table(CauThu nvarchar(50), BanThang int)
	declare @dem int = 1
	while(@dem <= (select count(MaCT) from CauThu))
		begin
			insert into @dboCauThu_BanThang values((select TenCT
													from CauThu
													),
													(select isnull(sum(SoTrai),0)
													from ThamGia
													group by MaCT
													)
													)
			set @dem += 1

		end
	select * from @dboCauThu_BanThang
end
--lời gọi:
sp_TaoBang_CauThu_BanThang
--Chat gpt fix lỗi 1:
ALTER PROCEDURE sp_TaoBang_CauThu_BanThang_lai
AS
BEGIN
    -- Khai báo các biến và bảng tạm
    DECLARE @CauThu NVARCHAR(50);
    DECLARE @BanThang INT;
    DECLARE @dem INT = 1;

    -- Tạo bảng tạm để lưu kết quả
    DECLARE @dboCauThu_BanThang TABLE (CauThu NVARCHAR(50), BanThang INT);

    -- Lặp qua tất cả các cầu thủ
    WHILE @dem <= (SELECT COUNT(MaCT) FROM CauThu)
    BEGIN
        -- Lấy tên cầu thủ và tổng bàn thắng của cầu thủ hiện tại
        SELECT @CauThu = TenCT
        FROM CauThu
        WHERE MaCT = @dem;  -- Lấy tên cầu thủ theo mã cầu thủ

        SELECT @BanThang = ISNULL(SUM(SoTrai), 0)  -- Nếu không có bàn thắng thì trả về 0
        FROM ThamGia
        WHERE MaCT = @dem;  -- Lấy tổng bàn thắng của cầu thủ theo mã cầu thủ

        -- Chèn thông tin vào bảng tạm
        INSERT INTO @dboCauThu_BanThang (CauThu, BanThang)
        VALUES (@CauThu, @BanThang);

        -- Tăng biến đếm
        SET @dem = @dem + 1
    END

    -- Hiển thị kết quả
    SELECT * FROM @dboCauThu_BanThang
END

--Chat gpt fix lỗi 2:
ALTER PROCEDURE sp_TaoBang_CauThu_BanThang2
AS
BEGIN
    -- Khai báo bảng tạm để lưu kết quả
    DECLARE @dboCauThu_BanThang TABLE (CauThu NVARCHAR(50), BanThang INT);
    
    -- Chèn dữ liệu vào bảng tạm @dboCauThu_BanThang
    INSERT INTO @dboCauThu_BanThang (CauThu, BanThang)
    SELECT
        TenCT, 
        ISNULL(SUM(t.SoTrai), 0)  -- Tổng số bàn thắng của cầu thủ, nếu không có thì là 0
    FROM
        CauThu ct
    LEFT JOIN ThamGia t ON ct.MaCT = t.MaCT
    GROUP BY
        TenCT;
    
    -- Chọn dữ liệu từ bảng tạm để trả kết quả
    SELECT * FROM @dboCauThu_BanThang;
END;
sp_TaoBang_CauThu_BanThang2


--p. Viết một trigger, trigger này dùng để cập nhật tổng bàn thắng của cầu thủ ở bảng
--CauThu_BanThang mỗi khi có cập nhật hoặc thêm mới số bàn thắng của cầu thủ ở
--bảng ThamGia.
