--select name from people where id in (select person_id from stars where movie_id in (select id from movies where year=2004)) order by birth;
select distinct(people.name) from people join stars on people.id = stars.person_id join movies on stars.movie_id= movies.id where movies.year = 2004 order by people.birth;
