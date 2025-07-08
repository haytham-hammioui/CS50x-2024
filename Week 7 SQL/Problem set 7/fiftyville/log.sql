-- Keep a log of any SQL queries you execute as you solve the mystery.
select * from crime_scene_reports where street = 'Humphrey Street' and year = 2024 and month = 7 and day = 28; -- Step 1: Look for crime scene reports on Humphrey Street on July 28, 2024
/*
+-----+------+-------+-----+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id  | year | month | day |     street      |                                                                                                       description                                                                                                        |
+-----+------+-------+-----+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 295 | 2024 | 7     | 28  | Humphrey Street | Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery. |
| 297 | 2024 | 7     | 28  | Humphrey Street | Littering took place at 16:36. No known witnesses.                                                                                                                                                                       |
+-----+------+-------+-----+-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/
--Found a report of the theft of the CS50 duck at the Humphrey Street bakery on July 28, 2024.

select * from interviews where year = 2024 and month = 7 and day = 28;-- Step 2: Retrieve all interviews conducted on July 28, 2024
/*
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id  |  name   | year | month | day |                                                                                                                                                     transcript                                                                                                                                                      |
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 158 | Jose    | 2024 | 7     | 28  | “Ah,” said he, “I forgot that I had not seen you for some weeks. It is a little souvenir from the King of Bohemia in return for my assistance in the case of the Irene Adler papers.”                                                                                                                               |
| 159 | Eugene  | 2024 | 7     | 28  | “I suppose,” said Holmes, “that when Mr. Windibank came back from France he was very annoyed at your having gone to the ball.”                                                                                                                                                                                      |
| 160 | Barbara | 2024 | 7     | 28  | “You had my note?” he asked with a deep harsh voice and a strongly marked German accent. “I told you that I would call.” He looked from one to the other of us, as if uncertain which to address.                                                                                                                   |
| 161 | Ruth    | 2024 | 7     | 28  | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| 162 | Eugene  | 2024 | 7     | 28  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| 163 | Raymond | 2024 | 7     | 28  | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
| 191 | Lily    | 2024 | 7     | 28  | Our neighboring courthouse has a very annoying rooster that crows loudly at 6am every day. My sons Robert and Patrick took the rooster to a city far, far away, so it may never bother us again. My sons have successfully arrived in Paris.                                                                        |
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/
--Reviewed witness statements for information about the theft and potential suspects.

select * from bakery_security_logs where year = 2024 and month = 7 and day = 28 and hour = 10 AND minute BETWEEN 15 AND 25 AND activity = 'exit';-- Step 3: Check bakery security logs around the time of the theft (between 10:15 and 10:25 AM)
/*
+-----+------+-------+-----+------+--------+----------+---------------+
| id  | year | month | day | hour | minute | activity | license_plate |
+-----+------+-------+-----+------+--------+----------+---------------+
| 260 | 2024 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
| 261 | 2024 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 262 | 2024 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
| 263 | 2024 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 264 | 2024 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 265 | 2024 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
| 266 | 2024 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 267 | 2024 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
+-----+------+-------+-----+------+--------+----------+---------------+
*/
--Identified vehicles that exited the bakery parking lot shortly after the theft to narrow down suspects.
select name, license_plate, phone_number, passport_number from people where license_plate in ('5P2BI95', '94KL13X', '6P58WS2', '4328GD8', 'G412CB7', 'L93JTIZ', '322W7JE', '0NTHK55');-- Step 4: Find the people associated with the license plates of those vehicles
/*
+---------+---------------+----------------+-----------------+
|  name   | license_plate |  phone_number  | passport_number |
+---------+---------------+----------------+-----------------+
| Vanessa | 5P2BI95       | (725) 555-4692 | 2963008352      |
| Barry   | 6P58WS2       | (301) 555-4174 | 7526138472      |
| Iman    | L93JTIZ       | (829) 555-5269 | 7049073643      |
| Sofia   | G412CB7       | (130) 555-0289 | 1695452385      |
| Luca    | 4328GD8       | (389) 555-5198 | 8496433585      |
| Diana   | 322W7JE       | (770) 555-1861 | 3592750733      |
| Kelsey  | 0NTHK55       | (499) 555-9472 | 8294398571      |
| Bruce   | 94KL13X       | (367) 555-5533 | 5773159633      |
+---------+---------------+----------------+-----------------+
*/
--Matched vehicles to their owners to get a list of suspects.
select * from atm_transactions where year = 2024 AND month = 7 AND day = 28 and atm_location = 'Leggett Street' and transaction_type = 'withdraw';-- Step 5: Look for ATM withdrawal transactions on Leggett Street on July 28, 2024
/*
+-----+----------------+------+-------+-----+----------------+------------------+--------+
| id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
+-----+----------------+------+-------+-----+----------------+------------------+--------+
| 246 | 28500762       | 2024 | 7     | 28  | Leggett Street | withdraw         | 48     |
| 264 | 28296815       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
| 266 | 76054385       | 2024 | 7     | 28  | Leggett Street | withdraw         | 60     |
| 267 | 49610011       | 2024 | 7     | 28  | Leggett Street | withdraw         | 50     |
| 269 | 16153065       | 2024 | 7     | 28  | Leggett Street | withdraw         | 80     |
| 288 | 25506511       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
| 313 | 81061156       | 2024 | 7     | 28  | Leggett Street | withdraw         | 30     |
| 336 | 26013199       | 2024 | 7     | 28  | Leggett Street | withdraw         | 35     |
+-----+----------------+------+-------+-----+----------------+------------------+--------+
*/
--Identified people who withdrew money near the crime scene on the day of the theft.
SELECT account_number, person_id FROM bank_accounts WHERE account_number IN (28500762, 28296815, 76054385, 49610011, 16153065, 25506511, 81061156, 26013199);-- Step 6: Link the ATM account numbers to person IDs
/*
+----------------+-----------+
| account_number | person_id |
+----------------+-----------+
| 49610011       | 686048    |
| 26013199       | 514354    |
| 16153065       | 458378    |
| 28296815       | 395717    |
| 25506511       | 396669    |
| 28500762       | 467400    |
| 76054385       | 449774    |
| 81061156       | 438727    |
+----------------+-----------+
*/
--Matched accounts used for withdrawals to the people who own them.
SELECT id, name, license_plate, phone_number, passport_number FROM people WHERE id IN (686048, 514354, 458378, 395717, 396669, 467400, 449774, 438727);-- Step 7: Get details of people linked to the accounts who made withdrawals
/*
+--------+---------+---------------+----------------+-----------------+
|   id   |  name   | license_plate |  phone_number  | passport_number |
+--------+---------+---------------+----------------+-----------------+
| 395717 | Kenny   | 30G67EN       | (826) 555-1652 | 9878712108      |
| 396669 | Iman    | L93JTIZ       | (829) 555-5269 | 7049073643      |
| 438727 | Benista | 8X428L0       | (338) 555-6650 | 9586786673      |
| 449774 | Taylor  | 1106N58       | (286) 555-6063 | 1988161715      |
| 458378 | Brooke  | QX4YZN3       | (122) 555-4581 | 4408372428      |
| 467400 | Luca    | 4328GD8       | (389) 555-5198 | 8496433585      |
| 514354 | Diana   | 322W7JE       | (770) 555-1861 | 3592750733      |
| 686048 | Bruce   | 94KL13X       | (367) 555-5533 | 5773159633      |
+--------+---------+---------------+----------------+-----------------+
*/
--Obtained detailed information about suspects who withdrew money that morning.

