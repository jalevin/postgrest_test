create schema api;


CREATE EXTENSION pgcrypto;
CREATE EXTENSION pgjwt;

-- users
create table api.users(
  id serial primary key,
  first_name varchar not null,
  last_name varchar not null,
  password varchar not null,
  email varchar not null,
  sex varchar not null,
  dob date not null
);

create table api.activities(
  id serial primary key,
  act_type varchar not null,
  version varchar not null,
  time int not null,
  score int not null, 
  avg_power int not null,
  region varchar not null,
  device varchar not null, 
  act_rank varchar not null,
  foreign key (id) references api.users(id) 
); 

create table api.purchases(
  id serial primary key, 
  purchase_date date not null, 
  receipt_code varchar not null,
  foreign key (id) references api.users(id) 
); 


/*
insert into api.users (first_name, last_name, password, email, sex, dob)  
	VALUES 
		(
			'jeff',
			'levin',
			crypt('password', gen_salt('bf')),
			'jeff@levinology.com',
			'male',
			'1969-07-12'
		);

insert into api.activities (act_type, version, time, score, avg_power, region, device, act_rank)  
	VALUES 
		(
			'biking',
			1, 
			30, 
			100, 
			24, 
			'alaska', 
      'iphone', 
      'high'
		);

insert into api.purchases (purchase_date, receipt_code)
VALUES (
  '2021-01-11', 
  'not sure'
); 
*/




/* this block is from https://postgrest.org/en/v4.1/auth.html
/  Commenting this block out makes the db run as expected. 
/ 
/  If left in the server starts, but fails to establish a connection because the 'web_anon' role 
/  does not exist. 
*/  

create type jwt_token as (
  token text
);
CREATE FUNCTION jwt_test() RETURNS public.jwt_token
    LANGUAGE sql
    AS $$ 'text'::text
  SELECT sign(
    row_to_json(r), 'mysecret'
  ) AS token
  FROM (
    SELECT
      'my_role'::text as role,
      extract(epoch from now())::integer + 300 AS exp
  ) r;
$$;


create role web_anon nologin;
grant usage on schema api to web_anon;
grant select on api.users to web_anon;
grant select on api.activities to web_anon;
grant select on api.purchases to web_anon;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;
