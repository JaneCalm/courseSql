/*
 За основу данной базы, я взяла сайт https://www.toramp.com/.
 Акцент данного ресурса сделан на сериалах и возможности создавать свое расписание просмотров.
 Задачей базы данных является хранение актуальной информации о просмотренных сериях, оценках.
 На ее основе можно анализировать популярность сериалов, как по посещяемости страниц, так и по количеству людей просмотревших все серии сериала. 
 Также есть задача оптимизировать поиск интересующего сериала для пользователя, на основе сопутствующей информации. (по актерам, по создателям и тд)
*/

drop database if exists courseSql;
create database courseSql;
use courseSql;

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL COMMENT 'Название жанра',
  UNIQUE unique_name(name(10))
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
  UNIQUE unique_name(name(10))
) COMMENT = 'тэги';

DROP TABLE IF EXISTS canal;
CREATE TABLE canal (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL COMMENT 'каналы',
  UNIQUE unique_name(name(10))
);

DROP TABLE IF EXISTS author;
CREATE TABLE author (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE COMMENT 'создатель идеи'
);



