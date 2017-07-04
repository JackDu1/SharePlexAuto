--for postgresql
--dzhu, 7/28/2016
--12-10-2015 Julia, modify raw size to be the same as source since Mike said he fixed SPO-1746 and the reason of SPO-1746 is not that ppas use additional 4 bytes as header
DROP TABLE IF EXISTS sp_pg.qa_raw;


CREATE TABLE sp_pg.qa_raw
(
  COL_NUMBER   numeric(25,2) not null,
--   COL_RAW1     bytea(100),
--   COL_RAW2     bytea(200),
--   COL_RAW3     bytea(500),
--   COL_RAW4     bytea(1500),
--   COL_RAW5     bytea(2000),
  COL_RAW1     bytea,
  COL_RAW2     bytea,
  COL_RAW3     bytea,
  COL_RAW4     bytea,
  COL_RAW5     bytea,
--  COL_RAW1     bytea(90),
--  COL_RAW2     bytea(190),
--  COL_RAW3     bytea(490),
--  COL_RAW4     bytea(1490),
--  COL_RAW5     bytea(1990),
PRIMARY KEY(COL_NUMBER)
);

