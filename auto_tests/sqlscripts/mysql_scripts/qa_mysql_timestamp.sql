use sp_ms
DROP table IF EXISTS sp_ms.qa_timestamp;


CREATE TABLE sp_ms.qa_timestamp(

 COL_NUMBER  numeric(25,2) NOT NULL,
 COL_TIMESTAMP1  datetime(4), 
  COL_TIMESTAMP2   datetime(6),
  COL_TIMESTAMP3   datetime(3),
  COL_TIMESTAMP4   datetime(2),
  COL_TIMESTAMP5   datetime(5),
  COL_TIMESTAMP6   datetime(6),
  COL_TIMESTAMP7   datetime(6),
  COL_TIMESTAMP8   datetime(6),
  COL_TIMESTAMP9   datetime(6),
  COL_TIMESTAMP10  datetime(6),
 PRIMARY KEY(COL_NUMBER)
);
exit

