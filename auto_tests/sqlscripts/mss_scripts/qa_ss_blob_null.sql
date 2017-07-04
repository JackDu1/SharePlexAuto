use sp_ss
IF OBJECT_ID('sp_ss.qa_blob_null', 'U') IS NOT NULL
drop table sp_ss.qa_blob_null
go
create table sp_ss.qa_blob_null
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

