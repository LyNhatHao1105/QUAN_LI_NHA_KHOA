USE QLPKNKHOA
GO

--THEM LICH HEN
CREATE OR ALTER PROC P_THEM_LICHHEN
	@ThoiGianHen datetime,
	@TinhTrang nvarchar(30),
	@ID_BenhNhan varchar(10),
	@ID_NhaSi varchar(10),
	@ID_PhongKham varchar(10),
	@ID_NV varchar(10),
	@ID_TroKham varchar(10),
	@ID_LichHen varchar(10) = NULL OUTPUT

AS 
	BEGIN TRAN
		IF (SELECT CONVERT(VARCHAR, @ThoiGianHen, 103)) =
			(SELECT CONVERT(VARCHAR, (SELECT ThoiGianTrong FROM LichBacSi WHERE ID_NhaSi = @ID_NhaSi), 103))
			OR (SELECT CONVERT(VARCHAR, @ThoiGianHen, 103)) =
				(SELECT CONVERT(VARCHAR, (SELECT ThoiGianTrong FROM LichBacSi WHERE ID_NhaSi = @ID_TroKham), 103))
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'NHA SI DA CO LICH HEN VAO THOI GIAN TREN', 16
			RETURN
		END

		IF @ThoiGianHen <  GETDATE()
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THOI GIAN HEN PHAI TRONG TUONG LAI', 16
			RETURN
		END

		IF @ThoiGianHen IS NULL OR @TinhTrang IS NULL OR @ID_BenhNhan IS NULL OR 
			@ID_NhaSi IS NULL OR @ID_PhongKham IS NULL OR @ID_NV IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'VUI LONG DIEN DAY DU THONG TIN', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_BenhNhan) 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'BENH NHAN KHONG TON TAI', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_NhaSi) 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'NHA SI KHONG TON TAI', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM PhongKham WHERE ID_PhongKham = @ID_PhongKham) 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'PHONG KHAM KHONG TON TAI', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_NV) 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'NHAN VIEN KHONG TON TAI', 16
			RETURN
		END	
	
		SELECT @ID_LichHen = (SELECT MAX(ID_LichHen) FROM LichHen)
		SET @ID_LichHen = dbo.F_AUTO_GENERATED_ID('LH', @ID_LichHen)

		BEGIN TRY
			INSERT LichHen(ThoiGianHen, ID_LichHen, TinhTrang, ID_BenhNhan,ID_NhaSi, ID_PhongKham, ID_NV, ID_TroKham )
				VALUES (@ThoiGianHen, @ID_LichHen, @TinhTrang, @ID_BenhNhan,@ID_NhaSi, @ID_PhongKham,@ID_NV, @ID_TroKham)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			;THROW 51000, 'LOI HE THONG', 16
			RETURN
		END CATCH
		
	COMMIT
	PRINT 'THEM LICH HEN THANH CONG'
GO

-- UPDATE LICH HEN
CREATE OR ALTER PROCEDURE P_UPDATE_LICHHEN
	@ID_LichHen varchar(10),
	@ThoiGianHen datetime,
	@TinhTrang nvarchar(30),
	@ID_BenhNhan varchar(10),
	@ID_NhaSi varchar(10),
	@ID_PhongKham varchar(10),
	@ID_NV varchar(10),
	@ID_TroKham varchar(10)
