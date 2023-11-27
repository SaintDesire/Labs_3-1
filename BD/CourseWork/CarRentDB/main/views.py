import random, os, requests, xml.etree.ElementTree as ET, string
from django.db import connection
from django.shortcuts import render
from main.models import Car, carsDictionary, Location, User
from faker import Faker

colors = ["Red", "Blue", "Green", "Yellow", "Black", "White"]
status_options = ["Less than 2 years", "2-5 years", "More than 5 years"]

def index(request):
    cars = Car.objects.all()
    fake = Faker()

    fillUsersTable(100000)

    data = {
        'cars' : cars,
    }
    return render(request, 'main/main.html', data)

def addNewCars():
    for _ in range(200):
        brand = random.choice(list(carsDictionary.keys()))
        model = random.choice(list(carsDictionary[brand]["models"].keys()))
        color = random.choice(colors)
        year = carsDictionary[brand]["models"][model]["year"]
        status = random.choice(status_options)
        letters = ''.join(random.choices(string.ascii_uppercase, k=3))
        numbers = ''.join(random.choices(string.digits, k=3))
        number = letters + numbers
        location_id = random.randint(1, 1213)

        car = Car.objects.create(
            brand=brand,
            model=model,
            color=color,
            year=year,
            status=status,
            number=number,
            location_id=location_id
        )

        car.save()
    return

def addNewLocations():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'streets.xml')
    print(file_path)
    tree = ET.parse(file_path)
    root = tree.getroot()

    streets = []

    for street in root.findall('street'):
        name = street.find('name').text
        street_type = street.find('type').text

        if street_type is not None:
            street_name = street_type + ' ' + name
            coordinates = get_coordinates_by_street(street_name)
            if coordinates is not None:
                streets.append(street_name)
                lat, lon = coordinates
                geo = f'POINT({lat} {lon})'
                print(f"Coordinates for {street_name}: {geo}")
                with connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO locations (address, geom) VALUES (%s, geography::STPointFromText(%s, 4326))",
                        [street_name, geo])
            else:
                coordinates = get_coordinates_by_street(name)
                if coordinates is not None:
                    streets.append(name)
                    lat, lon = coordinates
                    geo = f'POINT({lat} {lon})'
                    print(f"Coordinates for {name}: {geo}")
                    with connection.cursor() as cursor:
                        cursor.execute(
                            "INSERT INTO locations (address, geom) VALUES (%s, geography::STPointFromText(%s, 4326))",
                            [name, geo])
    print(streets)

    return


def get_coordinates_by_street(street_name):
    url = 'https://nominatim.openstreetmap.org/search'
    params = {
        'street': street_name,
        'format': 'json',
        'city': 'Minsk',
    }

    response = requests.get(url, params=params)
    data = response.json()

    if data:
        first_result = data[0]
        lat = first_result.get('lat')  # Use .get() method to handle missing keys
        lon = first_result.get('lon')

        if lat and lon:
            return (lat, lon)
        else:
            return None
    else:
        return None


def fillUsersTable(num_rows):
    fake = Faker()
    locations = Location.objects.values_list('address', flat=True)  # Получаем все адреса из таблицы locations
    locations_list = list(locations)  # Преобразуем полученные адреса в список
    num_locations = len(locations_list)

    for _ in range(num_rows):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = fake.email()
        prefix = "+375"
        area_code = random.choice(["29", "25", "44"])
        phone_number = prefix + area_code + ''.join(random.choices(string.digits, k=7))

        # Получаем случайный адрес из списка locations_list
        random_address = random.choice(locations_list)

        # Создание нового пользователя с заданными данными
        user = User.objects.create(
            first_name=first_name,
            last_name=last_name,
            email=email,
            phone=phone_number,
            address=random_address
        )