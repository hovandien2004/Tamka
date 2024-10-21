--a.Viết hàm dùng để lấy ra danh sách các học viên.
create function func_Select_DS_HocVien()
returns table
as 
	return (select* from Students)
--Lời gọi:
select * from dbo.func_Select_DS_HocVien()

--b.Viết hàm với tham số truyền vào là Họ, hàm dùng để lấy danh sách các học viên có họ giống với họ truyền vào.
create function func_HocVien_Ho(@ho nvarchar(50))
returns table
as
	return(select *
			from Students
			where StudentName like N''+ @ho +'%'
			)
--lời gọi:
select * from dbo.func_HocVien_Ho(N'Nguyen')

--c.Viết hàm với tham số truyền vào là mã môn học, hàm dùng để lấy ra số học viên đăng ký học môn học này.
alter function func_SoHocVien_DKMonHoc_MaHV(@mamh int)
returns int
as
begin 
	return (select count(distinct StudentID)
			from Marks
			where SubjectID = @mamh
			group by SubjectID

			
			)
end
--lời gọi:
select dbo.func_SoHocVien_DKMonHoc_MaHV(1)

--d.Viết hàm hiển thị danh sách và điểm của các học viên ứng với các môn học.
create function func_Select_Danhsach_Diem_HocVien()
returns table
as
	return (select  Subjects.SubjectID,Subjects.SubjectName,Students.*, Marks.Mark
			from Students join Marks on Students.StudentID = Marks.StudentID
							join Subjects on Subjects.SubjectID = Marks.SubjectID
			
			)
--Lời gọi:
select * from dbo.func_Select_Danhsach_Diem_HocVien()

--e.Viết hàm lấy ra số học viên hiện có.
create function func_SoHocVien_HienCo()
returns int
as
begin
	return (select count(StudentID)
			from Students
			
			)
end
--lời gọi:
select dbo.func_SoHocVien_HienCo()

--f.Viết hàm với tham số truyền vào là tuổi 1 đến tuổi 2, hàm dùng để lấy ra danh sách các
--học viên có độ tuổi từ tuổi 1 đến tuổi 2.
create function func_DanhSach_Tuoi(@tuoi1 int, @tuoi2 int)
returns table
as
	return (select *
			from Students
			where Age >= @tuoi1 and Age <= @tuoi2
			)
--lời gọi:
select *
from dbo.func_DanhSach_Tuoi(19,26)

--g.Viết hàm tính điểm trung bình của các học viên
create function func_diemtb()
returns table
as
	return (select Students.StudentID, StudentName,avg(Mark) as GPA
			from Marks join Students on Marks.StudentID = Students.StudentID
			group by Students.StudentID,StudentName
			)
--lời gọi:
select * from dbo.func_diemtb()


--h.Viết hàm lấy ra điểm trung bình lớn nhất của các học viên
create function func_GPA_Max()
returns int
as
begin
	return (select top 1 avg(Mark) as GPA
			from Marks 
			group by StudentID
			order by  avg(Mark) desc
			)
end
--lời gọi:
select dbo.func_GPA_Max()

--c2:
create function func_GPA_Max1()
returns int
as
begin
	return (select avg(Mark) as GPA
			from Marks 
			group by StudentID
			having avg(Mark) = (select top 1 avg(Mark)
								from Marks
								group by StudentID
								order by  avg(Mark) desc
								)
			)
end

--i.Viết hàm hiển thị danh sách các học viên chưa thi môn nào.
--c1: left join
create function func_DS_HocVien_ChuaThi()
returns table
as
	return (select Students.*
			from Students left join Marks on Students.StudentID = Marks.StudentID
			where Mark is null
			)
--lời gọi:
select * from dbo.func_DS_HocVien_ChuaThi()

--c2: not in
create function func_DS_HocVien_ChuaThi_NotIn()
returns table
as
	return (select *
			from Students 
			where StudentID not in (select distinct StudentID
									from Marks
									
									)
			)
--lời gọi:
select * from dbo.func_DS_HocVien_ChuaThi_NotIn()

--j.Viết hàm với tham số truyền vào là điểm trung bình, hàm dùng để lấy ra danh sách các
--học viên có điểm trung bình lớn hơn điểm trung bình truyền vào.
create function func_GPA_Lon_GPA1(@gpa int)
returns table
as
	return (select Students.StudentID, StudentName, avg(Mark) as GPA
			from Students join Marks on Students.StudentID = Marks.StudentID
			group by Students.StudentID, StudentName
			having avg(Mark) > @gpa
			)
--lời gọi:
select * from dbo.func_GPA_Lon_GPA1(2)

--k.Giả sử điểm (mark) của sinh viên từ 0, 1, 2, …, 9, 10. Hãy viết hàm với tham số truyền
--vào là mã môn học, hàm dùng để thống kê mỗi mức điểm này có bao nhiêu sinh viên
--đạt trong môn học này. (Ví dụ: điểm 0 có 2 người, điểm 1 có 0 người, …, điểm 10 có 2
--người).
create function func_ThongKe_Diem(@mamh int)
returns table
as
	return (select Mark, count(StudentID) as dem
			from Marks
			where SubjectID = @mamh
			group by Mark
			)
--lời gọi:
select * from dbo.func_ThongKe_Diem(1)
--l.Viết hàm lấy ra những sinh viên có điểm trung bình cao nhất.
create function func_SV_DTB_MAX()
returns table
as
	return (select Students.StudentID, StudentName,avg(Mark) as GPA
			from Marks join Students on Marks.StudentID = Students.StudentID
			group by Students.StudentID, StudentName
			having avg(Mark) = (select top 1 avg(Mark)
								from Marks
								group by StudentID
								order by  avg(Mark) desc
								)
			)

--lời gọi:
select * from dbo.func_SV_DTB_MAX()
--m.Viết hàm dùng để thống kê mỗi môn học có bao nhiêu học viên đăng kí thi.
create function func_ThongKe_DKThi_MonHoc()
returns table
as
return (
    select Marks.SubjectID, COUNT(distinct StudentID) as SoSv
    from Marks
    group by SubjectID
)

--lời gọi:
select * from dbo.func_ThongKe_DKThi_MonHoc()

--n.Viết hàm với tham số truyền vào là SoSV, hãy lấy ra danh sách các môn học có số học
--viên đăng ký thi là nhỏ hơn SoSV truyền vào.
create function func_DS_MonHoc_SV_DKThi_Sosv(@Sosv int)
returns table
as
	return (select Subjects.SubjectID, SubjectName, COUNT(StudentID) as dem
			from Subjects join Marks on Subjects.SubjectID = Marks.SubjectID
			
			group by Subjects.SubjectID, SubjectName
			having COUNT(StudentID) < @Sosv
			)
--lời gọi:
select * from dbo.func_DS_MonHoc_SV_DKThi_Sosv(4)

--o.Viết hàm để lấy ra danh sách học viên cùng với điểm trung bình của các học viên. Nếu
--học viên nào chưa có điểm thì ghi 0.
create function func_DTB_0()
returns table
as
return (
    select Students.StudentID, Students.StudentName, isnull (avg(Mark),0) as DTB
    from Students left join Marks on Students.StudentID = Marks.StudentID
	group by Students.StudentID, Students.StudentName
)
--lời gọi:
select * from dbo.func_DTB_0()