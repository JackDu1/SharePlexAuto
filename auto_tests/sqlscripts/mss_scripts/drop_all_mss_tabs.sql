use sp_ss
IF OBJECT_ID('sp_ssc.mss_decimal', 'U') IS NOT NULL
drop table sp_ssc.mss_decimal
go

IF OBJECT_ID('sp_ssc.mss_numeric', 'U') IS NOT NULL
drop table sp_ssc.mss_numeric
go

IF OBJECT_ID('sp_ssc.mss_real', 'U') IS NOT NULL
drop table sp_ssc.mss_real
go

IF OBJECT_ID('sp_ssc.mss_float', 'U') IS NOT NULL
drop table sp_ssc.mss_float
go

IF OBJECT_ID('sp_ssc.mss_all_type', 'U') IS NOT NULL
drop table sp_ssc.mss_all_type
go

IF OBJECT_ID('sp_ssc.mss_bigint', 'U') IS NOT NULL
drop table sp_ssc.mss_bigint
go

IF OBJECT_ID('sp_ssc.mss_int', 'U') IS NOT NULL
drop table sp_ssc.mss_int
go

IF OBJECT_ID('sp_ssc.mss_smallint', 'U') IS NOT NULL
drop table sp_ssc.mss_smallint
go


IF OBJECT_ID('sp_ssc.mss_tinyint', 'U') IS NOT NULL
drop table sp_ssc.mss_tinyint
go

IF OBJECT_ID('sp_ssc.mss_bigint', 'U') IS NOT NULL
drop table sp_ssc.mss_bigint
go


IF OBJECT_ID('sp_ssc.mss_binary', 'U') IS NOT NULL
drop table sp_ssc.mss_binary
go


IF OBJECT_ID('sp_ssc.mss_varbinary', 'U') IS NOT NULL
drop table sp_ssc.mss_varbinary
go

IF OBJECT_ID('sp_ssc.mss_image', 'U') IS NOT NULL
drop table sp_ssc.mss_image
go

IF OBJECT_ID('sp_ssc.mss_varbinary_max', 'U') IS NOT NULL
drop table sp_ssc.mss_varbinary_max
go

IF OBJECT_ID('sp_ssc.mss_bit', 'U') IS NOT NULL
drop table sp_ssc.mss_bit
go

IF OBJECT_ID('sp_ssc.mss_char', 'U') IS NOT NULL
drop table sp_ssc.mss_char
go

IF OBJECT_ID('sp_ssc.mss_varchar', 'U') IS NOT NULL
drop table sp_ssc.mss_varchar
go

IF OBJECT_ID('sp_ssc.mss_nchar', 'U') IS NOT NULL
drop table sp_ssc.mss_nchar
go


IF OBJECT_ID('sp_ssc.mss_nvarchar', 'U') IS NOT NULL
drop table sp_ssc.mss_nvarchar
go

IF OBJECT_ID('sp_ssc.mss_ntext', 'U') IS NOT NULL
drop table sp_ssc.mss_ntext
go


IF OBJECT_ID('sp_ssc.mss_nvarchar_max', 'U') IS NOT NULL
drop table sp_ssc.mss_nvarchar_max
go

IF OBJECT_ID('sp_ssc.mss_text', 'U') IS NOT NULL
drop table sp_ssc.mss_text
go


IF OBJECT_ID('sp_ssc.mss_varchar_max', 'U') IS NOT NULL
drop table sp_ssc.mss_varchar_max
go

IF OBJECT_ID('sp_ssc.mss_sql_variant', 'U') IS NOT NULL
drop table sp_ssc.mss_sql_variant
go

use sp_ss

IF OBJECT_ID('sp_ssc.mss_time', 'U') IS NOT NULL
drop table sp_ssc.mss_time
go


IF OBJECT_ID('sp_ssc.mss_date', 'U') IS NOT NULL
drop table sp_ssc.mss_date
go


IF OBJECT_ID('sp_ssc.mss_smalldatetime', 'U') IS NOT NULL
drop table sp_ssc.mss_smalldatetime
go

IF OBJECT_ID('sp_ssc.mss_datetime', 'U') IS NOT NULL
drop table sp_ssc.mss_datetime
go


IF OBJECT_ID('sp_ssc.mss_datetime2', 'U') IS NOT NULL
drop table sp_ssc.mss_datetime2
go

IF OBJECT_ID('sp_ssc.mss_datetimeoffset', 'U') IS NOT NULL
drop table sp_ssc.mss_datetimeoffset
go
