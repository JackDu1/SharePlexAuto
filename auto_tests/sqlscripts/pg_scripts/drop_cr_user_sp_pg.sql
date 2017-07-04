drop user sp_pg cascade;
create user sp_pg PASSWORD 'sp_pg';
alter user sp_pg VALID UNTIL 'infinity';
grant all privileges on DATABASE sp_pg to sp_pg;
