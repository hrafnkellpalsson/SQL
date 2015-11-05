-- How to create a login, user, database and table in TSQL.

-- Example script to run as part of Continuous Deployment
-- ***********************************************************************************************************************
if exists (select name from master.sys.server_principals where name = 'DomainName\ADUser')
    print 'Login DomainName\ADUser already exists.'     
else	
begin
    print 'Creating login DomainName\ADUser.'
    create login [DomainName\ADUser] from windows with default_database=[master], default_language=[us_english]
end
	
if db_id('DBName') is not null   
    print 'Database DBName already exists.'
else
begin
    print 'Creating database DBName.'
    create database DBName
end

if exists (select name from sys.database_principals where name = 'DomainName\ADUser')
    print 'User DomainName\ADUser already exists.'     
else	
begin
    print 'Creating user DomainName\ADUser and granting permissions.'
    create user [DomainName\ADUser] for login [DomainName\ADUser] with default_schema=[dbo]
    use DBName
    grant select on object::dbo.TableName to [DomainName\ADUser]
end

if object_id('TableName', 'U') is not null
    print 'Table TableName already exists'
else
begin
    print 'Creating table TableName.'
    create table TableName (Msisdn varchar(7) primary key check(len(msisdn) = 7 and isnumeric(msisdn) = 1))
end
-- ***********************************************************************************************************************

-- NOTE!!! A login and a user are two different things.
-- See more here http://blog.sqlauthority.com/2014/07/16/sql-server-difference-between-login-and-user-sql-in-sixty-seconds-070/

-- Create Windows login.
create login [DomainName\ADUser] from windows with default_database=[master], default_language=[us_english]
-- Drop login.
drop login [DomainName\ADUser]

-- Create SQL Server login.
create login [DBLogin] with password=n'.password0', default_database=[master], default_language=[us_english], check_expiration=off, check_policy=off
-- Drop login.
drop login [DBLogin]

-- Create user.
create user [DBUser] for login [hptest] with default_schema=[dbo]
-- Create user.
drop user [DBUser]

-- Grant priviliges to user on a table in a database.
use DBName
grant select, insert, delete on object::dbo.TableName to DBUser

-- Create database.
create database DBName

-- Create table in a database.
use DBName
create table TableName (Msisdn varchar(7) primary key check(len(msisdn) = 7 and isnumeric(msisdn) = 1))

-- Make user sysadmin.
exec master.dbo.sp_addsrvrolemember @loginame = N'hptest', @rolename = N'sysadmin'







