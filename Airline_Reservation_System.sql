

CREATE TABLE Airport(
AirportName VARCHAR(30) NOT NULL,
City VARCHAR(30) NOT NULL,
id INTEGER,
PRIMARY KEY (id),
);

CREATE TABLE Worker(
WorkerID INTEGER,
Name VARCHAR(30) NOT NULL,
Age INTEGER NOT NULL,
Payment DECIMAL(18,2) NOT NULL,
Job VARCHAR(30) NOT NULL,
AirportId INTEGER NOT NULL,
PRIMARY KEY (WorkerID),
FOREIGN KEY (AirportId) REFERENCES Airport (id)
);


CREATE TABLE Employed(
AirportId INTEGER,
WorkerID INTEGER,
PRIMARY KEY (AirportId, WorkerID),
FOREIGN KEY (AirportId) REFERENCES Airport (id),
FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID)
);

CREATE TABLE Flight(
FlightNumber INTEGER,
DepartureHour datetime2 NOT NULL,
DepartureAirport INTEGER NOT NULL,
ArrivalHour datetime2 NOT NULL,
ArrivalAirport INTEGER NOT NULL,
PRIMARY KEY (FlightNumber),

);

CREATE TABLE INOUT(
AirportId INTEGER,
FlightNumber INTEGER,
PRIMARY KEY(AirportId, FlightNumber),
FOREIGN KEY(AirportId) REFERENCES Airport(id),
FOREIGN KEY(FlightNumber) REFERENCES Flight(FlightNumber)
);


CREATE TABLE Ticket(
OrderNumber INTEGER,
FlightCompany INTEGER NOT NULL,
SeatClass VARCHAR(30) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
PassengerName  VARCHAR(30) NOT NULL,
FlightNumber INTEGER NOT NULL,
PRIMARY KEY (OrderNumber),
FOREIGN KEY (FlightNumber) REFERENCES Flight (FlightNumber)
);

CREATE TABLE Supplier(
SupplierID INTEGER,
type VARCHAR(30) NOT NULL,
PRIMARY KEY (SupplierID)
);

CREATE TABLE FlightCompany(
SupplierID INTEGER,
FlightCompanyName VARCHAR(30) NOT NULL,
FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID),
PRIMARY KEY (SupplierID)
);

CREATE TABLE BookingAgent(
SupplierID INTEGER,
AgentName VARCHAR(30) NOT NULL,
BookingCompanyName VARCHAR(30) NOT NULL,
FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID),
PRIMARY KEY (SupplierID)
);


CREATE TABLE Purchase(

OrderNumber INTEGER ,
SupplierID INTEGER ,
FlightNumber INTEGER ,
PRIMARY KEY (FlightNumber, SupplierID),
FOREIGN KEY (OrderNumber) REFERENCES Ticket (OrderNumber),
FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID),
FOREIGN KEY (FlightNumber) REFERENCES Flight (FlightNumber),
UNIQUE(OrderNumber)
);


INSERT INTO Airport(id, AirportName, City) 
VALUES(1, 'Shahjalal Airport', 'Dhaka'),
(2, 'Shah Poran Airport', 'Sylhet'),
(3, 'Chennai International Airport','Chennai')

INSERT INTO Worker(WorkerID, Name, Age, Payment, Job, AirportId) 
VALUES(1, 'Sifat Nabil', 24, 50000.00, 'Airport Dispatcher', 1),
(2, 'Sajid Eimo', 24, 80000.00, 'Operation Crew Manager', 2),
(3, 'Dipta Das',26,60000.00,'Flight Attendent', 3)

INSERT INTO Employed(AirportId, WorkerID) 
VALUES(1, 2),
(2, 3),
(3, 1)

INSERT INTO Flight(FlightNumber, ArrivalAirport, ArrivalHour, DepartureAirport, DepartureHour)
VALUES(1, 2, '2018-09-11 13:23:44', 1, '2018-9-12 13:23:44'),
(2, 3, '2018-09-20 13:23:44', 1, '2018-9-21 14:23:44'),
(3, 1, '2018-09-25 13:23:44', 1, '2018-9-27 16:23:44') 

INSERT INTO INOUT(AirportId, FlightNumber) 
VALUES(2, 1),
(3, 2),
(1, 3)

INSERT INTO Ticket(OrderNumber, FlightCompany, SeatClass, Price, PassengerName, FlightNumber) 
VALUES(1, 2, 'Business', 5000.00, 'Sifat Nabil', 2),
(2, 1, 'First Class', 6000.00, 'Sajid Eimo', 1),
(3, 3, 'Economy',3000.00, 'Dipta Das', 3)

INSERT INTO Supplier(SupplierID, type)
VALUES(2, 'Booking Agent'),
(1, 'Flight Company'),
(3, 'Flight Company')

