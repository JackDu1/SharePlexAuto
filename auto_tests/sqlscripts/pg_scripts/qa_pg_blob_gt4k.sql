DROP TABLE IF EXISTS sp_pg.qa_blob_gt4k;

create table sp_pg.qa_blob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
--   COL_BLOB1   bytea,
--   COL_BLOB2   bytea,
--   COL_BLOB3   bytea,
--   COL_BLOB4   bytea,
--   COL_BLOB5   bytea,
-- comment out by debbie. for postgresql
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

