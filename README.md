https://docs.google.com/spreadsheets/d/18YKcDEaxvnBIJseha77pQ69tVsY-IbieXwGVm6JW4yg/edit?usp=sharing
Use case: Tạo mới một ghi chú
Actor: Người Dùng.
Bắt đầu: Người dùng đã đăng nhập thành công vào hệ thống.
  Bước 1: Người dùng chọn chức năng "Tạo ghi chú" trong ứng dụng.
  Bước 2: Hệ thống yêu cầu người dùng chọn loại ghi chú cần tạo:
•	Ghi chú văn bản 
•	Ghi chú hình ảnh 
•	Ghi chú danh sách công việc 
  Bước 3:
•	Nếu người dùng chọn “ghi chú văn bản”, hệ thống yêu cầu người dùng nhập tiêu đề và nội dung văn bản.
•	Nếu người dùng chọn “ghi chú hình ảnh” hệ thống yêu cầu người dùng chọn hình ảnh và nhập chú thích.
•	Nếu người dùng chọn “ghi chú danh sách công việc” hệ thống yêu cầu người dùng nhập tiêu đề và các công việc cần làm.
  Bước 4: Người dùng nhấn "Lưu" để tạo ghi chú mới.
  Bước 5: Hệ thống kiểm tra dữ liệu nhập vào:
•	Nếu dữ liệu hợp lệ (tiêu đề và nội dung không trống), hệ thống lưu ghi chú vào cơ sở dữ liệu.
•	Nếu có lỗi (thiếu thông tin bắt buộc), hệ thống hiển thị thông báo lỗi và yêu cầu người dùng nhập lại.
  Bước 6: Hệ thống thông báo ghi chú đã được tạo thành công và hiển thị ghi chú trong danh sách ghi chú của người dùng.
*Mở rộng:
•	Ghi chú hình ảnh: Nếu người dùng không chọn hình ảnh hoặc hình ảnh không hợp lệ, hệ thống sẽ yêu cầu người dùng chọn lại hình ảnh hợp lệ.
•	Ghi chú checklist: Nếu người dùng không nhập công việc trong danh sách checklist, hệ thống sẽ yêu cầu ít nhất một công việc.
*Lỗi: Nếu người dùng nhập dữ liệu thiếu hoặc sai, hệ thống sẽ hiển thị thông báo lỗi và yêu cầu người dùng nhập lại thông tin đầy đủ.
Viết thủ tục cho use case tạo ghi chú mới:
-	Trong bảng GhiChu, thuộc tính LoaiGhiChu = 0 thì là ghi chú dạng văn bản, LoaiGhiChu = 1 là ghi chú dạng hình ảnh, LoaiGhiChu = 2 là ghi chú danh sách công việc cần làm.
Create Type DanhSachCongViec
(
	IDCongViec int,
	IDGhiChu int,
TenCongViec nvarchar(255),
HoanThanhCongViec bit	
)
go
Create procedure TaoGhiChu(@TieuDe nvarchar(255), @MauSac nvarchar(20), @XoaTamThoi bit, @IDNguoiDung int, @LoaiGhiChu int, @NoiDungVanBan text, @DuongDanDenHinhAnh text, @DSCongViec DanhSachCongViec)
as 
begin
	if @LoaiGhiChu = 0
		begin
			insert into GhiChu(TieuDe, MauSac, XoaTamThoi, IDNguoiDung, LoaiGhiChu, NoiDungVanBan)
			values(@TieuDe, @MauSac, @XoaTamThoi, @MaNguoiDung, 0, @NoiDungVanBan);
			return;
		end
	if @LoaiGhiChu = 1
		begin
			insert into GhiChu(TieuDe, MauSac, XoaTamThoi, IDNguoiDung, LoaiGhiChu, DuongDanDenHinhAnh)
			values(@TieuDe, @MauSac, @XoaTamThoi, @MaNguoiDung, 1, @DuongDanHinhAnh);
			return;

		end
	if @LoaiGhiChu = 2
		begin
			insert into GhiChu(TieuDe, MauSac, XoaTamThoi, IDNguoiDung, LoaiGhiChu)
			values(@TieuDe, @MauSac, @XoaTamThoi, @MaNguoiDung, 2);

			Declare tmp int = @@Identity;
			insert into CongViec(TenCongViec, HoanThanhCongViec, IDGhiChu)
			select TenCongViec, HoanThanhCongViec, @tmp
from DSCongViec;
return;
		end
end