INSERT INTO FlightCompany(SupplierID, FlightCompanyName)
VALUES(1, 'Bangladesh Airlines'),
(3, 'Desh Airlines')

INSERT INTO BookingAgent(SupplierID, AgentName, BookingCompanyName)
VALUES(2, 'Rejwan Shuvo', 'Tahmeed Airline Bookings')

INSERT INTO Purchase(OrderNumber, SupplierID, FlightNumber)
VALUES ( 2, 1, 3),
(1, 2, 2),
(3, 3, 1)


--> 1. Show all the airport information
SELECT * FROM Airport

--> 2. Show all the Worker Information
SELECT * FROM Worker

--> 3. Show all the Flight Details
SELECT * FROM Flight

--> 4. Show all the ticket information
SELECT * FROM Ticket

--> 5. Show all the supplier info who are Flight Company
SELECT * FROM FlightCompany

--> 6. Show all the supplier info who are Booking Agent
SELECT * FROM BookingAgent

--> 7. Show all the airports that are in Dhaka
SELECT * FROM Airport WHERE City='Dhaka'

--> 8. Show the location of Shah Poran Airport
SELECT * FROM Airport WHERE AirportName='Shah Poran Airport'

--> 9. Show the airports that starts with Shah
SELECT * FROM Airport WHERE AirportName='Shah%'

--> 10. Show the arrival hour of Flight Number 1
SELECT ArrivalHour FROM Flight WHERE FlightNumber = 1

--> 11. Show all the Flights leaving Shahjalal Airport **
SELECT * FROM Flight WHERE 
DepartureAirport 
IN (SELECT id FROM Airport 
WHERE AirportName='Shahjalal Airport')

--> 12. Show the last departure hour of Flight No. 2
SELECT TOP 1 * FROM Flight WHERE FlightNumber= 2 ORDER BY DepartureHour DESC

--> 13. Show all the flights arriving at Chennai Airport
SELECT * FROM Flight WHERE 
ArrivalAirport 
IN (SELECT id FROM Airport WHERE 
AirportName='Chennai International Airport')

--> 14. Show all the flights arriving at Dhaka City
SELECT * FROM Flight WHERE ArrivalAirport IN (SELECT id FROM Airport WHERE City='Dhaka')

--> 15. Show the Departure airport of Flight No. 3
SELECT DepartureAirport FROM Flight WHERE FlightNumber = 3

--> 16. Show the Flights arriving at Chennai today
SELECT * FROM Flight WHERE 
cast(GETDATE() as DATE) = cast(ArrivalHour as DATE) 
AND ArrivalAirport IN 
(SELECT id FROM Airport WHERE AirportName='Chennai International Airport')

--> 17. Show the Flights leaving Dhaka Today
SELECT * FROM Flight WHERE 
cast(GETDATE() as DATE) = cast(DepartureHour as DATE) 
AND DepartureAirport IN (SELECT id FROM Airport WHERE City='Dhaka')

--> 18. Show the flights that arrived at Sylhet 28th September 2018
SELECT * FROM Flight WHERE 
cast(ArrivalHour as DATE) = '2018-09-28' 
AND ArrivalAirport 
IN (SELECT id FROM Airport WHERE City='Sylhet')

--> 19. Show the flights arriving three days ago
SELECT * FROM Flight WHERE ArrivalHour =  DATEADD(day, -3, GETDATE())

--> 20. Show the flight leaving Dhaka for Sylhet Today after 7 pm.
SELECT * FROM Flight WHERE 
cast(DepartureHour as DATE) = cast(GETDATE() as DATE) 
AND DATEPART(HOUR, GETDATE()) >= 19 AND ArrivalAirport 
IN (SELECT id FROM Airport WHERE City='Sylhet') 
AND DepartureAirport IN (SELECT id FROM Airport WHERE City='Dhaka')

--> 21. Show the flight arriving Chennai From Dhaka Today after 10 pm.
SELECT * FROM Flight WHERE 
cast(ArrivalHour as DATE) = cast(GETDATE() as DATE) 
AND DATEPART(HOUR, GETDATE()) >= 22 AND DepartureAirport 
IN (SELECT id FROM Airport WHERE City='Dhaka') 
AND ArrivalAirport IN (SELECT id FROM Airport WHERE City = 'Chennai')

--> 22. Show all the Passenger name Details Who are in Business Class in Flight number 1
SELECT PassengerName FROM Ticket WHERE 
SeatClass='Business' AND FlightNumber = 1 

--> 23. Show the ticket price of each Seat Class Where Flight Number = 1
SELECT SeatClass, Price FROM Ticket WHERE FlightNumber = 1 GROUP BY SeatClass, Price 

