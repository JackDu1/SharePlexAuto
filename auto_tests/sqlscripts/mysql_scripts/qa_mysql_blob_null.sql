use sp_ms
DROP table IF EXISTS sp_ms.qa_blob_null;


CREATE TABLE sp_ms.qa_blob_null(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_BLOB1 longblob,
  COL_BLOB2 longblob,
  COL_BLOB3 longblob,
  COL_BLOB4 longblob,
  COL_BLOB5 longblob,
  PRIMARY KEY(COL_NUMBER)

);
exit
