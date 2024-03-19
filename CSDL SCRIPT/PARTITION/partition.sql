--cai dat partition tren bang rang dieu tri



ALTER DATABASE QLPKNKHOA


ADD FILEGROUP Partition_1;

ALTER DATABASE QLPKNKHOA
ADD FILEGROUP Partition_2;

ALTER DATABASE QLPKNKHOA
ADD FILEGROUP Partition_3;

ALTER DATABASE QLPKNKHOA
ADD FILEGROUP Partition_4;

ALTER DATABASE QLPKNKHOA
ADD FILEGROUP Partition_5;




ALTER DATABASE QLPKNKHOA
ADD FILE (NAME = 'Partition_1', FILENAME = 'C:\QLPKNKHOA\Partition_1.ndf', SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB)
TO FILEGROUP Partition_1;

ALTER DATABASE QLPKNKHOA
ADD FILE (NAME = 'Partition_2', FILENAME = 'C:\QLPKNKHOA\Partition_2.ndf', SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB)
TO FILEGROUP Partition_2;

ALTER DATABASE QLPKNKHOA
ADD FILE (NAME = 'Partition_3', FILENAME = 'C:\QLPKNKHOA\Partition_3.ndf', SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB)
TO FILEGROUP Partition_3;

ALTER DATABASE QLPKNKHOA
ADD FILE (NAME = 'Partition_4', FILENAME = 'C:\QLPKNKHOA\Partition_4.ndf', SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB)
TO FILEGROUP Partition_4;


ALTER DATABASE QLPKNKHOA
ADD FILE (NAME = 'Partition_5', FILENAME = 'C:\QLPKNKHOA\Partition_5.ndf', SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10MB)
TO FILEGROUP Partition_5;



CREATE PARTITION FUNCTION PF_RangDieuTri_ID_Rang_QLPKNKHOA (varchar(10))
AS RANGE RIGHT FOR VALUES ('RA00437900', 'RA00517649', 'RA00787374','RA00963268');


CREATE PARTITION SCHEME PS_RangDieuTri_ID_Rang_QLPKNKHOA
    AS PARTITION PF_RangDieuTri_ID_Rang_QLPKNKHOA
    TO (Partition_1,Partition_2, Partition_3, Partition_4, Partition_5);


alter table RangDieuTri
drop constraint PK_RangDieuTri


alter table RangDieuTri
add primary key
nonclustered (ID_KHDieuTri,ID_MatRang ASC)
on Partition_1




CREATE CLUSTERED INDEX IX_RangDieuTri_ID_Rang_QLPKNKHOA
    ON RangDieuTri(ID_Rang)
    ON PS_RangDieuTri_ID_Rang_QLPKNKHOA(ID_Rang);






SELECT p.partition_number AS partition_number,

f.name AS file_group,
p.rows AS row_count

FROM sys.partitions p JOIN sys.destination_data_spaces dds ON
p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'RangDieuTri'
order by partition_number;
