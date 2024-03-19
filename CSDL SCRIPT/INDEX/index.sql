use QLPKNKHOA
go


--lay thong tin theo ho ten, sdt
CREATE NONCLUSTERED INDEX IX_TaiKhoan_HoTen
ON TaiKhoan (HoTen);

CREATE NONCLUSTERED INDEX IX_TaiKhoan_SDT
ON TaiKhoan (SDT);

--dang nhap
CREATE NONCLUSTERED INDEX IX_TaiKhoan_TenTaiKhoan
ON TaiKhoan (TenTaiKhoan);


--tim thuoc theo ten
CREATE NONCLUSTERED INDEX IX_Thuoc_TenThuoc
ON Thuoc (TenThuoc);


--lay thong tin chi tiet thanh toan theo id ho so
CREATE NONCLUSTERED INDEX IX_ThongTinChiTietThanhToan_ID_HoSo
ON ThongTinChiTietThanhToan (ID_HoSo);


--lay thong tin lich hen tu id nha si
CREATE NONCLUSTERED INDEX IX_LichHen_ID_NhaSi
ON LichHen (ID_NhaSi) 


--lay thong tin ke hoach dieu tri tu idthanhtoan va idhoso
CREATE NONCLUSTERED INDEX IX_KeHoachDieuTri_ID_ThanhToan
ON KeHoachDieuTri (ID_ThanhToan)

CREATE NONCLUSTERED INDEX IX_KeHoachDieuTri_ID_HoSo
ON KeHoachDieuTri (ID_HoSo)