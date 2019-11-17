/*
 За основу данной базы, я взяла сайт https://www.toramp.com/, полностью соблюдая их структуру.
 Акцент данного ресурса сделан на сериалах и возможности создавать свое расписание просмотров.
 Задачей базы данных является хранение актуальной информации о просмотренных сериях, оценках.
 На ее основе можно анализировать популярность сериалов, как по посещяемости страниц, так и по количеству людей просмотревших все серии сериала. 
 Также есть задача оптимизировать поиск интересующего сериала для пользователя, на основе сопутствующей информации. (по актерам, по создателям и тд)
 По идее жанры можно было-бы хранить в множественном выборе SET, но тогда нужно четко определиться, что их будет не более 60+, а если их вдруг станет больше, то 
 прийдется переделывать связи, поэтому я реализовала их также, как и остальные поисковые запросы
*/

drop database if exists courseSql;
create database courseSql;
use courseSql;

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL COMMENT 'Название жанра',
  UNIQUE unique_name4(name(10))
) COMMENT = 'Жанры сериалов';

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Имя актера'
) COMMENT = 'Актеры';

DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  UNIQUE unique_name3(name(10))
) COMMENT = 'тэги';

DROP TABLE IF EXISTS canal;
CREATE TABLE canal (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL COMMENT 'каналы',
  UNIQUE unique_name2(name(10))
);

DROP TABLE IF EXISTS author;
CREATE TABLE author (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE COMMENT 'создатель идеи'
);

drop table if exists users;
create table users(
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100),
	lastname VARCHAR(100),
	email VARCHAR(120) not null unique,
	password_u VARCHAR(100) not null,
	gender CHAR(2),
	birthday DATE,
	INDEX (firstname, lastname)
)COMMENT = 'пользователи';

