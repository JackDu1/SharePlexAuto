DROP TABLE IF EXISTS sp_pg.qa_long;

CREATE TABLE sp_pg.qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
);

