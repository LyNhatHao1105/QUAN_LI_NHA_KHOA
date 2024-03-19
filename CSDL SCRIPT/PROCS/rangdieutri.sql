USE QLPKNKHOA
GO

-- TAO RANG DIEU TRI
CREATE OR ALTER PROCEDURE P_CREATE_RANGDIEUTRI
	@ID_KHDieuTri varchar(10),
	@ID_Rang varchar(10),
	@ID_MatRang varchar(10)
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM KeHoachDieuTri WHERE ID_KHDieuTri = @ID_KHDieuTri)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID KE HOACH DIEU TRI KHONG DUNG', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM Rang WHERE ID_Rang = @ID_Rang)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID RANG KHONG DUNG', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM MatRang WHERE ID_MatRang = @ID_MatRang)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID MAT RANG KHONG TON TAI', 16
			RETURN
		END

		IF EXISTS (SELECT * FROM RangDieuTri WHERE ID_KHDieuTri = @ID_KHDieuTri AND ID_Rang = @ID_Rang AND ID_MatRang = @ID_MatRang)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'KE HOACH RANG DA TON TAI', 16
			RETURN
		END

		DECLARE @PhiDichVu INT
		SELECT @PhiDichVu = (SELECT PhiDichVu FROM Rang WHERE ID_Rang = @ID_Rang)

		BEGIN TRY
			INSERT RangDieuTri(ID_KHDieuTri, ID_Rang, ID_MatRang, PhiDichVu)
				VALUES (@ID_KHDieuTri, @ID_Rang, @ID_MatRang, @PhiDichVu)

			UPDATE KeHoachDieuTri
			SET PhiDieuTri = PhiDieuTri + @PhiDichVu
			WHERE ID_KHDieuTri = @ID_KHDieuTri

			DECLARE @ID_ThanhToan varchar(10)
			SET @ID_ThanhToan = (SELECT ID_ThanhToan FROM KeHoachDieuTri WHERE ID_KHDieuTri = @ID_KHDieuTri)
			UPDATE ThongTinChiTietThanhToan
			SET TongTien = TongTien + @PhiDichVu
			WHERE ID_ThanhToan = @ID_ThanhToan
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT
	PRINT 'THEM RANG DIEU TRI THANH CONG'
GO

-- CAP NHAT RANG DIEU TRI
CREATE OR ALTER PROCEDURE P_UPDATE_RANGDIEUTRI
	@ID_CurKHDieuTri varchar(10),
	@ID_CurRang varchar(10),
	@ID_CurMatRang varchar(10),
	@ID_NewRang varchar(10),
	@ID_NewMatRang varchar(10)
AS
	BEGIN TRAN
		IF NOT EXISTS (SELECT * FROM Rang WHERE ID_Rang = @ID_NewRang)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID RANG KHONG DUNG', 16
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM MatRang WHERE ID_MatRang = @ID_NewMatRang)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'ID MAT RANG KHONG TON TAI', 16
			RETURN
		END

		DECLARE @PhiDichVu INT
		SELECT @PhiDichVu = (SELECT PhiDichVu FROM Rang WHERE ID_Rang = @ID_NewRang)

		BEGIN TRY
			UPDATE RangDieuTri
			SET ID_Rang = @ID_NewRang, ID_MatRang = @ID_NewMatRang, PhiDichVu = @PhiDichVu
			WHERE ID_KHDieuTri = @ID_CurKHDieuTri AND ID_Rang = @ID_CurRang AND ID_MatRang = @ID_CurMatRang
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH

	COMMIT
	PRINT 'CAP NHAT RANG DIEU TRI THANH CONG'
GO