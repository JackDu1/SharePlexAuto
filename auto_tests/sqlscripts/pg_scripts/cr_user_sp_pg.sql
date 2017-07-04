--drop first
--drop user sp_hana cascade;

create user sp_hana password Sp_hana123;
alter user sp_hana disable password lifetime;

--schema will be created automatically
--create schema sp_hana owned by sp_hana;

\quit
