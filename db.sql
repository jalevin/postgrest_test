create schema api;

CREATE EXTENSION pgcrypto;

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

insert into api.users (first_name, last_name, password, email, sex, dob) 
	VALUES 
		(
			'jeff',
			'levin',
			crypt('password', gen_salt('bf')),
			'jeff@levinology.com',
			'male',
			'1990-07-23'
		);

create role web_anon nologin;
grant usage on schema api to web_anon;
grant select on api.users to web_anon;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;
