import random, os, requests, xml.etree.ElementTree as ET, string,re
from django.contrib.auth import authenticate, login
from django.contrib.auth.hashers import make_password
from django.contrib.gis.geos import Point
from django.db import connection
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.models import User as AuthUser
from main.models import Car, carsDictionary, Location, User, Rental
from faker import Faker

colors = ["Red", "Blue", "Green", "Yellow", "Black", "White"]
status_options = ["Less than 2 years", "2-5 years", "More than 5 years"]
key = 15

current_user = {
    "user_id": None,
    "first_name": "",
    "last_name": "",
    "email": "",
    "phone": "",
    "address": "",
    "password": ""
}

def index(request):
    locations = Location.objects.all()
    cars = Car.objects.all()

    car_data = []
    i = 0
    for car in cars:
        car_location = car.location.location_id

        print(car.location.location_id)
        car_coordinates = None

        for location in locations:

            if location.location_id == car_location:
                i += 1
                car_coordinates = {
                    'longitude': location.geom.x,
                    'latitude': location.geom.y,
                }
                print(car_coordinates["longitude"])
                print(car_coordinates["latitude"])
                break

        # Создаем словарь с данными о машине и ее координатах
        car_data.append({
            'car': car,
            'coordinates': car_coordinates,
        })

    data = {
        'car_data': car_data,
        'current_user': current_user
    }
    print(i)
    return render(request, 'main/main.html', data)
def login(request):
    if request.method == 'POST':
        try:
            email = request.POST['email']
            password = request.POST['password']
            user = User.objects.get(email=email)
            email_valid = validate_email(email)
            if password == encrypt_decrypt_password(user.password, key) and email_valid:
                current_user["user_id"] = user.user_id
                current_user["first_name"] = user.first_name
                current_user["last_name"] = user.last_name
                current_user["email"] = user.email
                current_user["phone"] = user.phone
                current_user["address"] = user.address
                current_user["password"] = password
                if user.is_admin():
                    print("admin")
                    superuser = AuthUser.objects.create_superuser(
                        username=user.email,
                        password=user.password
                    )

                    # Установка роли "admin" для суперпользователя
                    superuser.is_staff = True
                    superuser.is_superuser = True
                    superuser.save()

                return redirect('home')
            elif not email_valid:
                error_message = 'Введите корректный адрес электронной почты'
                data = {
                    'error_message': error_message,
                    'user': user,
                }
                return render(request, 'main/login.html', data)
            else:
                error_message = 'Invalid credentials. Please try again.' + encrypt_decrypt_password(user.password, key)
                data = {
                    'error_message': error_message,
                    'user': user,
                }
                return render(request, 'main/login.html', data)
        except User.DoesNotExist:
            error_message = 'User not found. Try again.'
            data = {
                'error_message': error_message,
                'error_code': 'User.DoesNotExist'
            }
            return render(request, 'main/login.html', data)
    else:
        return render(request, 'main/login.html')
def signup(request):
    if request.method == 'POST':
        locations = Location.objects.all()
        email = request.POST['email']
        password = request.POST['password']
        first_name = request.POST['first_name']
        last_name = request.POST['last_name']
        phone_number = request.POST['phone_number']
        address = request.POST['address']
        user = {
            'email': email,
            'password': password,
            'first_name': first_name,
            'last_name': last_name,
            'phone_number': phone_number,
            'address': address
        }
        # Проверка, существует ли пользователь с заданным email
        try:
            existing_user = User.objects.get(email=email)
            messages.error(request, 'Пользователь с таким email уже существует.')
            return render(request, 'main/signup.html', user)
        except User.DoesNotExist:
            location = Location.objects.filter(address=address).first()
            email_validate = validate_email(email)
            if location and email_validate:
                user = User(email=email, password=encrypt_decrypt_password(password, key), first_name=first_name,
                            last_name=last_name, phone=phone_number, address=address)
                user.save()
                current_user["user_id"] = user.user_id
                current_user["first_name"] = user.first_name
                current_user["last_name"] = user.last_name
                current_user["email"] = user.email
                current_user["phone"] = user.phone
                current_user["address"] = user.address
                current_user["password"] = password
                return redirect('home')
            elif not email_validate:
                messages.error(request, 'Введите корректный адрес электронной почты')
                return render(request, 'main/signup.html', user)
            else:
                # Адрес не существует в модели Location, выполните нужные действия (например, отобразить сообщение об ошибке)
                messages.error(request, 'Введенный адрес не существует.')
                return render(request, 'main/signup.html', user)
    else:
        locations = Location.objects.all()
        return render(request, 'main/signup.html', {'locations': locations})
