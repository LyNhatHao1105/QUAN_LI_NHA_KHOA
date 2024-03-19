﻿USE QLPKNKHOA
GO

-- TAO HO SO BENH NHAN
CREATE OR ALTER PROCEDURE P_CREATE_HOSOBENHNHAN
	@ThongTinTongQuanSK nvarchar(100),
	@GhiChuChongChiDinhThuoc nvarchar(100),
	@ID_BenhNhan varchar(10),
	@ID_HoSo varchar(10) = NULL OUTPUT
AS
	BEGIN TRAN
		IF EXISTS (SELECT * FROM HoSoBenhNhan WHERE ID_BenhNhan = @ID_BenhNhan)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'BENH NHAN DA CO SAN HO SO BENH NHAN', 16
			RETURN
		END

		IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_BenhNhan AND ID_TaiKhoan LIKE 'BN%')
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'KHONG CO BENH NHAN TREN HE THONG', 16
			RETURN
		END

		IF @ThongTinTongQuanSK IS NULL OR @GhiChuChongChiDinhThuoc IS NULL OR @ID_BenhNhan IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'VUI LONG DIEN DAY DU THONG TIN', 16
			RETURN
		END

		SELECT @ID_HoSo = (SELECT MAX(ID_HoSo) FROM HoSoBenhNhan)

		SET @ID_HoSo = dbo.F_AUTO_GENERATED_ID('HS' , @ID_HoSo)

		BEGIN TRY
			INSERT HoSoBenhNhan(ID_HoSo, ThongTinTongQuanSK, GhiChuChongChiDinhThuoc, ID_BenhNhan)
				VALUES (@ID_HoSo, @ThongTinTongQuanSK, @GhiChuChongChiDinhThuoc, @ID_BenhNhan)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT
	PRINT 'THEM HO SO BENH NHAN THANH CONG'
GO

-- CAP NHAT HO SO BENH NHAN
CREATE OR ALTER PROCEDURE P_UPDATE_HOSOBENHNHAN
	@ID_HoSo varchar(10),
	@ThongTinTongQuanSK nvarchar(100),
	@GhiChuChongChiDinhThuoc nvarchar(100)
AS
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM HoSoBenhNhan WHERE ID_HoSo = @ID_HoSo)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID HO SO KHONG HOP LE', 16
			RETURN
		END

		BEGIN TRY
			UPDATE HoSoBenhNhan
			SET ThongTinTongQuanSK = @ThongTinTongQuanSK, GhiChuChongChiDinhThuoc = @GhiChuChongChiDinhThuoc
			WHERE ID_HoSo = @ID_HoSo
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	COMMIT;
	PRINT 'CAP NHAT HO SO BENH NHAN THANH CONG'
GO