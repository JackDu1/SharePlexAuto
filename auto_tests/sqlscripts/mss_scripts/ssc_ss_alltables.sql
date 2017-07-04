use sp_ss
go

IF OBJECT_ID('sp_ss.ssc_number_all', 'U') IS NOT NULL
drop table sp_ss.ssc_number_all

Create table sp_ss.ssc_number_all(COL_NUMBER1 numeric(25,2) not null,
COL_BIT bit,
COL_TINYINT tinyint ,
COL_SMALLINT smallint ,
COL_INT int ,
COL_DEC decimal(38,10) ,
COL_FLOAT float(53),
COL_REAL real,
Primary key(COL_NUMBER1,COL_TINYINT,COL_SMALLINT,COL_INT)
)

IF OBJECT_ID('sp_ss.ssc_char__all', 'U') IS NOT NULL
drop table sp_ss.ssc_char_all

create table sp_ss.ssc_char_all(COL_NUMBER numeric(25,2) not null,
COL_CHAR char(100) ,
COL_CHAR1 char(1000) ,
COL_CHAR2 char(4000) ,
COL_VARCHAR varchar(100) ,
COL_VARCHAR1 varchar(1000),
COL_VARCHAR2 varchar(5000) ,
COL_VARCHAR3 varchar(max) ,
Primary key(COL_NUMBER,COL_CHAR,COL_VARCHAR))

IF OBJECT_ID('sp_ss.ssc_nchar__all', 'U') IS NOT NULL
drop table sp_ss.ssc_nchar_all

create table sp_ss.ssc_nchar_all(COL_NUMBER numeric(25,2) not null,
COL_NCHAR nchar(1000) ,
COL_NCHAR1 nchar(2500) ,
COL_NVARCHAR nvarchar(2000) ,
COL_NVARCHAR1 nvarchar(4000) ,
COL_NVARCHAR2 nvarchar(max),
COL_TEXT text ,
COL_NTEXT ntext ,
Primary Key(COL_NUMBER))

IF OBJECT_ID('sp_ss.ssc_binary__all', 'U') IS NOT NULL
drop table sp_ss.ssc_binary_all

create table sp_ss.ssc_binary_all(COL_NUMBER numeric(25,2) not null,
COL_IMAGE image ,
COL_BINARY binary(2000) ,
COL_BINARY1 binary(5000) ,
COL_VARBINARY varbinary(2000) ,
COL_BARBINARY1 varbinary(3000) ,
COL_BARBINARY2 varbinary(max) ,
Primary key(COL_NUMBER)
)

IF OBJECT_ID('sp_ss.ssc_date__all', 'U') IS NOT NULL
drop table sp_ss.ssc_date_all

create table sp_ss.ssc_date_all(
COL_NUMBER numeric(25,2) ,
COL_TIME time(7) ,
COL_DATE date ,
COL_SDATETIME smalldatetime ,
COL_DATTIME datetime ,
COL_DATETIME2 datetime2(7) ,
COL_DATETIMEOFF datetimeoffset(7) ,
Primary key(COL_NUMBER,COL_DATE)
)
go

