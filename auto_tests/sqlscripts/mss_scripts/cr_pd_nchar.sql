use qarun

CREATE TABLE sp_n.pd_nchar
(
p_id  numeric(6,0),
lang_id varchar(3),
name50 nchar(50),
name_long nchar(1000),
PRIMARY KEY (p_id,lang_id)
);
