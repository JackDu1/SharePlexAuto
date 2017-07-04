DROP TABLE IF EXISTS sp_pg.qa_date_gt1753;

/*
CREATE TABLE sp_pg.qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   timestamp,
  COL_DATE2   timestamp,
  COL_DATE3   timestamp,
  COL_DATE4   timestamp,
  COL_DATE5   timestamp,
PRIMARY KEY(COL_NUMBER)
);
*/



--2-1-2016 Julia change to date, target datatype map shows Oracle date map to PPAS date
CREATE TABLE sp_pg.qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   date,
  COL_DATE2   date,
  COL_DATE3   date,
  COL_DATE4   date,
  COL_DATE5   date,
PRIMARY KEY(COL_NUMBER)
);


----------------------------

DROP TABLE IF EXISTS sp_pg.qa_date_lt1753;

/*
CREATE TABLE sp_pg.qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   timestamp(6),
  COL_DATE2   timestamp(6),
  COL_DATE3   timestamp(6),
  COL_DATE4   timestamp(6),
  COL_DATE5   timestamp(6),
PRIMARY KEY(COL_NUMBER)
);
*/

--2-1-2016 Julia change to date, target datatype map shows Oracle date map to PPAS date
CREATE TABLE sp_pg.qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   date,
  COL_DATE2   date,
  COL_DATE3   date,
  COL_DATE4   date,
  COL_DATE5   date,
PRIMARY KEY(COL_NUMBER)
);

