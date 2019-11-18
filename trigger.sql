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

Drop trigger if exists seriafor ;
delimiter //
CREATE TRIGGER seriafor After insert on seria for each ROW
BEGIN
	declare x decimal;
    declare y int;
   	set y = (select serials_id from seasons where new.seasons_id = id );
	set x = (select  sum(seria) from allseria where serials = y group by serials);
	update courseSql.serials set serials.allepisods = x where serials.id = y;
END//
delimiter ;