use ntype_ci
go


CREATE TABLE sp_n.pd_nv_nclob_disable_inrow
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description ntext,
PRIMARY KEY (p_id,lang_id)
);

use ntype_cs
go


CREATE TABLE sp_n.pd_nv_nclob_disable_inrow
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description ntext,
PRIMARY KEY (p_id,lang_id)
);
