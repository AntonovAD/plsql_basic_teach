--compact create
create table student.regions(
    id_region number primary key,
    name varchar2(100)
);

create table student.towns(
    id_town number primary key,
    name varchar2(100),
    id_region number references student.regions (id_region)
);

--ORA-02449
drop table student.regions;
drop table student.towns;

--long create [constraint $$name]
create table student.towns(
    id_town number,
    name varchar2(100),
    id_region number,
    --constraint id_town_pk
    primary key (id_town),
    --constraint id_region_fk
    foreign key (id_region) references student.regions (id_region)
);

--alter create [constraint $$name]
create table student.towns(
    id_town number,
    name varchar2(100),
    id_region number
);

alter table student.towns
add
    --constraint id_town_pk
    primary key (id_town);

alter table student.towns
add
    --constraint id_region_fk
    foreign key (id_region) references student.regions (id_region);