AS
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM LichHen WHERE ID_LichHen = @ID_LichHen)
		BEGIN
			;THROW 50000, 'ID LICH HEN KHONG HOP LE', 16
			ROLLBACK TRAN;
			RETURN
		END

		DECLARE
			@curThoiGianHen datetime,
			@curTinhTrang nvarchar(30),
			@curID_BenhNhan varchar(10),
			@curID_NhaSi varchar(10),
			@curID_PhongKham varchar(10),
			@curID_NV varchar(10),
			@curID_TroKham varchar(10)

		SELECT @curThoiGianHen = ThoiGianHen, @curTinhTrang = TinhTrang, @curID_BenhNhan = ID_BenhNhan,
			@curID_NhaSi =ID_NhaSi, @curID_PhongKham = ID_PhongKham, @curID_NV = ID_NV, @curID_TroKham = ID_TroKham
		FROM LichHen
		WHERE ID_LichHen = @ID_LichHen

		IF @ThoiGianHen IS NULL SET @ThoiGianHen = @curThoiGianHen
		IF @TinhTrang IS NULL SET @TinhTrang = @curTinhTrang
		IF @ID_BenhNhan IS NULL SET @ID_BenhNhan = @curID_BenhNhan
		IF @ID_NhaSi IS NULL SET @ID_NhaSi = @curID_NhaSi
		IF @ID_PhongKham IS NULL SET @ID_PhongKham = @curID_PhongKham
		IF @ID_NV IS NULL SET @ID_NV = @curID_NV

		IF EXISTS(SELECT * FROM LichBacSi WHERE ID_NhaSi = @ID_NhaSi AND ThoiGianTrong = @ThoiGianHen)
		BEGIN
			ROLLBACK TRAN;
			;THROW 500000, 'THOI GIAN NAY NHA SI DA CO LICH HEN', 16
			RETURN
		END

		IF EXISTS(SELECT * FROM LichBacSi WHERE ID_NhaSi = @ID_TroKham AND ThoiGianTrong = @ThoiGianHen)
		BEGIN
			ROLLBACK TRAN;
			;THROW 500000, 'THOI GIAN NAY NHA SI TRO KHAM DA CO LICH HEN', 16
			RETURN
		END

		IF @ID_BenhNhan IS NOT NULL 
		BEGIN
			IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_BenhNhan AND ID_TaiKhoan LIKE 'BN%')
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'ID BENH NHAN KHONG TON TAI', 16
				RETURN
			END
		END

		IF @ID_NhaSi IS NOT NULL 
		BEGIN
			IF NOT EXISTS(SELECT * FROM TaiKhoan WHERE ID_TaiKhoan = @ID_NhaSi AND ID_TaiKhoan LIKE 'NS%')
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'ID NHA SI KHONG TON TAI', 16
				RETURN
			END
		END

		IF @ID_PhongKham IS NOT NULL 
		BEGIN
			IF NOT EXISTS(SELECT * FROM PhongKham WHERE ID_PhongKham = @ID_PhongKham)
			BEGIN
				ROLLBACK TRAN;
				;THROW 50000, 'ID PHONG KHAM KHONG TON TAI', 16
				RETURN
			END
		END

		BEGIN TRY
			UPDATE LichHen
			SET ThoiGianHen = @ThoiGianHen, TinhTrang = @TinhTrang, ID_BenhNhan = @ID_BenhNhan, 
				ID_NhaSi = @ID_NhaSi, ID_PhongKham = @ID_PhongKham, ID_NV = @ID_NV,
				ID_TroKham = @ID_TroKham
			WHERE ID_LichHen = @ID_LichHen
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT;
	PRINT 'CAP NHAT LICH HEN THANH CONG'
GO

-- XOA LICH HEN
CREATE OR ALTER PROC P_DELETE_LICHHEN
	@ID_LichHen varchar(10)

AS 
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM LichHen WHERE ID_LichHen = @ID_LichHen) 
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'LICH HEN KHONG TON TAI', 16
			RETURN
		END

		BEGIN TRY
			DELETE FROM LichHen
				WHERE ID_LichHen = @ID_LichHen
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			;THROW 51000, 'LOI HE THONG', 16
			RETURN
		END CATCH
		
	COMMIT
	PRINT 'XOA LICH HEN THANH CONG'
GO

-- XEM LICH HEN
CREATE OR ALTER PROC P_XEM_LICHHEN
	@ID_BenhNhan varchar(10),
	@ID_NhaSi varchar(10),
	@ThoiGianHen datetime

AS 
	IF NOT EXISTS (SELECT * FROM LichHen WHERE ID_BenhNhan = @ID_BenhNhan) 
	BEGIN
		;THROW 50000, 'LICH HEN KHONG TON TAI', 16
		RETURN
	END

	IF NOT EXISTS (SELECT * FROM LichHen WHERE ID_NhaSi = @ID_NhaSi) 
	BEGIN
		;THROW 50000, 'LICH HEN KHONG TON TAI', 16
		RETURN
	END

	BEGIN TRY
		SELECT ID_BenhNhan AS N'ID Bệnh Nhân', ID_NhaSi AS N'ID Nha Sĩ', ThoiGianHen AS N'Thời gian hẹn' FROM LichHen 
		WHERE ID_BenhNhan = @ID_BenhNhan OR ID_NhaSi = @ID_NhaSi OR ThoiGianHen = @ThoiGianHen
	END TRY
	BEGIN CATCH
		;THROW 51000, 'LOI HE THONG', 16
		RETURN
	END CATCH
GO