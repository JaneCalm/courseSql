use courseSql;


create or replace view allseria (serials ,seasons, seasons_id, seria)
as
select t.serials_id, t.seasons_num, t.seasons_id, max(t.seria_num) from (select seasons.serials_id, seasons.seasons_num , seria.seasons_id, seria.seria_num from seasons left join  seria on seria.seasons_id = seasons.id)as t group by t.serials_id, t.seasons_num;

create or replace view emailid(email, id)
as
select messages.email, users.id from  messages join users where messages.email=users.email group by users.id;