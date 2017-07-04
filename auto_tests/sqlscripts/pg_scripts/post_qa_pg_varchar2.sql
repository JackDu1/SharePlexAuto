--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS sp_pg.qa_varchar2;

CREATE TABLE sp_pg.qa_varchar2
(
  COL_NUMBER       numeric(25,2) not null,
  COL_VARCHAR2_1   varchar(100),
  COL_VARCHAR2_2   varchar(500),
  COL_VARCHAR2_3   varchar(1000),
  COL_VARCHAR2_4   varchar(2000),
  COL_VARCHAR2_5   varchar(4000),
PRIMARY KEY(COL_NUMBER)
);
