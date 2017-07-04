use sp_ss
IF OBJECT_ID('sp_ss.ssc_text', 'U') IS NOT NULL
drop table sp_ss.ssc_text
go
create table sp_ss.ssc_text
(COL_NUMBER numeric(25,2) primary key, 
COL_TEXT1 text,
COL_TEXT2 text,
COL_TEXT3 text,
COL_TEXT4 text);
go
