USE QLPKNKHOA
GO

--THEM PHONG KHAM
CREATE OR ALTER PROC P_THEM_PHONG_KHAM
	@Dchi nvarchar(100),
	@SDT varchar(11),
	@Email varchar(50),
	@ID_PhongKham varchar(10) = null OUTPUT

AS 
	BEGIN TRAN
		IF EXISTS (SELECT * FROM PhongKham WHERE Dchi = @Dchi OR SDT = @SDT OR Email = @Email)
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'THONG TIN NHAP DA TRUNG VOI PHONG KHAM KHAC', 16
			RETURN
		END

		IF @Dchi IS NULL OR @SDT IS NULL OR @Email IS NULL
		BEGIN
			ROLLBACK TRAN;
			;THROW 50000, 'VUI LONG DIEN DAY DU THONG TIN PHONG KHAM', 16
			RETURN
		END

		declare @Type char(2) = 'PK'

		SELECT @ID_PhongKham = (SELECT MAX(ID_PhongKham) FROM PhongKham)
		SET @ID_PhongKham = dbo.F_AUTO_GENERATED_ID(@Type, @ID_PhongKham)

		BEGIN TRY
			INSERT PhongKham(ID_PhongKham, Dchi, SDT, Email)
				VALUES (@ID_PhongKham, @Dchi, @SDT, @Email)
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 51000, 'LOI HE THONG', 16
		END CATCH
	
	COMMIT
	PRINT 'THEM PHONG KHAM THANH CONG'		
GO