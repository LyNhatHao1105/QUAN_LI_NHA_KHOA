USE QLPKNKHOA
GO

-- TAO THUOC
CREATE OR ALTER PROCEDURE P_CREATE_THUOC
	@ID_QTV varchar(10),
	@TenThuoc nvarchar(30),
	@DonViTinh nvarchar(10),
	@ChiDinh nvarchar(30),
	@SoLuongTonKho int,
	@NgayHetHan date,
	@DonGia int,
	@ID_Thuoc varchar(10) = NULL OUTPUT
AS
	BEGIN TRAN
		IF EXISTS(SELECT * FROM Thuoc WHERE TenThuoc = @TenThuoc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THUOC DA TON TAI', 16
			RETURN
		END

		IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_QTV)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'QTV KHONG TON TAI', 16
			RETURN
		END

		IF @SoLuongTonKho <0 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'SO LUONG TON KHO PHAI LA SO KHONG AM', 16
			RETURN
		END

		IF @DonGia <0 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'DON GIA PHAI LA SO DUONG', 16
			RETURN
		END

		IF @NgayHetHan < GETDATE()
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'NGAY HET HAN PHAI TRONG TUONG LAI', 16
			RETURN
		END

		SELECT @ID_Thuoc = (SELECT MAX(ID_Thuoc) FROM Thuoc)

		SET @ID_Thuoc = dbo.F_AUTO_GENERATED_ID('TH' , @ID_Thuoc)

		BEGIN TRY
			INSERT Thuoc(ID_Thuoc, ID_QTV, TenThuoc, DonViTinh, ChiDinh, SoLuongTonKho, NgayHetHan, DonGia)
				VALUES (@ID_Thuoc, @ID_QTV, @TenThuoc, @DonViTinh, @ChiDinh, @SoLuongTonKho, @NgayHetHan, @DonGia)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'THEM THUOC THANH CONG'
GO

-- CAP NHAT THUOC
CREATE OR ALTER PROCEDURE P_UPDATE_THUOC
	@ID_Thuoc varchar(10),
	@TenThuoc nvarchar(30),
	@DonViTinh nvarchar(10),
	@ChiDinh nvarchar(30),
	@SoLuongTonKho int,
	@NgayHetHan date,
	@DonGia int

AS
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM Thuoc WHERE TenThuoc = @TenThuoc OR ID_Thuoc = @ID_Thuoc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THUOC KHONG TON TAI', 16
			RETURN
		END

		IF @SoLuongTonKho < 0 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'SO LUONG TON KHO PHAI LA SO KHONG AM', 16
			RETURN
		END

		IF @DonGia < 0 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'DON GIA PHAI LA SO DUONG', 16
			RETURN
		END

		IF @NgayHetHan < GETDATE()
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'NGAY HET HAN PHAI TRONG TUONG LAI', 16
			RETURN
		END

		DECLARE
			@CurTenThuoc nvarchar(30),
			@CurDonViTinh nvarchar(10),
			@CurChiDinh nvarchar(30),
			@CurSoLuongTonKho int,
			@CurNgayHetHan date,
			@CurDonGia int

		SELECT @CurTenThuoc = TenThuoc, @CurDonViTinh = DonViTinh, @CurSoLuongTonKho = SoLuongTonKho,
			@CurNgayHetHan = NgayHetHan , @CurDonGia = DonGia
		FROM Thuoc
		WHERE ID_Thuoc = @ID_Thuoc OR TenThuoc = @TenThuoc

		IF @TenThuoc IS NULL SET @TenThuoc = @CurTenThuoc
		IF @DonViTinh IS NULL SET @DonViTinh = @CurDonViTinh
		IF @ChiDinh IS NULL SET @ChiDinh = @CurChiDinh
		IF @SoLuongTonKho IS NULL SET @SoLuongTonKho = @CurSoLuongTonKho
		IF @NgayHetHan IS NULL SET @NgayHetHan = @CurNgayHetHan
		IF @DonGia IS NULL SET @DonGia = @CurDonGia

		BEGIN TRY
			UPDATE Thuoc
				SET TenThuoc = @TenThuoc, DonViTinh = @DonViTinh, ChiDinh = @ChiDinh, 
					SoLuongTonKho = @SoLuongTonKho, NgayHetHan = @NgayHetHan, DonGia = @DonGia
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'CAP NHAT THUOC THANH CONG'
GO

-- XOA THUOC
CREATE OR ALTER PROC SP_DELETE_THUOC
	@ID_Thuoc varchar(10)
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM Thuoc WHERE ID_Thuoc = @ID_Thuoc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THUOC KHONG TON TAI', 16
			RETURN
		END

		IF EXISTS (SELECT * FROM DonThuoc WHERE ID_Thuoc = @ID_Thuoc)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THUOC CO TRONG DON KHONG THE XOA', 16
			RETURN
		END

		BEGIN TRY
			DELETE FROM Thuoc WHERE ID_Thuoc = @ID_Thuoc
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'XOA THUOC THANH CONG'
GO