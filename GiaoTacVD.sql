create proc sp_ThemSV @masv int, @malop int
as
	begin tran
		--khai báo biến siso
		declare @sisi int
		--lay siso cua lop
		select @siso = siso
		from lop
		where malop = @malop
		--Kiem tra siso cua lop >= 40?
		if(@siso >= 40) -- nếu >= 40 thì hủy việc themsv
		begin
			rollback transaction
			return
		end
		--siso < 40 thi tien hanh them sv
		insert into sinh_vien(masv, malop)
		values(@masv, @malop)
		--nếu việc them bị lỗi thì hủy việc themsv
		if(@@ERROR <> 0)
		begin
			rollback transaction
			return
		end
		--update siso o bảng lớp
		update lop
		set siso = siso+1
		where malop = @malop
		--neu cap nhật siso lỗi thì hủy việc themsv
		if(@@ERROR <> 0)
		begin
			rollback transaction
			return
		end
	commit transaction