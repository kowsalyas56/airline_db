## Airline Database Analysis Using MYSQL

## Coding 

create database project1;

use project1;

create table airline1(airline_id int primary key,airlinename varchar(20),numberofflight int);

insert into airline1 values(101,'delhi airline',3),
(102,'quater airline',2),
(103,"singapore airline",4),
(104,'air india',2),
(105,'emirates',5),
(106,'united airline',2),
(107,'indigo air',6);

select * from airline1;

create table flight(flight_id int primary key,name varchar(20),airline_id int, Foreign key(airline_id)references airline1(airline_id),fromlocation varchar(60),tolocation varchar(70),departuredate date);

insert into flight values(1,'AX102',106,'chennai','delhi','2023-02-12'),
(2,'AX103',102,'chennai','mumbai','2023-04-16'),
(3,'AX104',102,'madurai','chennai','2023-02-28'),
(4,'AX105',107,'delhi','dubai','2023-08-04'),
(5,'AX106',104,'chennai','kolkata','2023-12-17'),
(6,'AX107',102,'bangalore','hydrabad','2023-08-15'),
(7,'AX108',101,'chennai','mumbai','2024-11-20'),
(8,'AX109',107,'chennai','london','2024-06-12'),
(9,'AX110',102,'trivandrum','bali','2024-08-14'),
(10,'AX111',104,'chennai','usa','2023-08-31');

select * from flight;

create table passenger(passenger_id int primary key,name varchar(50),flight_id int,foreign key(flight_id)references flight(flight_id),total_passenger int,age int);

insert into passenger values(1011,'ramya',3,4,55),
(1012,'harini',8,1,21),
(1013,'zara',3,8,61),
(1014,'john',5,4,35),
(1015,'raju',3,10,25),
(1016,'kaviya',6,7,21),
(1017,'ram',5,7,55),
(1018,'rosy',8,10,46),
(1019,'harini',3,9,65),
(1020,'priya',4,5,47),
(1021,'reshma',5,10,35),
(1022,'kavi',5,1,23),
(1023,'ragav',5,3,70),
(1024,'hari',6,4,46),
(1025,'monika',2,5,73),
(1026,'prabha',5,5,50),
(1027,'divya',6,6,36),
(1028,'kani',4,6,53),
(1029,'kaviya',7,6,40),
(1030,'banu',5,9,34);

select *from passenger;

create table booking(book_id int primary key,flight_id int,Foreign key(flight_id)references flight(flight_id),passenger_id int,Foreign key(passenger_id)references passenger(passenger_id),booking_date date,status varchar(70));

insert into booking values(500,2,1025,'2023-03-14','booked'),
(501,7,1028,'2024-08-31','cancelled'),
(502,6,1017,'2023-02-27','booked'),
(503,10,1011,'2023-12-28','cancelled'),
(504,8,1012,'2024-08-15','booked'),
(505,5,1022,'2024-10-29','booked'),
(506,1,1030,'2023-01-01','cancelled'),
(507,4,1023,'2024-02-15','booked'),
(508,9,1015,'2023-04-20','booked'),
(509,1,1012,'2023-07-27','cancelled'),
(510,3,1014,'2023-04-15','booked'),
(511,7,1028,'2024-10-29','booked'),
(512,6,1015,'2023-05-27','cancelled'),
(513,10,1016,'2023-06-24','booked'),
(514,4,1028,'2023-01-29','booked'),
(515,5,1027,'2023-07-27','booked');

select * from booking;

create table payment(payment_id int,book_id int,foreign key(book_id)references booking(book_id),amount int,pay_method varchar(40),status varchar(60));

insert into payment values(8880,514,55000,'cash','paid'),
(8881,512,65000,'gpay','notpaid'),
(8882,515,4500,'gpay','paid'),
(8883,511,6000,'cash','paid'),
(8883,513,67000,'cash','notpaid'),
(8884,509,8000,'gpay','paid'),
(8885,510,75000,'cash','notpaid'),
(8886,507,100000,'gpay','paid'),
(8887,506,86000,'cash','paid'),
(8888,508,9000,'gpay','paid'),
(8889,505,93000,'cash','notpaid'),
(8890,503,67000,'cash','paid'),
(8891,502,58000,'gpay','paid'),
(8892,500,89000,'cash','paid'),
(8893,504,78000,'cash','paid'),
(8894,502,58000,'cash','paid');

select * from payment;

# Views
#1.Passenger Count By Booking Status

CREATE VIEW 
booking_status AS
select  b.status,count( p.passenger_id) as total_passenger 
from passenger p join booking b ON p.passenger_id=b.passenger_id 
where b.status in ('booked','cancelled')
group by b.status;

# 2. Passenger Count By Payment Status

CREATE VIEW payment_status AS
select r.status,count(b.passenger_id)as count_passenger 
from booking b join passenger p on b.passenger_id=p.passenger_id 
join payment r on r.book_id=b.book_id 
where r.status in ('paid','notpaid') 
group by r.status ;

# 3. Top 5 Flights With Highest Number Of Passengers

CREATE VIEW highest_number_of_passenger AS
select count(p.name)as count_passenger,f.name 
from flight f join passenger p on f.flight_id=p.flight_id 
group by f.name order by count_passenger desc limit 5;

# 4.  Bookings Made in the Year 2024

CREATE VIEW booking_date AS
select * from booking where booking_date between'2024-01-01'and '2024-12-29' ;

#5. Airline-wise Total Flights Operated

CREATE VIEW airline AS
select a.airlinename,count(f.name) as count_of_flight from airline1 a join flight f 
on a.airline_id=f.airline_id 
group by a.airlinename order by  count_of_flight asc;

# Stored Prcedure
#1. Top 3 Payments Below the Total Sum Of All Payments

DELIMITER $$
CREATE PROCEDURE payment_below ()
BEGIN
select  pay_method ,amount 
from payment where amount<(select sum(amount)from payment) 
order by amount desc 
limit 3;
END 
DELIMITER ;

#2.  Senior Citizens Traveling By Flight"

DELIMITER $$
CREATE PROCEDURE senior_citizens ()
BEGIN
select f.name,f.fromlocation,f.tolocation,p.name,p.age from flight f join passenger p 
on f.flight_id=p.flight_id where p.age>60;
END
DELIMITER ;

#3.  top 3 Frequently Used Flight Routes

DELIMITER $$
CREATE PROCEDURE frequently_flight ()
BEGIN
SELECT f.fromlocation,f.tolocation,COUNT(f.name) AS total_flights FROM flight f 
GROUP BY f.fromlocation, f.tolocation 
ORDER BY total_flights DESC limit 3;
END$$
DELIMITER ;
