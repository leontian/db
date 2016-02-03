create table Person (
        id int primary key auto_increment,
        name varchar(250) not null unique,
        dob date not null
);

create table Company (
        id int primary key auto_increment
);

create table CompanyName (
        company int references Company(id)
          on update cascade on delete cascade,
        name varchar(250),
        primary key (company, name)
);


create table Employment (
        employs int references Person(id)
          on update cascade on delete cascade,
        employedBy int references Company(id)
          on update cascade on delete cascade,
        primary key (employs, employedBy),
        position varchar(250)
);

-- Example:
-- List the names of all persons who have a named position at some company
-- Solution:
select distinct p.name
  from Person p, Employment e, Company c
  where p.id = e.employs and c.id = e.employedBy and e.position is not null

-- Another solution
select p.name
  from Person p
  where exists (
        select *
        from Employment e, Company c
        where p.id = e.employs
          and c.id = e.employedBy
          and e.position is not null
)

-- Yet another solution
select p.name
  from Person p
  where p.id in (
        select e.employs
        from Employment e
        where e.position is not null
)

-- Example 2:
-- Find the names and dob of all persons that are employed by -every- company named
-- "First Bank", which is equivalent to 
-- Find the names and dob of all persons such that there does not exist a company
-- named "First Bank" that does not employ the person
-- Rewrite again:
-- Find the names and dob of all persons p such that there does not exist a company c
-- such that there exists a CompanyName n such that n.name = "First Bank" 
-- and such that there does not exist an Employment e such that e.employs is p.id
-- and e.employedBy is c.id

select p.name, p.dob
  from  Person p
  where not exists (
        select * from Company c
        where exists (
                select * from CompanyName n
                where n.name = 'First Bank'
                  and not exists (
                        select *
                          from Employment e
                          where c.id = e.employedBy and p.id = e.employs
                  )
        )
)

-- Example 3:
-- Find the name and number of jobs of each person

select p.name, count(*)
  from Person p, Employment e
  where p.id = e.employs
group by p.id
union
select p.name, 0
  from Person p
  where not exists (
        select *
        from Employment e
        where e.employs = p.id
)

-- Example 4:
-- having
select p.name n, count(*) as ct
  from Person p, Employment e
  where p.id = e.employs
group by p.id
having ct >= 3

-- Insert
insert into Person(name, dob)
  values ('Divya', '2016-02-01'),

insert into Employment(employs, employedBy, position)
  select p.id, c.id, 'CEO'
    from Person p, Company c, CompanyName n
    where p.name = 'Divya'
      and c.id = n.company
      and n.name = 'Google'
-- Delete
delete from Company
where exists (
        select *
        from CompanyName n
        where n.company = id
          and n.name = 'Google'
)
-- Updated
update Employment
  set salary = 2 * salary
  where exists (
        select *
          from Person p
          where p.id = employs
            and p.name = 'Mark'
)
