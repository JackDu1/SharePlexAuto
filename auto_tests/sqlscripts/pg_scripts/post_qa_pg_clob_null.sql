--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS sp_pg.qa_clob_null;

CREATE TABLE sp_pg.qa_clob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);
