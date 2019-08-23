# List all valid reservations with customer name and source/destination

WITH starting AS (SELECT route_id, starting_airport
                  FROM (SELECT DISTINCT ON (route_id) route_id, leg_id, leg_number
                        FROM leg_route_info
                        ORDER BY route_id, leg_id ASC) as start
                  NATURAL JOIN leg_detail_info),
     destination AS (SELECT route_id, destination_airport
                  FROM (SELECT DISTINCT ON (route_id) route_id, leg_id, leg_number
                        FROM leg_route_info
                        ORDER BY route_id, leg_id DESC) as dest
                  NATURAL JOIN leg_detail_info),
     city AS (SELECT starting.starting_airport, destination.destination_airport, destination.route_id
              FROM starting, destination
              WHERE starting.route_id=destination.route_id),
     info AS (SELECT boarding_pass_info.reservation_number, trip_id, reservation_info.reserver_name
              FROM boarding_pass_info, reservation_info
              WHERE boarding_pass_info.reservation_number=reservation_info.reservation_number),
     name AS (SELECT info.reservation_number, info.trip_id, info.reserver_name, trip_info.route_id
              FROM info, trip_info
              WHERE info.trip_id=trip_info.trip_id)
SELECT name.reservation_number, name.reserver_name, city.starting_airport, city.destination_airport
FROM name, city
WHERE name.route_id=city.route_id;

# List reservations with invalid trips





# List customers traveling to the city where they live

WITH info AS (SELECT boarding_pass_info.reservation_number, boarding_pass_info.trip_id, customer_info.passport_number, customer_info.city_of_residence
              FROM customer_info, boarding_pass_info
              WHERE customer_info.passport_number=boarding_pass_info.passport_number),
     destination AS (SELECT route_id, destination_airport
                  FROM (SELECT DISTINCT ON (route_id) route_id, leg_id, leg_number
                        FROM leg_route_info
                        ORDER BY route_id, leg_id DESC) as dest
                  NATURAL JOIN leg_detail_info),
     city AS (SELECT destination.route_id, destination.destination_airport, airport_info.city
     	      FROM destination, airport_info
     	      WHERE destination.destination_airport=airport_info.airport_code),
     X AS (SELECT info.reservation_number, info.passport_number, info.city_of_residence, trip_info.route_id
     	   FROM info, trip_info
     	   WHERE info.trip_id=trip_info.trip_id)
SELECT X.reservation_number, X.passport_number, X.city_of_residence, city.destination_airport, city.city
FROM X, city
WHERE X.route_id=city.route_id
AND X.city_of_residence=city.city;


