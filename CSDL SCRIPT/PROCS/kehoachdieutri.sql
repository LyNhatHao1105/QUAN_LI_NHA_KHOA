USE QLPKNKHOA
GO

-- TAO THONG TIN KE HOACH DIEU TRI
CREATE OR ALTER PROCEDURE P_CREATE_KHDIEUTRI
	@MoTa nvarchar(50),
	@NgayDieuTri datetime,
	@GhiChu nvarchar(50),
	@TrangThai nvarchar(30),
	@ID_HoSo varchar(10),
	@ID_BacSiThucHien varchar(10),
	@ID_BacSiTroKham varchar(10),
	@ID_DanhMuc varchar(10),
	@ID_ThanhToan varchar(10),
	@ID_KHDieuTri varchar(10) = NULL
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM HoSoBenhNhan WHERE ID_HoSo = @ID_HoSo)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID HO SO KHONG HOP LE', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_BacSiThucHien AND ID_TaiKhoan LIKE 'NS%')
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID BAC SI THUC HIEN KHONG HOP LE', 16
			RETURN
		END

		IF @ID_BacSiTroKham IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_BacSiTroKham AND ID_TaiKhoan LIKE 'NS%')
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'ID BAC SI TRO KHAM KHONG HOP LE', 16
				RETURN
			END
		END

		IF NOT EXISTS (SELECT * FROM DanhMucDieuTri WHERE ID_DanhMuc = @ID_DanhMuc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID DANH MUC DIEU TRI KHONG HOP LE', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM ThongTinChiTietThanhToan WHERE ID_ThanhToan = @ID_ThanhToan)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID THANH TOAN CHI TIET KHONG HOP LE', 16
			RETURN
		END

		IF @MoTa IS NULL OR @TrangThai IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THIEU THONG TIN MO TA HOAC TRANG THAI', 16
			RETURN
		END

		IF @NgayDieuTri IS NULL SET @NgayDieuTri = GETDATE()

		SELECT @ID_KHDieuTri = (SELECT MAX(ID_KHDieuTri) FROM KeHoachDieuTri)
		SET @ID_KHDieuTri = DBO.F_AUTO_GENERATED_ID('KH', @ID_KHDieuTri)

		BEGIN TRY
			INSERT KeHoachDieuTri(ID_KHDieuTri, MoTa, NgayDieuTri, GhiChu, TrangThai, PhiDieuTri, ID_HoSo, 
				ID_BacSiThucHien, ID_BacSiTroKham, ID_DanhMuc, ID_ThanhToan)
				VALUES (@ID_KHDieuTri, @MoTa, @NgayDieuTri, @GhiChu, @TrangThai, 0, @ID_HoSo,
						@ID_BacSiThucHien, @ID_BacSiTroKham, @ID_DanhMuc, @ID_ThanhToan)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT
	PRINT 'THEM KE HOACH DIEU TRI THANH CONG'
GO