def account(request):
    user_id = current_user["user_id"]
    rental_count = 0

    rentals = Rental.objects.filter(user=current_user["user_id"])
    data = {
        'current_user': current_user,
        'rentals': rentals,
        'rental_count': rental_count
    }
    return render(request, 'main/account.html', data)
def logout(request):
    current_user["user_id"] = None
    current_user["first_name"] = ""
    current_user["last_name"] = ""
    current_user["email"] = ""
    current_user["phone"] = ""
    current_user["address"] = ""
    current_user["password"] = ""
    return redirect('home')
def car_rent(request):
    car_id = request.POST['car_id']
    car = Car.objects.get(car_id=car_id)
    data = {
        'car': car,
        'current_user': current_user
    }
    return render(request, 'main/order.html', data)
def addRent(request):
    if request.method == 'POST':
        car_id = request.POST.get('car_id')
        user_id = request.POST.get('user_id')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')
        total_cost = request.POST.get('total_cost')

        rental = Rental(car_id=car_id, user_id=user_id, start_date=start_date, end_date=end_date, total_cost=total_cost)
        rental.save()


        return redirect('home')
def validate_email(email):
    # Regular expression pattern to validate email
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email) is not None
def parse_coordinates(geom_char):
    if geom_char:
        point_str = geom_char.split('(')[1].split(')')[0]  # Извлекаем часть строки с координатами

        # Проверяем, что строка содержит координаты
        if len(point_str) > 0:
            coordinates = point_str.split(' ')
            if len(coordinates) == 2:
                location_latitude = float(coordinates[0])
                location_longitude = float(coordinates[1])

                return {
                    'longitude': location_longitude,
                    'latitude': location_latitude,
                }
            else:
                return None
        else:
            return None
    else:
        return None
def location_list(request):
    query = """
    SELECT location_id, address, geom.STAsText() AS geom_char
    FROM locations;
    """
    with connection.cursor() as cursor:
        cursor.execute(query)
        locations = []
        for row in cursor.fetchall():
            location_id = row[0]
            address = row[1]
            geom_char = row[2]

            coordinates = parse_coordinates(geom_char)
            if coordinates:
                location_longitude = coordinates['longitude']
                location_latitude = coordinates['latitude']
                locations.append({
                    'location_id': location_id,
                    'address': address,
                    'longitude': location_longitude,
                    'latitude': location_latitude,
                })
            else:
                print(f"Invalid coordinate format for location ID {location_id}")

    # Вернуть список словарей с информацией о местоположениях
    return locations
def addNewCars():
    for _ in range(400):
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
                lat, lon = float(coordinates[0]), float(coordinates[1])
                if isinstance(lat, (int, float)) and isinstance(lon, (int, float)):
                    geo = Point(lon, lat, srid=4326)
                    print(f"Coordinates for {street_name}: {geo}")
                    location = Location(address=street_name, geom=geo)
                    location.save()
                else:
                    print(f"Invalid coordinates for {street_name}: {coordinates}")
            else:
                coordinates = get_coordinates_by_street(name)
                if coordinates is not None:
                    streets.append(name)
                    lat, lon = float(coordinates[0]), float(coordinates[1])
                    if isinstance(lat, (int, float)) and isinstance(lon, (int, float)):
                        geo = Point(lon, lat, srid=4326)
                        print(f"Coordinates for {name}: {geo}")
                        location = Location(address=name, geom=geo)
                        location.save()
                    else:
                        print(f"Invalid coordinates for {name}: {coordinates}")
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
        lat = first_result.get('lat')
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

        # Генерация случайного пароля
        password = fake.password()
        print('Просто пароль:', password, 'Email:', email)
        # Шифрование пароля
        encrypted_password = encrypt_decrypt_password(password, key)

        # Расшифровка пароля
        decrypted_password = encrypt_decrypt_password(encrypted_password, key)

        # Создание нового пользователя с заданными данными и шифрованным паролем
        user = User.objects.create(
            first_name=first_name,
            last_name=last_name,
            email=email,
            phone=phone_number,
            address=random_address,
            password=encrypted_password
        )
def encrypt_decrypt_password(password, key):
    encrypted_password = ''
    for char in password:
        # Применить операцию XOR для каждого символа пароля с ключом
        encrypted_char = chr(ord(char) ^ key)
        encrypted_password += encrypted_char
    return encrypted_password