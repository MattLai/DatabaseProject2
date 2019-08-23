"
A table having city as row and each day of the week as column, 
showing a percentage based on number of trips. 
That is, finding out the busiest days.
"

WITH A AS (SELECT leg_route_info.route_id, leg_route_info.leg_number, 
					leg_detail_info.starting_airport, leg_detail_info.destination_airport
			FROM leg_route_info, leg_detail_info
			WHERE leg_route_info.leg_number=leg_detail_info.leg_number),
	 start AS (SELECT trip_info.trip_date, A.starting_airport
				FROM A, trip_info
				WHERE A.route_id=trip_info.route_id
				ORDER BY trip_info.trip_date),
	 dest AS (SELECT trip_info.trip_date, A.destination_airport
				FROM A, trip_info
				WHERE A.route_id=trip_info.route_id
				ORDER BY trip_info.trip_date),
	 start_convert AS (SELECT start.trip_date, start.starting_airport,
						EXTRACT(DOW FROM start.trip_date) = 1 as monday,
						EXTRACT(DOW FROM start.trip_date) = 2 as tuesday,
						EXTRACT(DOW FROM start.trip_date) = 3 as wednesday,
						EXTRACT(DOW FROM start.trip_date) = 4 as thursday,
						EXTRACT(DOW FROM start.trip_date) = 5 as friday,
						EXTRACT(DOW FROM start.trip_date) = 6 as saturday,
						EXTRACT(DOW FROM start.trip_date) = 0 as sunday
						FROM start
						ORDER BY start.starting_airport),
	 dest_convert AS (SELECT dest.trip_date, dest.destination_airport,
						EXTRACT(DOW FROM dest.trip_date) = 1 as monday,
						EXTRACT(DOW FROM dest.trip_date) = 2 as tuesday,
						EXTRACT(DOW FROM dest.trip_date) = 3 as wednesday,
						EXTRACT(DOW FROM dest.trip_date) = 4 as thursday,
						EXTRACT(DOW FROM dest.trip_date) = 5 as friday,
						EXTRACT(DOW FROM dest.trip_date) = 6 as saturday,
						EXTRACT(DOW FROM dest.trip_date) = 0 as sunday
						FROM dest
						ORDER BY dest.destination_airport),
	 start_count AS (SELECT start_convert.starting_airport, count(CASE WHEN start_convert.monday THEN 1 END) AS monday, 
										count(CASE WHEN start_convert.tuesday THEN 1 END) AS tuesday,
										count(CASE WHEN start_convert.wednesday THEN 1 END) As wednesday,
										count(CASE WHEN start_convert.thursday THEN 1 END) As thursday,
										count(CASE WHEN start_convert.friday THEN 1 END) As friday,
										count(CASE WHEN start_convert.saturday THEN 1 END) As saturday,
										count(CASE WHEN start_convert.sunday THEN 1 END) As sunday
					FROM start_convert
					GROUP BY starting_airport),
	 dest_count AS (SELECT dest_convert.destination_airport, count(CASE WHEN dest_convert.monday THEN 1 END) AS monday, 
											count(CASE WHEN dest_convert.tuesday THEN 1 END) AS tuesday,
											count(CASE WHEN dest_convert.wednesday THEN 1 END) As wednesday,
											count(CASE WHEN dest_convert.thursday THEN 1 END) As thursday,
											count(CASE WHEN dest_convert.friday THEN 1 END) As friday,
											count(CASE WHEN dest_convert.saturday THEN 1 END) As saturday,
											count(CASE WHEN dest_convert.sunday THEN 1 END) As sunday
					FROM dest_convert
					GROUP BY destination_airport),
	 total_count AS (SELECT start_count.starting_airport, (start_count.monday+dest_count.monday) AS monday, (start_count.tuesday+dest_count.tuesday) AS tuesday,
		(start_count.wednesday+dest_count.wednesday) AS wednesday, (start_count.thursday+dest_count.thursday) AS thursday, (start_count.friday+dest_count.friday) AS friday, 
		(start_count.saturday+dest_count.saturday) AS saturday, (start_count.sunday+dest_count.sunday) AS sunday
						FROM start_count, dest_count
						WHERE start_count.starting_airport=dest_count.destination_airport),
	 city_name AS (SELECT airport_info.city, total_count.monday, total_count.tuesday, total_count.wednesday,
	 						total_count.thursday, total_count.friday, total_count.saturday, total_count.sunday
	 				FROM airport_info, total_count
	 				WHERE airport_info.airport_code=total_count.starting_airport)
