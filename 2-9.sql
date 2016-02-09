create table Student (
        id int primary key auto_increment,
        name varchar(250),
        major varchar(250)
);

create table Course (
        id int primary key auto_increment,
        code varchar(250) not null
);

create table Section (
        id int primary key auto_increment,
        number int not null,
        partOf int not null references Course (id) on update cascade on delete cascade
);

create table Registration (
        registers int references Student(id) on update cascade on delete cascade,
        registerdIn int references Section(id) on update cascade on delete cascade,
        primary key (registers, registerdIn)
);

-- Use check constrains.
create table Person (
        id int primary key,
        name varchar(250) not null,
        major varchar(250) null,
        discriminator enum('Person', 'Student') not null,
        -- if discriminator='Student' then major is not null
        check (discriminator!='Student' or major is not null)
        check (discriminator!='Person' or major is null)
)
