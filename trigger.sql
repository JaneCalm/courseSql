use courseSql;

/*Drop trigger if exists reitfor ;
delimiter //
CREATE TRIGGER reitfor After insert on likes for each ROW
BEGIN
	declare x decimal;
	set x = (select  avg(raiting_a) from likes where serials_id = New.serials_id group by serials_id);
	update courseSql.serials set serials.reit = x where serials.id = New.serials_id;
END//
delimiter ;

Drop trigger if exists seasonfor ;
delimiter //
CREATE TRIGGER seasonfor After insert on seasons for each ROW
BEGIN
	declare x decimal;
	set x = (select  max(seasons_num) from seasons where serials_id = New.serials_id group by serials_id);
	update courseSql.serials set serials.allseasons = x where serials.id = New.serials_id;
END//
delimiter ;*/


