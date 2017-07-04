--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS sp_pg.qa_disinrow_blob;

DROP TABLE IF EXISTS sp_pg.qa_disinrow_clob;

create table sp_ss.qa_disinrow_blob
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

create table sp_ss.qa_disinrow_clob
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);
