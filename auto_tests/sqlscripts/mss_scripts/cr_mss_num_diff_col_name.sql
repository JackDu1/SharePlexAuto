use sp_ss
create table sp_ssc.mss_num_diff_col_name
(
  COL_pk    numeric not null,
  C1   NUMERIC(38,10),
  C2   NUMERIC(20,20),
  C3   NUMERIC(17,8),
  C4   NUMERIC(18,6),
  C5   NUMERIC,
PRIMARY KEY(COL_pk))

go
