USE QLPKNKHOA
GO

-- TAO THONG TIN CHI TIET THANH TOAN
CREATE OR ALTER PROCEDURE P_CREATE_CHITIET
	@ID_HoSo varchar(10),
	@NgayGiaoDich datetime,
	@NguoiThanhToan nvarchar(30),
	@LoaiThanhToan nvarchar(30),
	@GhiChu nvarchar(30),
	@ID_ThanhToan varchar(10) = NULL
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM HoSoBenhNhan WHERE ID_HoSo = @ID_HoSo)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THONG TIN HO SO BENH NHAN SAI XOT', 16
			RETURN
		END

		SET @ID_ThanhToan = (SELECT MAX(ID_ThanhToan) FROM ThongTinChiTietThanhToan)
		SET @ID_ThanhToan = DBO.F_AUTO_GENERATED_ID('CT', @ID_ThanhToan)
		IF @NgayGiaoDich IS NULL SET @NgayGiaoDich = GETDATE()

		BEGIN TRY
			INSERT ThongTinChiTietThanhToan(ID_ThanhToan, ID_HoSo, NgayGiaoDich, NguoiThanhToan, TongTien, TienDaTra, TienThoi, LoaiThanhToan, GhiChu)
				VALUES (@ID_ThanhToan, @ID_HoSo, @NgayGiaoDich, @NguoiThanhToan, 0, 0, 0, @LoaiThanhToan, @GhiChu)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT
	PRINT 'THEM THONG TIN CHI TIET THANH TOAN THANH CONG'
GO

-- CAP NHAT THONG TIN CHI TIET THANH TOAN
CREATE OR ALTER PROCEDURE P_UPDATE_CHITIET
	@ID_ThanhToan varchar(10),
	@NgayGiaoDich datetime,
	@NguoiThanhToan nvarchar(30),
	@TienDaTra int,
	@LoaiThanhToan nvarchar(30),
	@GhiChu nvarchar(30)
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM ThongTinChiTietThanhToan WHERE ID_ThanhToan = @ID_ThanhToan)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID CHI TIET THANH TOAN KHONG HOP LE', 16
			RETURN
		END

		DECLARE
		@CurNgayGiaoDich datetime,
		@CurNguoiThanhToan nvarchar(30),
		@CurLoaiThanhToan nvarchar(30)

		SELECT @CurNgayGiaoDich = NgayGiaoDich, @CurNguoiThanhToan = NguoiThanhToan, @CurLoaiThanhToan = LoaiThanhToan
		FROM ThongTinChiTietThanhToan
		WHERE ID_ThanhToan = @ID_ThanhToan

		IF @NgayGiaoDich IS NULL SET @NgayGiaoDich = @CurNgayGiaoDich

		IF @NguoiThanhToan IS NULL
		BEGIN
			IF @CurNguoiThanhToan IS NULL
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'VUI LONG DIEN NGUOI THANH TOAN', 16
				RETURN
			END
			ELSE SET @NguoiThanhToan = @CurNguoiThanhToan
		END

		IF @TienDaTra IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'VUI LONG DIEN SO TIEN THANH TOAN', 16
			RETURN
		END

		IF @LoaiThanhToan IS NULL
		BEGIN
			IF @CurLoaiThanhToan IS NULL
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'VUI LONG DIEN LOAI THANH TOAN', 16
				RETURN
			END
			ELSE SET @LoaiThanhToan = @CurLoaiThanhToan
		END

		DECLARE @TienThoi INT
		SET @TienThoi = @TienDaTra - (SELECT TongTien FROM ThongTinChiTietThanhToan WHERE ID_ThanhToan = @ID_ThanhToan)

		BEGIN TRY
			UPDATE ThongTinChiTietThanhToan
			SET NgayGiaoDich = @NgayGiaoDich, NguoiThanhToan = @NguoiThanhToan,
				TienDaTra = @TienDaTra, TienThoi = @TienThoi, LoaiThanhToan = @LoaiThanhToan,  GhiChu = @GhiChu
			WHERE ID_ThanhToan = @ID_ThanhToan
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT
	PRINT 'CAP NHAT THONG TIN CHI TIET THANH TOAN THANH CONG'
GO