use ntype_ci
go

CREATE TABLE sp_n.pd_nv
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description nvarchar(2000),
PRIMARY KEY (p_id,lang_id)
);


use ntype_cs
go

CREATE TABLE sp_n.pd_nv
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description nvarchar(2000),
PRIMARY KEY (p_id,lang_id)
);
