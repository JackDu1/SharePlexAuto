DROP TABLE IF EXISTS sp_pg.qa_integer;

CREATE TABLE sp_pg.qa_integer
(
  COL_NUMBER     numeric(25,2) not null,
  COL_INTEGER1   int,
  COL_INTEGER2   integer,
  COL_INTEGER3   int,
  COL_INTEGER4   integer,
  COL_INTEGER5   int,
PRIMARY KEY(COL_NUMBER)
);
