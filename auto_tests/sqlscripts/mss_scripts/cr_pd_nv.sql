use qarun
go

CREATE TABLE sp_n.pd_nv
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description nvarchar(4000),
PRIMARY KEY (p_id,lang_id)
);
