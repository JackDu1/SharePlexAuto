use ntype_ci
go

create table sp_n.pd_nv_nclob2
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description ntext
);		

go

sp_tableoption N'sp_n.pd_nv_nclob2', 'text in row', 'ON';
go

use ntype_cs
go

create table sp_n.pd_nv_nclob2
(
p_id  numeric(6,0),
lang_id varchar(3),
name nvarchar(50) NOT NULL,
description ntext
);		

go

sp_tableoption N'sp_n.pd_nv_nclob2', 'text in row', 'ON';
go

