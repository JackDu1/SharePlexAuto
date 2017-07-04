create user sp_ms identified by 'sp_ms';
grant all privileges on sp_ms.* to sp_ms@'%' identified by 'sp_ms';
flush privileges;
