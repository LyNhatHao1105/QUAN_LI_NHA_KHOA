USE MASTER 
GO

IF DB_ID('QLPKNKHOA') IS NOT NULL
	DROP DATABASE QLPKNKHOA 
GO

CREATE DATABASE QLPKNKHOA
GO

USE QLPKNKHOA
GO

create table TaiKhoan
(
	ID_TaiKhoan varchar(10),
	HoTen nvarchar(30),
	DiaChi nvarchar(100),
	SDT varchar(11),
	Email varchar(50),
	NgaySinh date,
	GioiTinh varchar(10),
	TenTaiKhoan varchar(30),
	MatKhau varchar(30),
	ID_QTV varchar(10),
	TypeTaiKhoan char(2),
	PRIMARY KEY CLUSTERED (ID_TaiKhoan ASC),
	FOREIGN KEY (ID_QTV) REFERENCES TaiKhoan (ID_TaiKhoan),
)
go

create table PhongKham
(
	ID_PhongKham varchar(10),
	Dchi nvarchar(100),
	SDT varchar(11),
	Email varchar(50),
	PRIMARY KEY CLUSTERED (ID_PhongKham ASC),
)
go

create table LichBacSi
(
	ID_NhaSi varchar(10),
	ThoiGianTrong datetime,
	PRIMARY KEY CLUSTERED (ThoiGianTrong ASC, ID_NhaSi ASC),
	FOREIGN KEY (ID_NhaSi) REFERENCES TaiKhoan (ID_TaiKhoan),

)
go

create table HoSoBenhNhan
(
	ID_HoSo varchar(10),
	ThongTinTongQuanSK nvarchar(100),
	GhiChuChongChiDinhThuoc nvarchar(100),
	ID_BenhNhan varchar(10),
	PRIMARY KEY CLUSTERED (ID_HoSo ASC),
	FOREIGN KEY (ID_BenhNhan) REFERENCES TaiKhoan (ID_TaiKhoan),
)
go

CREATE TABLE DanhMucDieuTri (
	ID_DanhMuc varchar(10),
	TenDanhMuc nvarchar(50),

	CONSTRAINT PK_DanhMucDieuTri
	PRIMARY KEY(ID_DanhMuc)
)
GO

CREATE TABLE Rang (
	ID_Rang varchar(10),
	TenRang nvarchar(30),
	PhiDichVu int

	CONSTRAINT PK_Rang
	PRIMARY KEY(ID_Rang)
)
GO

CREATE TABLE MatRang (
	ID_MatRang varchar(10),
	TenMatRang nvarchar(30)

	CONSTRAINT PK_MatRang
	PRIMARY KEY(ID_MatRang)
)
GO

create table Thuoc
(
	ID_Thuoc varchar(10),
	ID_QTV varchar(10),
	TenThuoc nvarchar(30),
	DonViTinh nvarchar(10),
	ChiDinh nvarchar(30),
	SoLuongTonKho int,
	NgayHetHan date, 
	DonGia int
	PRIMARY KEY CLUSTERED (ID_Thuoc ASC),
	FOREIGN KEY (ID_QTV) REFERENCES TaiKhoan (ID_TaiKhoan),
)

create table LichHen
(
	ID_LichHen varchar(10),
	ThoiGianHen datetime,
	TinhTrang nvarchar(30),
	ID_BenhNhan varchar(10),
	ID_NhaSi varchar(10),
	ID_PhongKham varchar(10),
	ID_NV varchar(10),
	ID_TroKham varchar(10),
	PRIMARY KEY CLUSTERED (ID_LichHen ASC),
	FOREIGN KEY (ID_BenhNhan) REFERENCES TaiKhoan (ID_TaiKhoan),
	FOREIGN KEY (ID_NhaSi) REFERENCES TaiKhoan (ID_TaiKhoan),
	FOREIGN KEY (ID_NV) REFERENCES TaiKhoan (ID_TaiKhoan),
	FOREIGN KEY (ID_TroKham) REFERENCES TaiKhoan (ID_TaiKhoan),
	FOREIGN KEY (ID_PhongKham) REFERENCES PhongKham (ID_PhongKham),
)
go

