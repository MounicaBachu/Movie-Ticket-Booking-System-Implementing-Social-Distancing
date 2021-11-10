#Creating user
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123';
select host,user from mysql.user;

#Granting roles to Admin:
grant select,insert on *.* to 'admin'@'localhost';
grant update(Is_Available,seat_price) on movie_social_distance_1.seat to 'admin'@'localhost';
grant update(movie_rating,movie_release) on movie_social_distance_1.movie to 'admin'@'localhost';
grant update(Theatre_address,Theatre_contact) on movie_social_distance_1.theatre to 'admin'@'localhost';
grant update(Screen_name,theatre_id) on movie_social_distance_1.screen to 'admin'@'localhost';
grant update on movie_social_distance_1.employee to 'admin'@'localhost';
FLUSH PRIVILEGES;

#Displaying the grants for Admin:
show grants for 'admin'@'localhost';