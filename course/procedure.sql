DROP PROCEDURE if exists actor;  

delimiter //

CREATE PROCEDURE `actor` (in x varchar(255)) 
DETERMINISTIC 
BEGIN 
    select serials.nameR, actors.name from serials join find_actors join actors on serials.id =find_actors.serials_id and actors.name = x and actors.id = find_actors.actors_id;
END// 

delimiter ;

call actor ('Cristian Steuber');

