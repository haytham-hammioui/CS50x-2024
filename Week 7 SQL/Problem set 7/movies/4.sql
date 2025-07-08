select count(*) from movies where id in (select movie_id from ratings where rating =10.0);
