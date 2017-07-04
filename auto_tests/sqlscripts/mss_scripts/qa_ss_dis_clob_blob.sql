use sp_ss
IF OBJECT_ID('sp_ss.qa_disinrow_blob', 'U') IS NOT NULL
drop table sp_ss.qa_disinrow_blob
go
create table sp_ss.qa_disinrow_blob
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_disinrow_clob', 'U') IS NOT NULL
drop table sp_ss.qa_disinrow_clob
go
create table sp_ss.qa_disinrow_clob
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go
