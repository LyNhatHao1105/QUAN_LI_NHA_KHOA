USE QLPKNKHOA
GO

-- TAO THUOC
CREATE OR ALTER PROCEDURE P_CREATE_DONTHUOC
	@ID_KHDieuTri varchar(10),
	@ID_Thuoc varchar(10),
	@SoLuongThuoc int
AS
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM KeHoachDieuTri WHERE ID_KHDieuTri = @ID_KHDieuTri)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'KE HOACH DIEU TRI KHONG DUNG', 16
			RETURN
		END

		IF NOT EXISTS(SELECT * FROM Thuoc WHERE ID_Thuoc = @ID_Thuoc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THUOC KHONG TON TAI', 16
			RETURN
		END

		IF @ID_KHDieuTri IS NULL OR @ID_Thuoc IS NULL OR @SoLuongThuoc IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THONG TIN KHONG DAY DU', 16
			RETURN
		END

		IF @SoLuongThuoc <= 0 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'SO LUONG THUOC PHAI LON HON 0', 16
			RETURN
		END

		DECLARE @ThanhTien INT
		SET @ThanhTien = @SoLuongThuoc * (SELECT DonGia FROM Thuoc WHERE ID_Thuoc = @ID_Thuoc)

		BEGIN TRY
			INSERT DonThuoc(ID_KHDieuTri, ID_Thuoc, SoLuongThuoc, ThanhTien)
				VALUES (@ID_KHDieuTri, @ID_Thuoc, @SoLuongThuoc, @ThanhTien)

			UPDATE KeHoachDieuTri
			SET PhiDieuTri = PhiDieuTri + @ThanhTien
			WHERE ID_KHDieuTri = @ID_KHDieuTri

			DECLARE @ID_ThanhToan varchar(10)
			SET @ID_ThanhToan = (SELECT ID_ThanhToan FROM KeHoachDieuTri WHERE ID_KHDieuTri = @ID_KHDieuTri)
			UPDATE ThongTinChiTietThanhToan
			SET TongTien = TongTien + @ThanhTien
			WHERE ID_ThanhToan = @ID_ThanhToan
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'THEM DON THUOC THANH CONG'
GO