use sp_ms
DROP table IF EXISTS sp_ms.qa_date_lt1753;


CREATE TABLE sp_ms.qa_date_lt1753(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_DATE1 datetime, 
  COL_DATE2 datetime,
  COL_DATE3 datetime,
  COL_DATE4 datetime,
  COL_DATE5 datetime,
  PRIMARY KEY(COL_NUMBER)

);

DROP table IF EXISTS sp_ms.qa_date_gt1753;


CREATE TABLE sp_ms.qa_date_gt1753(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_DATE1 datetime , 
  COL_DATE2 datetime ,
  COL_DATE3 datetime ,
  COL_DATE4 datetime ,
  COL_DATE5 datetime ,
  PRIMARY KEY(COL_NUMBER)

);
exit

