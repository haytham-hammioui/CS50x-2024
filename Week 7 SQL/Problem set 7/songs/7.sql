select avg(energy) from songs join artists on songs.artist_id = artists.id where artists.name='Drake';