--> 24. Show the ticket price of each Seat Class That leaves Dhaka and goes to Chennai
SELECT SeatClass, Price FROM Ticket WHERE 
FlightNumber 
IN (SELECT FlightNumber FROM Flight WHERE
DepartureAirport 
IN (SELECT id FROM Airport WHERE City = 'Dhaka') 
AND ArrivalAirport 
IN (SELECT id FROM Airport WHERE City = 'Chennai')) GROUP BY SeatClass, Price

--> 25. Show the passenger details of order number 2
SELECT * FROM Ticket WHERE OrderNumber = 2

--> 26. Show the passenger details under US Bangla Airline
SELECT * FROM Ticket WHERE FlightCompany IN (SELECT SupplierID FROM FlightCompany WHERE FlightCompanyName='US Bangla%')

--> 27. Show the tickets sold under Different Flight Companies
SELECT B.Name, Total from
(SELECT FlightCompany, COUNT(Ordernumber) AS 'Total' FROM Ticket
GROUP BY FlightCompany) A
JOIN
(SELECT SupplierID, FlightCompanyname AS 'Name' FROM FlightCompany
UNION
SELECT SupplierID, BookingCompanyName FROM BookingAgent) B
ON A.FlightCompany=B.SupplierID

--> 28. Find the passengers who booked under booking agent named Eimo
SELECT PassengerName FROM Ticket WHERE
FlightCompany IN (SELECT SupplierID FROM BookingAgent WHERE AgentName='Eimo')

--> 29. Find the agent name of the passenger Name Nabil
SELECT AgentName FROM BookingAgent WHERE SupplierID IN (SELECT FlightCompany FROM Ticket WHERE PassengerName = 'Nabil')

--> 30. Find the passenger who booked under Flight Company
SELECT * FROM Ticket WHERE FlightCompany IN (SELECT SupplierID FROM FlightCompany)

--> 31. Find the passenger who booked under Booking Agent
SELECT * FROM Ticket WHERE FlightCompany IN (SELECT SupplierID FROM BookingAgent)

--> 32. Find the booking company name of an agent named Faisal
SELECT BookingCompanyName FROM BookingAgent WHERE AgentName='Faisal'

--> 33. Find the total number of bookings of booking companies
SELECT B.Name, Total from
(SELECT FlightCompany, COUNT(Ordernumber) AS 'Total' FROM Ticket
GROUP BY FlightCompany) A
JOIN
(SELECT SupplierID, BookingCompanyName AS 'Name' FROM BookingAgent) B
ON A.FlightCompany=B.SupplierID

--> 34. Find the total number of bookings under Flight company
SELECT B.Name, Total from
(SELECT FlightCompany, COUNT(Ordernumber) AS 'Total' FROM Ticket
GROUP BY FlightCompany) A
JOIN
(SELECT SupplierID, FlightCompanyname AS 'Name' FROM FlightCompany) B
ON A.FlightCompany=B.SupplierID

--> 35. Show the Workers who work at Shahjalal Airport
SELECT * FROM Worker WHERE 
AirportId IN 
(SELECT id FROM Airport WHERE AirportName = 'Shahjalal Airport')

--> 36. Show The payments of all the workers in Descending order
SELECT * FROM Worker ORDER BY Payment DESC

--> 37. List out the workers who earn between 15000 and 20000
SELECT * FROM Worker WHERE Payment >= 15000 AND Payment <= 20000

--> 38. List out the top three earning workers
SELECT TOP 3 Name FROM 
Worker ORDER BY Payment DESC

--> 39. Show the second most earning Worker
SELECT TOP 1 Name FROM Worker 
WHERE Payment <> MAX(Payment) 
ORDER BY Payment DESC 

--> 40. Show the third most earning Worker
SELECT TOP 1 Name FROM (SELECT TOP 3 * FROM Worker ORDER BY Payment DESC)B ORDER BY Payment DESC

--> 41. Show the Maximum, Average and Minimum Payment of workers according to Job
SELECT Job, 
Max(Payment) AS 'Max Salary', 
Min(Payment) AS 'Min Salary', 
AVG(Payment) AS 'AVG Salary' 
FROM Worker Group By Job

--> 42. Increase the Payment of the workers who are above 30 years old
UPDATE Worker 
SET Payment = Payment + 10000 
WHERE Age > 30 

--> 43. Increase the Payment of the all the flight Attendent 25%
UPDATE Worker 
SET Payment = (Payment * 1.25) 
WHERE Job = 'Flight Attendent'

--> 44. Show the total worker at each airport
SELECT AirportId, Airport.AirportName, COUNT(WorkerID) AS 'Total Worker' FROM Worker INNER JOIN Airport
ON Worker.AirportId = Airport.id
GROUP BY AirportId, AirportName


--> 45. Show the maximum paid worker in each airport
SELECT AirportId, Airport.AirportName, Name AS 'Worker Name', Max(Payment) AS 'Max Payment' FROM Worker 
INNER JOIN Airport ON
Worker.AirportId = Airport.id
GROUP BY AirportId, Name, AirportName
