--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS sp_pg.qa_long_raw;
create table sp_pg.qa_long_raw
(
  COL_NUMBER      numeric(25,2) not null,
  COL_LONG_RAW    bytea,
PRIMARY KEY(COL_NUMBER)
);

