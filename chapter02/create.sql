-- 2.4.3 SQLスキーマ文の作成

create table person (
    person_id smallint unsigned,
    fname varchar(20),
    lname varchar(20),
    gender enum('m', 'f'),
    birth_date date,
    address varchar(30),
    city varchar(20),
    state varchar(20),
    country varchar(20),
    postal_code varchar(20),
    constraint pk_person primary key (person_id)
);

desc person;

create table favorite_food (
    person_id smallint unsigned,
    food varchar(20),
    constraint pk_favorite_food primary key (person_id, food),
    constraint fk_person_id foreign key (person_id)
    references person(person_id)
);

desc favorite_food;