SELECT * FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60 AND caller IN ('(829) 555-5269','(389) 555-5198','(770) 555-1861','(367) 555-5533');-- Step 8: Find phone calls shorter than one minute made by suspects on July 28, 2024
/*
+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 233 | (367) 555-5533 | (375) 555-8161 | 2024 | 7     | 28  | 45       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2024 | 7     | 28  | 49       |
+-----+----------------+----------------+------+-------+-----+----------+
*/
--Identified suspects who made short phone calls, matching witness testimony about the thief calling an accomplice to buy a flight ticket.
SELECT flights.id, hour, minute, destination_airport_id, city FROM flights JOIN airports ON flights.origin_airport_id = airports.id WHERE airports.city = 'Fiftyville' AND year = 2024 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1;-- Step 9: Find the earliest flight departing from Fiftyville on July 29, 2024
/*
+----+------+--------+------------------------+------------+
| id | hour | minute | destination_airport_id |    city    |
+----+------+--------+------------------------+------------+
| 36 | 8    | 20     | 4                      | Fiftyville |
+----+------+--------+------------------------+------------+
*/
--Determined the first flight out of town the day after the theft.
SELECT city, full_name FROM airports WHERE id = 4;-- Step 10: Find the city and airport name for the flight’s destination airport
/*
+---------------+-------------------+
|     city      |     full_name     |
+---------------+-------------------+
| New York City | LaGuardia Airport |
+---------------+-------------------+
*/
--Confirmed that the flight’s destination was New York City, LaGuardia Airport.
SELECT people.name, people.passport_number FROM passengers JOIN people ON passengers.passport_number = people.passport_number WHERE passengers.flight_id = 36;-- Step 11: List passengers on flight 36 to identify who fled town
/*+--------+-----------------+
|  name  | passport_number |
+--------+-----------------+
| Doris  | 7214083635      |
| Sofia  | 1695452385      |
| Bruce  | 5773159633      |
| Edward | 1540955065      |
| Kelsey | 8294398571      |
| Taylor | 1988161715      |
| Kenny  | 9878712108      |
| Luca   | 8496433585      |
+--------+-----------------+
*/
--Checked the passenger list on the earliest flight to identify the thief and possible accomplice.
