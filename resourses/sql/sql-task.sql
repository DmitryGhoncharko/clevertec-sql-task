-- Вывести к каждому самолету класс обслуживания и количество мест этого класса
SELECT model ->>'ru' AS ru_model, count(*), fare_conditions
FROM aircrafts_data AS ad
    JOIN seats AS s
ON ad.aircraft_code = s.aircraft_code
GROUP BY model, fare_conditions;

-- Найти 3 самых вместительных самолета (модель + кол-во мест)
SELECT model ->>'ru' AS ru_model, count(*) AS count_seats
FROM aircrafts_data AS ad
    JOIN seats AS s
ON ad.aircraft_code = s.aircraft_code
GROUP BY model
ORDER BY number_of_seats DESC
    LIMIT 3;

-- Вывести код,модель самолета и места не эконом класса для самолета 'Аэробус A321-200' с сортировкой по местам
SELECT ad.aircraft_code, model ->>'ru' AS ru_model, no_seats
FROM aircrafts_data AS ad
    JOIN seats AS s
ON ad.aircraft_code = s.aircraft_code
WHERE model->>'ru' LIKE '%Аэробус A321-200%'
  AND fare_conditions NOT LIKE '%Economy%'
ORDER BY seat_no;

-- Вывести города в которых больше 1 аэропорта ( код аэропорта, аэропорт, город)
SELECT city, count(*)
FROM airports_data
GROUP BY city
HAVING count(*) > 1;

-- Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация
SELECT *
FROM flights_v
WHERE departure_city LIKE '%Екатеринбург%'
  AND arrival_city LIKE '%Москва%'
  AND status LIKE '%Scheduled%'
ORDER BY scheduled_departure_local
    LIMIT 1;

-- Вывести самый дешевый и дорогой билет и стоимость ( в одном результирующем ответе)
SELECT *
FROM ticket_flights
ORDER BY amount
    LIMIT 1;
UNION
SELECT *
FROM ticket_flights
ORDER BY amount DESC
    LIMIT 1;

-- Написать DDL таблицы Customers , должны быть поля id , firstName, lastName, email , phone Добавить ограничения на поля ( constraints).
CREATE TABLE IF NOT EXISTS Customers (
                                         id bigserial PRIMARY KEY,
                                         firstName text NOT NULL,
                                         lastName text NOT NULL,
                                         email varchar(200) NOT NULL UNIQUE check ( email LIKE '%@%'),
    phone varchar(100) NOT NULL UNIQUE check ( phone LIKE '+%')
    );

-- Написать DDL таблицы Orders , должен быть id, customerId, quantity. Должен быть внешний ключ на таблицу customers + ограничения
CREATE TABLE IF NOT EXISTS Orders (
                                      id bigserial PRIMARY KEY,
                                      customerId int NOT NULL,
                                      quantity numeric(10,2) NOT NULL,
    FOREIGN KEY (customerId) references bookings.customers(id)
    );

-- Написать 5 insert в эти таблицы
INSERT INTO Customers
VALUES (1, 'Victor', 'Victorov', 'victor@gmail.com', '+37529111111'),
       (2, 'Sergey', 'Sergeew', 'sergey@gmail.com', '+375291231121'),
       (3, 'Ivan', 'Ivanow', 'ivan@gmail.com', '+375291312121'),
       (4, 'Mark', 'Markow', 'mark@gmail.com', '+3752912312321'),
       (5, 'Oleg', 'Olegow', 'oleg@gmail.com', '+3752912131211');

INSERT INTO Orders
VALUES (1, 1, 44),
       (2, 2, 21),
       (3, 3, 11),
       (4, 4, 43),
       (5, 5, 56);

-- удалить таблицы
DROP TABLE Orders, Customers;

-- Написать свой кастомный запрос ( rus + sql)  Компании нужно узнать общую сумму выручки за продажу билетов пассажирам, самолёты которых были отправлены с Москвы между 2017-07-16 08:00:00.000000 и 2017-07-16 14:00:00.000000 класс обслуживания должен быть 'Business','Comfort'
SELECT sum(amount) AS amount
FROM flights_v AS fv
         JOIN ticket_flights tf
              ON fv.flight_id = tf.flight_id
WHERE departure_city LIKE '%Москва%'
  AND scheduled_departure_local BETWEEN '2017-07-16 08:00:00.000000' AND '2017-07-16 14:00:00.000000'
  AND status LIKE '%Arrived%'
  AND fare_conditions IN ('Business','Comfort');