Jan 12, 2016
============

Why not store data in files?
----------------------------

- Data independence
- Performance
- Integrity
- Security
- Administration
- Concurred access
- Crash Recovery
- Development Effort


Not all data is well served by relational databases.

Database Design
---------------

Design using UML and translate to relational.
- Every row has the same fields (one for each column).
- Every field has a simple value, no multiple values.
- The rows are not objects.

UML
---

multiplicities

like range(a, b)
1..1
0..1
1..\*
9..\*

NULL is not a value.

How to test in SQL: X is null

Jan 19, 2016
============

UML
---

diamond: aggregation
filled diamond: composition

Association doesn't have identity.

<<enumeraion>>
triangle

Sample SQL
----------

    mysql> use test;
    Database changed
    mysql> create table Home (
        -> id int primary key auto_increment,
        -> address varchar(200) not null
        -> );
    Query OK, 0 rows affected (0.04 sec)
    
    mysql> create table Network (
        -> id int primary key auto_increment,
        -> name varchar(200) not null
        -> );
    Query OK, 0 rows affected (0.01 sec)
    
    mysql> create table Connection (
        -> connectsTo int,
        -> connects int,
        -> foreign key (connectsTo) references Network(id)
        -> on update cascade on delete cascade,
        -> foreign key (connects) references Home(id)
        -> on update cascade on delete cascade,
        -> primary key (connectsTo, connects),
        -> bandwith double not null
        -> );
    Query OK, 0 rows affected (0.02 sec)

reification

    create table Employee (
      id int primary key,
      name varchar(200) not null,
      code int not null,
      gender enum('Male', 'Female') not null,
    
      worksFor int,
      foreign key (worksFor) refereces
        Department(id)
      on update cascade on delete no action
    );

primary keys are automatically not null

    create table Email (
      employee int,
      foreign key (employee) references Employee (id)
        on upgrade cascade on delete cascade,
      email varchar (255),
      primary key (employee, email)
    );

'Subclass' - three methods:

- JOINED
- TABLE PER CLASS
- SINGLE TABLE

Sample: person and student

JOINED

    create table Person (
      id int primary key,
      name varchar (200) not null  
    );
    
    create table Student (
      id int primary key,
      major varchar (200) not null,
      foreign key (id) references Person(id)
        on update cascade on delete cascade
    );

TABLE PER CLASS

    create table Person (
      id int primary key,
      name varchar (200) not null  
    );
    
    create table Student (
      id int primary key,
      major varchar (200) not null,
      name varchar (200) not null  
    );

SINGLE TABLE

    create table Person (
      id int primary key,
      name varchar (200) not null  
      major varchar (200),

      discriminator enum('Person', 'Student')
        not null,
      check (discriminator != 'Student' OR major is not null)
    );

Jan 26, 2016
============
HW2
select from where

select p.name
from Person p, Instrument i, plays y, playsSong ps
where ps.song = 'Quiet City'
  and p.id = y.person
  and y.instrument = i.id
  and i.name = 'trmpet'
  and ps.person = y.person
  and ps.instrument = y.instrument

number of tables - 1 = number of joint constrains

'as' optional keyword, from Person as p

use aliases, good style

select p.name
from Person p  join plays y
  on (p.id = y.person) join instrument  i 
  on (i.id = y.instrument) join playsSong s
  on (s.person = y.perosn and s.instrument = y.instrument)
whwere i.name = 'trumpet' and s.song = 'Quiet City'

left outter join
---------------

select p.name, i.name // select distint i.name
from Person p left join
  plays y on (p.id = y.person)
  join Instrument i on (i.id = y.instrument)
where p.name is null


anti-join
----------

select i.id
  from Instrument i
  where not exists {
        select *
        from playSong s
        where s.song = 'Moldau'
        and i.id = s.instrument}

semi-join
---------

select i.id
  from Instrument i
  where exists {
    select *
    from playsSongs s
where i.id = s.instrument
and s.name like 'M%'  
}

% 0 or more character
_ exactly on character

order by i.name, i.id

Feb 2, 2016
===========

NULL
----
sample 2-2.sql

Difference between querying many to many and many to one

HW wording fix: metals in each solid phase alloy

TODO:
----

