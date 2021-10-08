insert into student.regions(id_region, name)
values (1, 'Кемеровская область');
insert into student.regions(id_region, name)
values (2, 'Новосибирская область');
insert into student.regions(id_region, name)
values (3, 'Омская область');

insert into student.towns(id_town, name, id_region)
values (1, 'Кемерово', 1);
insert into student.towns(id_town, name, id_region)
values (2, 'Новокузнецк', 1);

insert into student.towns(id_town, name, id_region)
values (3, 'Новосибирск', 2);
insert into student.towns(id_town, name, id_region)
values (4, 'Бердск', 2);

insert into student.towns(id_town, name, id_region)
values (5, 'Омск', 3);
insert into student.towns(id_town, name, id_region)
values (6, 'Малиновка', 3);

insert into student.hospitals(name, id_town)
values ('Поликлиника №1', 1);
insert into student.hospitals(id_hospital, name, id_town)
values (default, 'Поликлиника №2', 2);
insert into student.hospitals(id_hospital, name, id_town)
values (default, 'Поликлиника №3', 3);

commit;