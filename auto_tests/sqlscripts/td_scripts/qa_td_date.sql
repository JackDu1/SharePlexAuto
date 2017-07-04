drop table sp_td.QA_DATE_LT1753
go
drop table sp_td.qa_date_gt1753
go
CREATE TABLE sp_td.QA_DATE_LT1753
(
  COL_NUMBER  NUMBER(25,2) NOT NULL,
  COL_DATE1   timestamp,
  COL_DATE2   timestamp,
  COL_DATE3   timestamp,
  COL_DATE4   timestamp,
  COL_DATE5   timestamp,
CONSTRAINT "PK_QA_DATE_LT1753" PRIMARY KEY("COL_NUMBER"))
go
CREATE TABLE sp_td.QA_DATE_GT1753
(
  COL_NUMBER  NUMBER(25,2) NOT NULL,
  COL_DATE1   timestamp,
  COL_DATE2   timestamp,
  COL_DATE3   timestamp,
  COL_DATE4   timestamp,
  COL_DATE5   timestamp,
CONSTRAINT "PK_QA_DATE_GT1753" PRIMARY KEY("COL_NUMBER"))
go
\quit