SELECT city_name.city, 
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.monday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS monday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.tuesday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS tuesday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.wednesday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS wednesday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.thursday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS thursday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.friday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS friday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.saturday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS saturday,
CASE 
	WHEN city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday >=1
	THEN TRUNC(city_name.sunday*100.0/(city_name.monday+city_name.tuesday+city_name.wednesday+city_name.thursday+city_name.friday+city_name.saturday+city_name.sunday),2)
	ELSE 0
	END AS sunday
FROM city_name;




"
Backup
"
WITH A AS (SELECT trip_info.trip_date, flight_route_info.starting_airport,
			EXTRACT(DOW FROM trip_info.trip_date) = 1 as monday,
			EXTRACT(DOW FROM trip_info.trip_date) = 2 as tuesday,
			EXTRACT(DOW FROM trip_info.trip_date) = 3 as wednesday,
			EXTRACT(DOW FROM trip_info.trip_date) = 4 as thursday,
			EXTRACT(DOW FROM trip_info.trip_date) = 5 as friday,
			EXTRACT(DOW FROM trip_info.trip_date) = 6 as saturday,
			EXTRACT(DOW FROM trip_info.trip_date) = 0 as sunday
			FROM trip_info, flight_route_info
			WHERE trip_info.route_id=flight_route_info.route_id
			AND flight_route_info.starting_airport IS NOT NULL
			AND flight_route_info.destination_airport IS NOT NULL
			ORDER BY flight_route_info.starting_airport)
SELECT A.starting_airport, count(CASE WHEN A.monday THEN 1 END) AS monday, 
						count(CASE WHEN A.tuesday THEN 1 END) AS tuesday,
						count(CASE WHEN A.wednesday THEN 1 END) As wednesday,
						count(CASE WHEN A.thursday THEN 1 END) As thursday,
						count(CASE WHEN A.friday THEN 1 END) As friday,
						count(CASE WHEN A.saturday THEN 1 END) As saturday,
						count(CASE WHEN A.sunday THEN 1 END) As sunday
FROM A
GROUP BY starting_airport




select activityid, pass, fail,
 pass*100.0/(pass + fail) as passPercentage,
 fail*100.0/(pass + fail) as failPercentage
from cte


