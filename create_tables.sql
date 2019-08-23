DROP TABLE IF EXISTS airport_info CASCADE;
DROP TABLE IF EXISTS seat_class_info CASCADE;
DROP TABLE IF EXISTS aircraft_seat_info CASCADE;
DROP TABLE IF EXISTS aircraft_info CASCADE;
DROP TABLE IF EXISTS model_B787_10 CASCADE;
DROP TABLE IF EXISTS model_B777_300ER CASCADE;
DROP TABLE IF EXISTS model_B737_800 CASCADE;
DROP TABLE IF EXISTS tax_type_info CASCADE;
DROP TABLE IF EXISTS flight_route_info CASCADE;
DROP TABLE IF EXISTS aircraft_info CASCADE;
DROP TABLE IF EXISTS leg_detail_info CASCADE;
DROP TABLE IF EXISTS leg_route_info CASCADE;
DROP TABLE IF EXISTS membership_level_info CASCADE;
DROP TABLE IF EXISTS membership_info CASCADE;
DROP TABLE IF EXISTS customer_info CASCADE;
DROP TABLE IF EXISTS payment_method_info CASCADE;
DROP TABLE IF EXISTS reservation_info CASCADE;
DROP TABLE IF EXISTS flight_status_info CASCADE;
DROP TABLE IF EXISTS trip_status_info CASCADE;
DROP TABLE IF EXISTS trip_info CASCADE;
DROP TABLE IF EXISTS boarding_pass_info CASCADE;
DROP TABLE IF EXISTS boarding_pass_number_counter CASCADE;
DROP TABLE IF EXISTS reservation_number_counter CASCADE;
CREATE TABLE airport_info(
	airport_code CHAR(4) NOT NULL,
	airport_name CHAR(30),
	city CHAR(20),
	state CHAR(40),
	country CHAR (40),
	PRIMARY KEY (airport_code)
);
CREATE TABLE seat_class_info(
	seat_class INT,
	class_name CHAR(10),
	PRIMARY KEY (seat_class)
);
CREATE TABLE aircraft_info(
	aircraft_id INT,
	model_number CHAR(10),
	PRIMARY KEY (aircraft_id)
);
CREATE TABLE model_B787_10(
	seat_number CHAR(4),
	seat_class INT,
	PRIMARY KEY (seat_number),
	CONSTRAINT model_B787_seat_class_fkey FOREIGN KEY (seat_class)
		REFERENCES seat_class_info (seat_class) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE model_B777_300ER(
	seat_number CHAR(4),
	seat_class INT,
	PRIMARY KEY (seat_number),
	CONSTRAINT model_B777_300ER_seat_class_fkey FOREIGN KEY (seat_class)
		REFERENCES seat_class_info (seat_class) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE model_B737_800(
	seat_number CHAR(4),
	seat_class INT,
	PRIMARY KEY (seat_number),
	CONSTRAINT model_B737_800_seat_class_fkey FOREIGN KEY (seat_class)
		REFERENCES seat_class_info (seat_class) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE tax_type_info(
	tax_type INT,
	tax_name CHAR(20),
	tax_percentage FLOAT(4),
	PRIMARY KEY (tax_type)
);
CREATE TABLE flight_route_info(
	route_id INT,
	route_name CHAR(30),
	starting_airport CHAR(3),
	destination_airport CHAR(3),
	total_flight_duration INT,
	tax_type INT,
	PRIMARY KEY (route_id),
	CONSTRAINT flight_route_airport_info_fkey1 FOREIGN KEY (starting_airport) 
		REFERENCES airport_info (airport_code) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT flight_route_airport_info_fkey2 FOREIGN KEY (destination_airport)
		REFERENCES airport_info (airport_code) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT flight_route_tax_type_fkey FOREIGN KEY (tax_type)
		REFERENCES tax_type_info (tax_type)
		ON DELETE CASCADE
);
CREATE TABLE leg_detail_info(
	leg_number INT,
	flight_duration INT,
	distance INT,
	starting_airport CHAR(4),
	destination_airport CHAR(4),
	PRIMARY KEY (leg_number),
	CONSTRAINT legs_airport_info_fkey1 FOREIGN KEY (starting_airport) 
		REFERENCES airport_info (airport_code) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT legs_airport_info_fkey2 FOREIGN KEY (destination_airport)
		REFERENCES airport_info (airport_code) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE leg_route_info(
	leg_id INT,
	leg_number INT,
	route_id INT,
	PRIMARY KEY (leg_id),
	CONSTRAINT leg_route_detail_info_fkey FOREIGN KEY (leg_number)
		REFERENCES leg_detail_info (leg_number) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT leg_flight_route_fkey FOREIGN KEY (route_id)
		REFERENCES flight_route_info (route_id) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE membership_level_info(
	membership_level INT,
	membership_level_name CHAR(10),
	PRIMARY KEY (membership_level)
);
CREATE TABLE membership_info(
	member_id INT,
	current_mileage INT,
	cumulative_mileage_earned INT,
	membership_level INT,
	PRIMARY KEY (member_id),
	CONSTRAINT membership_info_level_fkey FOREIGN KEY (membership_level)
		REFERENCES membership_level_info (membership_level) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE customer_info(
	passport_number CHAR(9),
	first_name CHAR(20),
	last_name CHAR(20),
	birthdate DATE,
	phone_number CHAR(15),
	resident_address CHAR(50),
	city_of_residence CHAR(20),
	nationality CHAR(20),
	member_id INT,
	PRIMARY KEY (passport_number),
	CONSTRAINT member_fkey FOREIGN KEY (member_id)
		REFERENCES membership_info (member_id) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE payment_method_info(
	payment_method_id INT,
	payment_type CHAR(20),
	PRIMARY KEY (payment_method_id)
);
CREATE TABLE reservation_info(
	reservation_number INT,
	reservation_date DATE,
	reserver_name CHAR(40),
	payment_method_id INT,
	payment_subtotal NUMERIC(8,2),
	payment_tax NUMERIC(8,2),
	payment_total NUMERIC(8,2),
	round_trip CHAR(1),
	PRIMARY KEY (reservation_number),
	CONSTRAINT reservation_info_payment_method_fkey FOREIGN KEY (payment_method_id)
		REFERENCES payment_method_info (payment_method_id) MATCH FULL
		ON DELETE CASCADE	
);
CREATE TABLE flight_status_info(
	flight_status INT,
	status_name CHAR(20),
	PRIMARY KEY (flight_status)
);
CREATE TABLE trip_status_info(
	trip_status_id INT,
	trip_status_name CHAR(10),
	PRIMARY KEY (trip_status_id)
);
CREATE TABLE trip_info(
	trip_id INT,
	flight_number CHAR(10),
	trip_date DATE,
	trip_time TIME,
	aircraft_id INT,
	route_id INT,
	trip_status INT,
	flight_status INT,
	base_economy_price NUMERIC(8,2),
	base_business_price NUMERIC(8,2),
	estimated_departure_time TIME,
	PRIMARY KEY (trip_id),
	CONSTRAINT aircraft_id_fkey FOREIGN KEY (aircraft_id)
		REFERENCES aircraft_info (aircraft_id) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT route_id_fkey FOREIGN KEY (route_id)
		REFERENCES flight_route_info (route_id) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT trip_status_fkey FOREIGN KEY (trip_status)
		REFERENCES trip_status_info (trip_status_id) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT flight_status_fkey FOREIGN KEY (flight_status)
		REFERENCES flight_status_info (flight_status) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE boarding_pass_info(
	boarding_pass_number INT,
	trip_id INT,
	reservation_number INT,
	passport_number CHAR(9),
	PRIMARY KEY (boarding_pass_number),
	CONSTRAINT reservation_fkey FOREIGN KEY (reservation_number)
		REFERENCES reservation_info (reservation_number) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT trip_fkey FOREIGN KEY (trip_id)
		REFERENCES trip_info (trip_id) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT passport_number_fkey FOREIGN KEY (passport_number)
		REFERENCES customer_info (passport_number) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE aircraft_seat_info(
	flight_number CHAR(10),
	trip_date DATE,
	aircraft_id INT,
	seat_number CHAR(4),
	seat_class INT,
	boarding_pass_number INT,
	PRIMARY KEY (flight_number, trip_date, seat_number),
	CONSTRAINT plane_model_info_seat_class_info_fkey FOREIGN KEY (seat_class)
		REFERENCES seat_class_info (seat_class) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT aircraft_seat_info_aircraft_info_fkeys FOREIGN KEY (aircraft_id)
		REFERENCES aircraft_info (aircraft_id) MATCH FULL
		ON DELETE CASCADE,
	CONSTRAINT seat_boarding_pass_seat_fkey FOREIGN KEY (boarding_pass_number)
		REFERENCES boarding_pass_info (boarding_pass_number) MATCH FULL
		ON DELETE CASCADE
);
CREATE TABLE boarding_pass_number_counter(
	curr_num INT
);
CREATE TABLE reservation_number_counter(
	curr_num INT
);