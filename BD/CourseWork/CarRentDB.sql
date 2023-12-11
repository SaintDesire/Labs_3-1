USE CarRentDB;

-- Создание таблицы locations как узла графа
CREATE TABLE locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    address VARCHAR(100),
    geom geography
) AS NODE;

-- Создание таблицы cars как узла графа
CREATE TABLE cars (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(50),
    color VARCHAR(20),
    year INT,
    status VARCHAR(20),
	number VARCHAR(20),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
) AS NODE;

-- Создание таблицы users как узла графа
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(100),
    password VARCHAR(128),
	role VARCHAR(50) DEFAULT 'user'
) AS NODE;

-- Создание таблицы rentals как грани графа
CREATE TABLE rentals (
    rental_id INT IDENTITY(1,1) PRIMARY KEY,
    car_id INT,
    user_id INT, 
    start_date DATE,
    end_date DATE,
    total_cost DECIMAL(10, 2),
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) AS NODE;


-- Создание индексов для улучшения производительности
CREATE CLUSTERED INDEX car_cluster_idx ON cars (car_id);
CREATE CLUSTERED INDEX rental_cluster_idx ON rentals (car_id);
CREATE CLUSTERED INDEX location_cluster_idx ON locations (location_id);

CREATE INDEX car_brand_idx ON cars (brand) INCLUDE (model, color);
CREATE INDEX rental_car_idx ON rentals (car_id);
CREATE INDEX location_lat_lon_idx ON locations (latitude, longitude);