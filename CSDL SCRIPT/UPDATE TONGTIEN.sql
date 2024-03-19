USE QLPKNKHOA
GO

UPDATE KeHoachDieuTri
SET PhiDieuTri = (SELECT SUM(PhiDichVu) FROM RangDieuTri WHERE ID_KHDieuTri = KeHoachDieuTri.ID_KHDieuTri)
+ (SELECT SUM(ThanhTien) FROM DonThuoc WHERE ID_KHDieuTri = KeHoachDieuTri.ID_KHDieuTri)

UPDATE ThongTinChiTietThanhToan
SET TongTien = (SELECT Sum(PhiDieuTri) FROM KeHoachDieuTri WHERE ID_ThanhToan = ThongTinChiTietThanhToan.ID_ThanhToan)