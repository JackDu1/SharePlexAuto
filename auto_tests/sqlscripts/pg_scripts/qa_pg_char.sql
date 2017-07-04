DROP TABLE IF EXISTS sp_pg.qa_char;

CREATE TABLE sp_pg.qa_char
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR1   char(100),
  COL_CHAR2   char(500),
  COL_CHAR3   char(1000),
  COL_CHAR4   char(1500),
  COL_CHAR5   char(2000),
PRIMARY KEY(COL_NUMBER)
);

