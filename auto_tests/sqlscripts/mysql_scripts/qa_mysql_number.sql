use sp_ms
drop table  IF EXISTS sp_ms.qa_number;

create table sp_ms.qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(20,7),
  COL_NUMBER2   numeric(24,4),
  COL_NUMBER3   numeric(26,2),
  COL_NUMBER4   numeric(27,1),
  COL_NUMBER5   numeric(28),
PRIMARY KEY(COL_NUMBER)
);
exit
