# 2.5.1 データの挿入

## primary key を auto increments するために
## 既存のテーブルの定義を修正する
lock tables favorite_food write, person write;
alter table favorite_food drop foreign key fk_person_id, modify person_id smallint unsigned;
alter table person modify person_id smallint unsigned auto_increment;
alter table favorite_food add constraint fk_person_id foreign key (person_id) references person(person_id);
unlock tables;

desc person;

## insert文
insert into person
(person_id, fname, lname, gender, birth_date)
values (null, 'William', 'Turner', 'M', '1972-05-27');

select person_id, fname, lname, birth_date
from person;

## where
select person_id, fname, lname, birth_date
from person
where person_id = 1;

## name で where
select person_id, fname, lname, birth_date
from person
where lname = 'Turner';

insert into favorite_food (person_id, food)
values (1, 'pizza');

insert into favorite_food (person_id, food)
values (1, 'cookies');

insert into favorite_food (person_id, food)
values (1, 'nachos');

## order by
select food
from favorite_food
where person_id = 1
order by food;

insert into person
(person_id, fname, lname, gender, birth_date,
address, city, state, country, postal_code)
values (null, 'Susan', 'Smith', 'F', '1975-11-02',
'23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

select person_id, fname, lname, birth_date
from person;

# 2.5.2 データの更新
update person
set address = '1225 Tremont St.',
city = 'Boston',
state = 'MA',
country = 'USA',
postal_code = '02138'
where person_id = 1

# 2.5.3 データ削除
delete from person
where person_id = 2;