WITH A AS (SELECT leg_route_info.route_id, leg_route_info.leg_number, 
					leg_detail_info.starting_airport, leg_detail_info.destination_airport
			FROM leg_route_info, leg_detail_info
			WHERE leg_route_info.leg_number=leg_detail_info.leg_number),
	 start AS (SELECT trip_info.trip_date, A.starting_airport
				FROM A, trip_info
				WHERE A.route_id=trip_info.route_id
				ORDER BY trip_info.trip_date),
	 dest AS (SELECT trip_info.trip_date, A.destination_airport
				FROM A, trip_info
				WHERE A.route_id=trip_info.route_id
				ORDER BY trip_info.trip_date),
	 start_convert AS (SELECT start.trip_date, start.starting_airport,
						EXTRACT(DOW FROM start.trip_date) = 1 as monday,
						EXTRACT(DOW FROM start.trip_date) = 2 as tuesday,
						EXTRACT(DOW FROM start.trip_date) = 3 as wednesday,
						EXTRACT(DOW FROM start.trip_date) = 4 as thursday,
						EXTRACT(DOW FROM start.trip_date) = 5 as friday,
						EXTRACT(DOW FROM start.trip_date) = 6 as saturday,
						EXTRACT(DOW FROM start.trip_date) = 0 as sunday
						FROM start
						ORDER BY start.starting_airport),
	 dest_convert AS (SELECT dest.trip_date, dest.destination_airport,
						EXTRACT(DOW FROM dest.trip_date) = 1 as monday,
						EXTRACT(DOW FROM dest.trip_date) = 2 as tuesday,
						EXTRACT(DOW FROM dest.trip_date) = 3 as wednesday,
						EXTRACT(DOW FROM dest.trip_date) = 4 as thursday,
						EXTRACT(DOW FROM dest.trip_date) = 5 as friday,
						EXTRACT(DOW FROM dest.trip_date) = 6 as saturday,
						EXTRACT(DOW FROM dest.trip_date) = 0 as sunday
						FROM dest
						ORDER BY dest.destination_airport),
	 start_count AS (SELECT start_convert.starting_airport, count(CASE WHEN start_convert.monday THEN 1 END) AS monday, 
										count(CASE WHEN start_convert.tuesday THEN 1 END) AS tuesday,
										count(CASE WHEN start_convert.wednesday THEN 1 END) As wednesday,
										count(CASE WHEN start_convert.thursday THEN 1 END) As thursday,
										count(CASE WHEN start_convert.friday THEN 1 END) As friday,
										count(CASE WHEN start_convert.saturday THEN 1 END) As saturday,
										count(CASE WHEN start_convert.sunday THEN 1 END) As sunday
					FROM start_convert
					GROUP BY starting_airport),
	 dest_count AS (SELECT dest_convert.destination_airport, count(CASE WHEN dest_convert.monday THEN 1 END) AS monday, 
											count(CASE WHEN dest_convert.tuesday THEN 1 END) AS tuesday,
											count(CASE WHEN dest_convert.wednesday THEN 1 END) As wednesday,
											count(CASE WHEN dest_convert.thursday THEN 1 END) As thursday,
											count(CASE WHEN dest_convert.friday THEN 1 END) As friday,
											count(CASE WHEN dest_convert.saturday THEN 1 END) As saturday,
											count(CASE WHEN dest_convert.sunday THEN 1 END) As sunday
					FROM dest_convert
					GROUP BY destination_airport),
	 total_count AS (SELECT start_count.starting_airport, (start_count.monday+dest_count.monday) AS monday, (start_count.tuesday+dest_count.tuesday) AS tuesday,
		(start_count.wednesday+dest_count.wednesday) AS wednesday, (start_count.thursday+dest_count.thursday) AS thursday, (start_count.friday+dest_count.friday) AS friday, 
		(start_count.saturday+dest_count.saturday) AS saturday, (start_count.sunday+dest_count.sunday) AS sunday
						FROM start_count, dest_count
						WHERE start_count.starting_airport=dest_count.destination_airport)
SELECT total_count.starting_airport, 
CASE 
	WHEN total_count.monday+total_count.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.monday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS monday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.tuesday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS tuesday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.wednesday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS wednesday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.thursday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS thursday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.friday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS friday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.saturday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS saturday,
CASE 
	WHEN B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday >=1
	THEN TRUNC(B.sunday*100.0/(B.monday+B.tuesday+B.wednesday+B.thursday+B.friday+B.saturday+B.sunday),2)
	ELSE 0
	END AS sunday
FROM B;




WITH start_city AS (SELECT flight_route_info.route_id, flight_route_info.starting_airport,
		airport_info.city
					FROM flight_route_info, airport_info
					WHERE flight_route_info.starting_airport=airport_info.airport_code),
	 count_start AS (SELECT (start_city.city) AS departure_city, COUNT(*)
	 					FROM start_city
	 					GROUP BY start_city.city
	 					HAVING COUNT(*)>=1),
	 dest_city AS (SELECT flight_route_info.route_id, flight_route_info.destination_airport,
		airport_info.city
					FROM flight_route_info, airport_info
					WHERE flight_route_info.destination_airport=airport_info.airport_code),
	 count_dest AS (SELECT (dest_city.city) AS arrival_city, COUNT(*)
					FROM dest_city
					GROUP BY arrival_city
					HAVING COUNT(*)>=1),
	 combine AS (SELECT count_start.departure_city, (count_start.count) AS departure_count, count_dest.arrival_city, (count_dest.count) AS arrival_count
					FROM count_start, count_dest
					WHERE count_start.departure_city=count_dest.arrival_city)
SELECT combine.departure_city, combine.departure_count+combine.arrival_count AS total_count 
FROM combine
ORDER BY total_count DESC;


