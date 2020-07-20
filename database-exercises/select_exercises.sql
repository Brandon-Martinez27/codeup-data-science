#Access the albums_db database
USE albums_db;
#Explore structure of the albums table
DESCRIBE albums;
#All albums by Pink Floyds
SELECT name, artist
FROM albums
WHERE artist = 'Pink Floyd';
#Year SPLHCB was released
SELECT release_date
FROM albums
WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';
#Genre for album Nevermind
SELECT genre
FROM albums
WHERE name = 'Nevermind';
#Albums released in the 1990s
SELECT name, release_date
FROM albums
WHERE release_date like '199%';
#Albums less than 20 millilon certified sales
SELECT name, sales
FROM albums
WHERE sales < 20;
#All albums with genre of Rock
SELECT name, genre
FROM albums
WHERE genre like '%Rock%';
## Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
##They are actually all included