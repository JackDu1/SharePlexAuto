use sp_ss
IF OBJECT_ID('sp_ss.qa_varchar2', 'U') IS NOT NULL
drop table sp_ss.qa_varchar2
go
create table sp_ss.qa_varchar2
(
  COL_NUMBER       numeric(25,2) not null,
  COL_VARCHAR2_1   varchar(100),
  COL_VARCHAR2_2   varchar(500),
  COL_VARCHAR2_3   varchar(1000),
  COL_VARCHAR2_4   varchar(2000),
  COL_VARCHAR2_5   varchar(4000),
PRIMARY KEY(COL_NUMBER)
)
go