"
List all reservation source and destination only for valid trips ; source/destination cannot be null. 	
"
WITH valid_trip AS (SELECT trip_info.trip_id, flight_route_info.starting_airport, flight_route_info.destination_airport
                      FROM flight_route_info
                      INNER JOIN trip_info 
                      ON trip_info.route_id=flight_route_info.route_id
                      WHERE flight_route_info IS NOT NULL),
     reservation_and_trip_num AS (SELECT boarding_pass_info.reservation_number, boarding_pass_info.passport_number, boarding_pass_info.trip_id
                                  FROM reservation_info
                                  INNER JOIN boarding_pass_info
                                  ON reservation_info.reservation_number=boarding_pass_info.reservation_number)
SELECT reservation_and_trip_num.reservation_number, valid_trip.starting_airport, valid_trip.destination_airport
FROM valid_trip 
INNER JOIN reservation_and_trip_num
ON valid_trip.trip_id=reservation_and_trip_num.trip_id;

"
List all reservation source and destination only for invalid trips ; source/destination can be null. 
"
WITH invalid_trip AS (SELECT trip_info.trip_id, flight_route_info.starting_airport, flight_route_info.destination_airport
                      FROM flight_route_info
                      INNER JOIN trip_info 
                      ON trip_info.route_id=flight_route_info.route_id
                      WHERE flight_route_info.starting_airport IS NULL
                      OR flight_route_info.destination_airport IS NULL),
     reservation_and_trip_num AS (SELECT boarding_pass_info.reservation_number, boarding_pass_info.passport_number, boarding_pass_info.trip_id
                                  FROM reservation_info
                                  INNER JOIN boarding_pass_info
                                  ON reservation_info.reservation_number=boarding_pass_info.reservation_number)
SELECT reservation_and_trip_num.reservation_number, invalid_trip.starting_airport, invalid_trip.destination_airport
FROM invalid_trip 
INNER JOIN reservation_and_trip_num
ON invalid_trip.trip_id=reservation_and_trip_num.trip_id;

"
Customers who have traveled to every available city.
"
WITH A AS (SELECT trip_info.trip_id, trip_info.trip_date, trip_info.route_id, boarding_pass_info.reservation_number
			FROM trip_info
			INNER JOIN boarding_pass_info
			ON trip_info.trip_id = boarding_pass_info.trip_id
			WHERE trip_status=1),
	 B AS (SELECT flight_route_info.route_id, airport_info.airport_code, airport_info.city
			FROM flight_route_info, airport_info
			WHERE flight_route_info.destination_airport=airport_info.airport_code),
	 C AS (SELECT A.trip_id, A.reservation_number
			FROM A, B
			WHERE A.route_id=B.route_id),
	 D AS (SELECT boarding_pass_info.reservation_number, reservation_info.reserver_name
			FROM boarding_pass_info
			INNER JOIN reservation_info
			ON boarding_pass_info.reservation_number = reservation_info.reservation_number)
SELECT C.trip_id, D.reserver_name
FROM C, D
WHERE C.reservation_number=D.reservation_number;


"
List customers who have two or more invalid trips; List those invalid trips sorted by customer.
"
WITH invalid_trip AS (SELECT trip_info.trip_id, flight_route_info.starting_airport, flight_route_info.destination_airport
                      FROM flight_route_info
                      INNER JOIN trip_info 
                      ON trip_info.route_id=flight_route_info.route_id
                      WHERE flight_route_info.starting_airport IS NULL
                      OR flight_route_info.destination_airport IS NULL),
	 name AS (SELECT reservation_info.reserver_name, reservation_info.reservation_number, boarding_pass_info.trip_id
	 			FROM reservation_info, boarding_pass_info
	 			WHERE reservation_info.reservation_number=boarding_pass_info.reservation_number),
	 result AS (SELECT name.reserver_name, name.trip_id, invalid_trip.starting_airport, invalid_trip.destination_airport
				FROM name
				INNER JOIN invalid_trip
				ON invalid_trip.trip_id=name.trip_id)
SELECT reserver_name, COUNT(*)
FROM result
GROUP BY reserver_name
HAVING COUNT(*)>1
ORDER BY reserver_name;











	 