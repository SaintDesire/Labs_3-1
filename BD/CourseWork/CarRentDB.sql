use CarRentDB;

CREATE TABLE cars (
car_id INT PRIMARY KEY,
brand VARCHAR(50),
model VARCHAR(50),
color VARCHAR(20),
year INT,
status VARCHAR(20),
location_id INT,
FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE users (
user_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
phone VARCHAR(20),
address VARCHAR(100)
);

CREATE TABLE rentals (
rental_id INT PRIMARY KEY,
car_id INT,
user_id INT,
start_date DATE,
end_date DATE,
total_cost DECIMAL(10, 2),
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE locations (
location_id INT PRIMARY KEY,
address VARCHAR(100),
latitude DECIMAL(9, 6),
longitude DECIMAL(9, 6)
);

CREATE TABLE graphs (
graph_id INT PRIMARY KEY,
graph_name VARCHAR(50),
graph_data NVARCHAR(MAX)
);

CREATE CLUSTERED INDEX car_cluster_idx ON cars (car_id);

CREATE CLUSTERED INDEX rental_cluster_idx ON rentals (car_id);

CREATE CLUSTERED INDEX location_cluster_idx ON locations (latitude, longitude);

CREATE INDEX car_brand_idx ON cars (brand) INCLUDE (model, color) ON car_cluster;

CREATE INDEX rental_car_idx ON rentals (car_id) ON rental_cluster;

CREATE INDEX location_lat_lon_idx ON locations (latitude, longitude) ON location_cluster;