USE QLPKNKHOA
GO

-- TAO TAI KHOAN
CREATE OR ALTER PROCEDURE P_CREATE_ACCOUNT
	@HoTen nvarchar(30),
	@DiaChi nvarchar(100),
	@SDT varchar(11),
	@Email varchar(50),
	@NgaySinh date,
	@GioiTinh varchar(10),
	@TenTaiKhoan varchar(30),
	@MatKhau varchar(30),
	@ID_QTV varchar(10),
	@TypeTaiKhoan char(2),
	@ID_TaiKhoan varchar(10) = NULL OUTPUT
AS
	BEGIN TRAN
		IF EXISTS(SELECT * FROM TaiKhoan WHERE @SDT = SDT)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'TAI KHOAN DA TON TAI', 16
			RETURN
		END

		IF @ID_QTV IS NOT NULL
		BEGIN
			IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_QTV)
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'QTV KHONG TON TAI', 16
				RETURN
			END
		END

		IF @GioiTinh != 'Nam' AND @GioiTinh != 'Nu'
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'GIOI TINH PHAI LA NAM HOAC NU', 16
			RETURN
		END

		SELECT @ID_TaiKhoan = ID_TaiKhoan 
		FROM TaiKhoan
		WHERE ID_TaiKhoan = (SELECT MAX(ID_TaiKhoan) FROM TaiKhoan WHERE ID_TaiKhoan LIKE @TypeTaiKhoan + '%')

		SET @ID_TaiKhoan = dbo.F_AUTO_GENERATED_ID(@TypeTaiKhoan, @ID_TaiKhoan)

		BEGIN TRY
			INSERT TaiKhoan(ID_TaiKhoan, HoTen, DiaChi, SDT, Email, NgaySinh, GioiTinh, TenTaiKhoan, MatKhau, ID_QTV, TypeTaiKhoan)
				VALUES (@ID_TaiKhoan, @HoTen, @DiaChi, @SDT, @Email, @NgaySinh, @GioiTinh, @TenTaiKhoan, @MatKhau, @ID_QTV, @TypeTaiKhoan)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'THEM TAI KHOAN THANH CONG'
GO

-- UPDATE TAI KHOAN
CREATE OR ALTER PROCEDURE P_UPDATE_ACCOUNT
	@ID_TaiKhoan varchar(10),
	@HoTen nvarchar(30),
	@DiaChi nvarchar(100),
	@SDT varchar(11),
	@Email varchar(50),
	@NgaySinh date,
	@GioiTinh varchar(10),
	@TenTaiKhoan varchar(30),
	@MatKhau varchar(30),
	@ID_QTV varchar(10)
AS
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_TaiKhoan)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID TAI KHOAN KHONG HOP LE', 16
			RETURN
		END

		DECLARE
		@CurHoTen nvarchar(30),
		@CurDiaChi nvarchar(100),
		@CurSDT varchar(11),
		@CurEmail varchar(50),
		@CurNgaySinh date,
		@CurGioiTinh varchar(10),
		@CurTenTaiKhoan varchar(30),
		@CurMatKhau varchar(30),
		@CurID_QTV varchar(10);

		SELECT @CurHoTen = HoTen, @CurDiaChi = DiaChi, @CurSDT = SDT, @CurEmail = Email,
			@CurNgaySinh = NgaySinh,@CurGioiTinh = GioiTinh,
			@CurTenTaiKhoan =TenTaiKhoan, @CurMatKhau = MatKhau, @CurID_QTV = ID_QTV
		FROM TaiKhoan
		WHERE ID_TaiKhoan = @ID_TaiKhoan

		IF EXISTS(SELECT * FROM TaiKhoan WHERE SDT = @SDT AND @SDT != @CurSDT)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'SDT DA DUOC SU DUNG', 16
			RETURN
		END

		IF @ID_QTV IS NOT NULL 
		BEGIN
			IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_QTV)
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'QTV KHONG TON TAI', 16
				RETURN
			END
		END

		IF @GioiTinh != 'Nam' AND @GioiTinh != 'Nu'
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'GIOI TINH PHAI LA NAM HOAC NU', 16
			RETURN
		END

		IF @HoTen IS NULL SET @HoTen = @CurHoTen
		IF @DiaChi IS NULL SET @DiaChi = @CurDiaChi
		IF @SDT IS NULL SET @SDT = @CurSDT
		IF @Email IS NULL SET @Email = @CurEmail
		IF @NgaySinh IS NULL SET @NgaySinh = @CurNgaySinh
		IF @GioiTinh IS NULL SET @GioiTinh = @CurGioiTinh
		IF @TenTaiKhoan IS NULL SET @TenTaiKhoan = @CurTenTaiKhoan
		IF @MatKhau IS NULL SET @MatKhau = @CurMatKhau

		BEGIN TRY
			UPDATE TaiKhoan
			SET HoTen = @HoTen, DiaChI = @DiaChi, SDT = @SDT, Email = @Email, NgaySinh = @NgaySinh, GioiTinh = @GioiTinh,
				TenTaiKhoan = @TenTaiKhoan,MatKhau = @MatKhau, ID_QTV = @ID_QTV
			WHERE ID_TaiKhoan = @ID_TaiKhoan
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT;
	PRINT 'CAP NHAT TAI KHOAN THANH CONG'
GO