CREATE TABLE ThongTinChiTietThanhToan (
	ID_ThanhToan varchar(10),
	ID_HoSo varchar(10),
	NgayGiaoDich datetime,
	NguoiThanhToan nvarchar(30),
	TongTien int,
	TienDaTra int,
	TienThoi int,
	LoaiThanhToan nvarchar(30),
	GhiChu nvarchar(30)

	CONSTRAINT PK_ThongTinChiTietThanhToan
	PRIMARY KEY(ID_ThanhToan),

	CONSTRAINT FK_ThongTinChiTietThanhToan_HoSoBenhNhan
	FOREIGN KEY(ID_HoSo)
	REFERENCES HoSoBenhNhan(ID_HoSo)
)
GO

CREATE TABLE KeHoachDieuTri (
	ID_KHDieuTri varchar(10),
	MoTa nvarchar(50),
	NgayDieuTri datetime,
	GhiChu nvarchar(50),
	TrangThai nvarchar(30),
	PhiDieuTri int,
	ID_HoSo varchar(10),
	ID_BacSiThucHien varchar(10),
	ID_BacSiTroKham varchar(10),
	ID_DanhMuc varchar(10),
	ID_ThanhToan varchar(10),

	CONSTRAINT PK_KeHoachDieuTri
	PRIMARY KEY(ID_KHDieuTri),

	CONSTRAINT FK_KeHoachDieuTri_HoSoBenhNhan
	FOREIGN KEY (ID_HoSo)
	REFERENCES HoSoBenhNhan(ID_HoSo),

	CONSTRAINT FK_KeHoachDieuTri_TaiKhoan
	FOREIGN KEY (ID_BacSiThucHien)
	REFERENCES TaiKhoan(ID_TaiKhoan),

	CONSTRAINT FK_KeHoachDieuTri_TaiKhoan1
	FOREIGN KEY (ID_BacSiTroKham)
	REFERENCES TaiKhoan(ID_TaiKhoan),

	CONSTRAINT FK_KeHoachDieuTri_DanhMucDieuTri
	FOREIGN KEY (ID_DanhMuc)
	REFERENCES DanhMucDieuTri(ID_DanhMuc),

	CONSTRAINT FK_KeHoachDieuTri_ThongTinChiTietThanhToan
	FOREIGN KEY (ID_ThanhToan)
	REFERENCES ThongTinChiTietThanhToan(ID_ThanhToan)
)
GO

CREATE TABLE RangDieuTri (
	ID_KHDieuTri varchar(10),
	ID_Rang varchar(10),
	ID_MatRang varchar(10),
	PhiDichVu int

	CONSTRAINT PK_RangDieuTri
	PRIMARY KEY(ID_KHDieuTri, ID_Rang, ID_MatRang)

	CONSTRAINT FK_RangDieuTri_KeHoachDieuTri
	FOREIGN KEY (ID_KHDieuTri)
	REFERENCES KeHoachDieuTri(ID_KHDieuTri),

	CONSTRAINT FK_RangDieuTri_Rang
	FOREIGN KEY (ID_Rang)
	REFERENCES Rang(ID_Rang),

	CONSTRAINT FK_RangDieuTri_MatRang
	FOREIGN KEY (ID_MatRang)
	REFERENCES MatRang(ID_MatRang)
)
GO

create table DonThuoc
(
	ID_KHDieuTri varchar(10),
	ID_Thuoc varchar(10),
	SoLuongThuoc int,
	ThanhTien int

	PRIMARY KEY CLUSTERED (ID_KHDieuTri ASC,ID_Thuoc ASC),
	FOREIGN KEY (ID_Thuoc) REFERENCES Thuoc (ID_Thuoc),
	FOREIGN KEY (ID_KHDieuTri) REFERENCES KeHoachDieuTri (ID_KHDieuTri),
)

update RangDieuTri
	set PhiDichVu = (select PhiDichVu from Rang where RangDieuTri.ID_Rang = Rang.ID_Rang)
go