drop table if exists schedule;
create table schedule(
	 user_id serial PRIMARY KEY,
	 delay ENUM('1', '2', '3', '4', '5', '6', '7','8', '9', '10') COMMENT 'задержка дней рассписания',
	 opened ENUM('10', '11', '12', '13', '14', '15', '16','17', '18', '19', '20') COMMENT 'количество отображаемых серий', 
	 loaded ENUM('5', '6', '7', '8', '9', '10', '11','12', '13', '14', '15') COMMENT 'количество подгружаемых серий', 
	 foreign key (user_id) references users(id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'общие настройки расписания пользователя';

drop table if exists messages;
create table messages(
	id SERIAL PRIMARY KEY,
	email VARCHAR(120) not null,
	user_id BIGINT UNSIGNED unique,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	index(email),
	foreign key (user_id) references users(id) ON DELETE set null ON UPDATE CASCADE
) COMMENT = 'Сообщения отправленные из формы сайта';

drop table if exists picture;
create table picture(
	id SERIAL PRIMARY KEY,
	filename VARCHAR(255),
	`size` int,
	metadata JSON
)COMMENT = 'картинки';

DROP TABLE IF EXISTS serials;
CREATE TABLE serials(
  id SERIAL PRIMARY KEY,
  picture_id BIGINT UNSIGNED,  
  nameR VARCHAR(255) not NULL COMMENT 'Название на русском',
  nameE VARCHAR(255) COMMENT 'Название на английском',
  description TEXT COMMENT 'Описание',
  created_at YEAR,
  end_at YEAR,
  reit DECIMAL (4,2) UNSIGNED COMMENT 'Рейтинг',
  status ENUM('выходит', 'завершен', 'ждем премьеры', 'решается дальнейшая судьба проекта', 'вернется весной', 'вернется летом', 'вернется осенью','вернется зимой', 'вернется \'неизвестно\''),
  timeon VARCHAR(255) COMMENT 'время выхода в эфир',
  timeline int COMMENT 'длительность серии',
  allepisods int UNSIGNED,
  allseasons int UNSIGNED,
  foreign key (picture_id) references picture(id) ON DELETE set null ON UPDATE CASCADE
) COMMENT = 'Сериалы';


drop table if exists news;
create table news(
	id SERIAL PRIMARY KEY,
	news_text TEXT NOT NULL,
	serials_id BIGINT UNSIGNED,	
	foreign key (serials_id) references serials(id) ON DELETE set null ON UPDATE CASCADE
);


drop table if exists likes;
create table likes(
	user_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	raiting_a ENUM ('1', '2', '3', '4', '5' ,'6', '7', '8', '9', '10'),
	primary key (user_id, serials_id),
	foreign key (user_id) references users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT = 'оценки сериалов';

drop table if exists seasons;
create table seasons(
	id SERIAL PRIMARY KEY,
	serials_id BIGINT UNSIGNED NOT NULL,
	seasons_id BIGINT UNSIGNED NOT NULL,
	num int UNSIGNED not null,
	data_start DATETIME,
	seasons_text TEXT,
	allepisods int UNSIGNED,
	UNIQUE (serials_id, seasons_id),
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT = 'сезоны';

drop table if exists seria;
create table seria(
	id SERIAL PRIMARY KEY,
	seasons_id BIGINT UNSIGNED NOT NULL,
	seria_id BIGINT UNSIGNED NOT NULL,
	num int UNSIGNED not null,
	data_start DATETIME,
	name VARCHAR(255),
	UNIQUE (seasons_id, seria_id),
	foreign key (seasons_id) references seasons(id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT = 'серии';

drop table if exists likes_b;
create table likes_b(
	user_id BIGINT UNSIGNED NOT NULL,
	seria_id BIGINT UNSIGNED NOT NULL,
	raiting_b CHAR(1),
	Primary key (user_id, seria_id),
	foreign key (user_id) references users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (seria_id) references seria(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'лайки серий';

drop table if exists schedule_serials;
create table schedule_serials(
	 user_id BIGINT UNSIGNED NOT NULL,
	 serials_id BIGINT UNSIGNED NOT NULL,
	 status ENUM('смотрю', 'посмотрела', 'бросила просмотр', 'приостановила просмотр', 'планирую посмотреть') COMMENT 'статус просмотра сериала',
	 massege TEXT,
	 Primary key (user_id, serials_id),
	 foreign key (user_id) references users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	 foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'статус просмотра по каждому сериалу';

drop table if exists views;
create table views(
	user_id BIGINT UNSIGNED NOT NULL,
	seria_id BIGINT UNSIGNED NOT NULL,
	view CHAR(1),
	Primary key (user_id, seria_id),
	foreign key (user_id) references users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (seria_id) references seria(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'просмотры серий';

drop table if exists find_actors;
create table find_actors(
	actors_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (actors_id, serials_id),
	index (actors_id),
	index (serials_id),
	foreign key (actors_id) references actors(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список актеров по фильмам';

drop table if exists find_author;
create table find_author(
	author_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (author_id, serials_id),
	index (author_id),
	index (serials_id),
	foreign key (author_id) references author(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список создетелей по фильмам';

drop table if exists find_tags;
create table find_tags(
	tags_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (tags_id, serials_id),
	index (tags_id),
	index (serials_id),
	foreign key (tags_id) references tags(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список фильмов по тэгам';

drop table if exists find_genre;
create table find_genre(
	genre_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (genre_id, serials_id),
	index (genre_id),
	index (serials_id),
	foreign key (genre_id) references genre(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список фильмов по жанрам';

drop table if exists find_canal;
create table find_canal(
	canal_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (canal_id, serials_id),
	index (canal_id),
	index (serials_id),
	foreign key (canal_id) references canal(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список актеров по фильмам';

drop table if exists find_seria_serials;
create table find_seria_serials(
	serials_two_id BIGINT UNSIGNED NOT NULL,
	serials_id BIGINT UNSIGNED NOT NULL,
	primary key (serials_two_id, serials_id),
	index (serials_two_id),
	index (serials_id),
	foreign key (serials_two_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (serials_id) references serials(id) ON DELETE CASCADE ON UPDATE CASCADE	
)COMMENT = 'список сериалов из одной сюжетной линии';

drop table if exists find;
create table find(
	finded text
)ENGINE=ARCHIVE;

