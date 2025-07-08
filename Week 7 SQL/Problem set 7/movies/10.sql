select distinct(people.name) from people join directors on people.id = directors.person_id join ratings on directors.movie_id= ratings.movie_id where ratings.rating >=9.0;
