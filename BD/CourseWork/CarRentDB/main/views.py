import codecs
import io
import random, os, requests, xml.etree.ElementTree as ET, string,re
from datetime import date, timedelta, datetime
from decimal import Decimal
from urllib import response, request

from django.contrib.gis.geos import Point
from django.core.serializers import serialize
from django.db import connection
from django.db.models import Min, Max
from django.http import HttpResponse, FileResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.utils.encoding import smart_str
from reportlab.pdfgen import canvas

from main.models import Car, carsDictionary, Location, User, Rental, Node, Edge
from faker import Faker
from django.contrib.auth.models import User as Admin

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

current_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'data.xml')

def index(request):
    locations = Location.objects.all()
    cars = Car.objects.all()
    car_data = []
    user_coordinates = {}

    for location in locations:
        if current_user['address'] is not None and location.address is not None:
            if str(location.address) == str(current_user['address']):
                user_coordinates = {
                    'longitude': location.geom.x,
                    'latitude': location.geom.y,
                }
                break

    for car in cars:
        if car.is_free:
            car_location = car.location.location_id

            car_coordinates = None
            for location in locations:


                if location.location_id == car_location:
                    car_coordinates = {
                        'longitude': location.geom.x,
                        'latitude': location.geom.y,
                    }
                    break

            # Создаем словарь с данными о машине и ее координатах
            car_data.append({
                'car': car,
                'coordinates': car_coordinates,
            })

    data = {
        'car_data': car_data,
        'current_user': current_user,
        'user_coordinates': user_coordinates
    }

    return render(request, 'main/main.html', data)
def login(request):
    if request.method == 'POST':
        try:
            email = request.POST['email']
            password = request.POST['password']
            user = User.objects.get(email=email)
            email_valid = validate_email(email)
            if user.is_banned:
                error_message = 'Your account has been banned. Ban untill ' + str(user.ban_end_date)
                data = {
                    'error_message': error_message,
                    'user': user,
                }
                return render(request, 'main/login.html', data)
            if user.is_active is False:
                error_message = 'Your account has been deleted'
                data = {
                    'error_message': error_message,
                    'user': user,
                }
                return render(request, 'main/login.html', data)
            if password == encrypt_decrypt_password(user.password, key) and email_valid:
                current_user["user_id"] = user.user_id
                current_user["first_name"] = user.first_name
                current_user["last_name"] = user.last_name
                current_user["email"] = user.email
                current_user["phone"] = user.phone
                current_user["address"] = user.address
                current_user["password"] = password
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
        address_id = request.POST['address']
        user = {
            'email': email,
            'password': password,
            'first_name': first_name,
            'last_name': last_name,
            'phone_number': phone_number,
            'address_id': address_id,
            'locations': locations
        }
        try:
            existing_user = User.objects.get(email=email)
            messages.error(request, 'Пользователь с таким email уже существует.')
            return render(request, 'main/signup.html', user)
        except User.DoesNotExist:
            location = get_object_or_404(Location, address=address_id)
            email_validate = validate_email(email)
            if location and email_validate:
                user = User(email=email, password=encrypt_decrypt_password(password, key), first_name=first_name,
                            last_name=last_name, phone=phone_number, address=location)
                user.save()
                current_user["user_id"] = user.user_id
                current_user["first_name"] = user.first_name
                current_user["last_name"] = user.last_name
                current_user["email"] = user.email
                current_user["phone"] = user.phone
                current_user["address"] = user.address
                current_user["password"] = password


                node_data = {
                    "user": f"{user.user_id}",
                }
                node = Node(data=node_data)
                node.save()
                return redirect('home')
            elif not email_validate:
                messages.error(request, 'Введите корректный адрес электронной почты')
                return render(request, 'main/signup.html', user)
            else:
                messages.error(request, 'Введенный адрес не существует.')
                return render(request, 'main/signup.html', user)
    else:
        locations = Location.objects.all()
        return render(request, 'main/signup.html', {'locations': locations})
def account(request):
    user_id = current_user["user_id"]
    locations = Location.objects.all()
    rental_count = 0

    rentals = Rental.objects.filter(user=user_id)
    user = User.objects.get(user_id=user_id)
    data = {
        'current_user': current_user,
        'rentals': rentals,
        'rental_count': rental_count,
        'locations': locations,
        'user' : user
    }
    return render(request, 'main/account.html', data)
def update_account(request):
    data = {}
    locations = Location.objects.all()
    if request.method == 'POST':
        error_message = ''

        try:
            first_name = request.POST['first_name']
            last_name = request.POST['last_name']
            email = request.POST['email']
            phone_number = request.POST['phone_number']
            address_id = request.POST['address']
            location = get_object_or_404(Location, address=address_id)
            user = {
                'email': email,
                'first_name': first_name,
                'last_name': last_name,
                'phone_number': phone_number,
                'address_id': address_id,
            }
            try:
                data['old_password'] = request.POST['oldPassword']
                data['new_password'] = request.POST['newPassword']
            except KeyError:
                data['old_password'] = None
                data['new_password'] = None

            user_obj = User.objects.get(email=user['email'])

            if user['first_name'] != user_obj.first_name:
                user_obj.first_name = user['first_name']
            if user['last_name'] != user_obj.last_name:
                user_obj.last_name = user['last_name']
            if user['phone_number'] != user_obj.phone:
                user_obj.phone = user['phone_number']
            if user['address_id'] != user_obj.address:
                user_obj.address = location
            if data['old_password'] is not '' and data['new_password'] is not '':
                try:
                    enc_password = encrypt_decrypt_password(data['old_password'], 15)
                    if enc_password == user_obj.password:
                        user_obj.password = encrypt_decrypt_password(data['new_password'], 15)
                        error_message = 'Данные обновлены.'
                    else:
                        error_message = 'Старый пароль введен неправильно.'
                except Exception:
                    error_message = 'Ошибка при шифровании пароля.'
            user_obj.save()
            current_user["user_id"] = current_user["user_id"]
            current_user["first_name"] = user_obj.first_name
            current_user["last_name"] = user_obj.last_name
            current_user["email"] = user_obj.email
            current_user["phone"] = user_obj.phone
            current_user["address"] = user_obj.address
            current_user["password"] = user_obj.password
        except KeyError as e:
            if 'email' in str(e):
                error_message = 'Ошибка: отсутствует поле "email" в запросе.'
            elif 'first_name' in str(e):
                error_message = 'Ошибка: отсутствует поле "first_name" в запросе.'
            elif 'last_name' in str(e):
                error_message = 'Ошибка: отсутствует поле "last_name" в запросе.'
            elif 'phone_number' in str(e):
                error_message = 'Ошибка: отсутствует поле "phone_number" в запросе.'
            elif 'address' in str(e):
                error_message = 'Ошибка: отсутствует поле "address" в запросе.'
            else:
                error_message = 'Ошибка: отсутствует поле в запросе.'
        except User.DoesNotExist:
            error_message = 'Ошибка: пользователь не найден.'

        data = {
            'current_user': current_user,
            'locations': locations,
            'error_message': error_message
        }

    return render(request, 'main/account.html', data)
def admin_login(request):
    user = User.objects.get(email=current_user['email'])
    email = user.email
    username = email[:email.find('@')]
    print(username)
    password = encrypt_decrypt_password(user.password, 15)

    try:
        Admin.objects.get(username=username)
    except Admin.DoesNotExist:
        admin = Admin.objects.create_user(username, '', password)
        admin.first_name = user.first_name
        admin.last_name = user.last_name
        admin.is_active = True  # Активировать учетную запись
        admin.is_admin = True
        admin.is_staff = True
        admin.is_superuser = True  # Установить статус суперпользователя
        admin.save()
        return redirect('/admin/')
    else:
        return redirect('/admin/')
def logout(request):
    current_user["user_id"] = None
    current_user["first_name"] = ""
    current_user["last_name"] = ""
    current_user["email"] = ""
    current_user["phone"] = ""
    current_user["address"] = ""
    current_user["password"] = ""
    return redirect('home')
def delete_account(request):
    user = User.objects.get(user_id=current_user["user_id"])
    user.is_active = False
    user.save()

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
    today = date.today()
    tomorrow = today + timedelta(days=1)
    max_day = today + timedelta(days=3650)
    print(car.price)
    data = {
        'car': car,
        'current_user': current_user,
        'today': today.strftime('%Y-%m-%d'),
        'tomorrow': tomorrow.strftime('%Y-%m-%d'),
        'max_day': max_day.strftime('%Y-%m-%d')
    }
    return render(request, 'main/order.html', data)
def addRent(request):
    if request.method == 'POST':
        car_id = request.POST.get('car_id')
        user_id = request.POST.get('user_id')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')
        total_cost = request.POST.get('total_cost')

        car = Car.objects.get(car_id=car_id)
        car.is_free = False
        car.save()
        rental = Rental(car_id=car_id, user_id=user_id, start_date=start_date, end_date=end_date, total_cost=total_cost)
        rental.save()

        model = f"{car.brand} {car.model}"  # Объединение значений brand и model в одну строку

        car_node_data = {
            "car": car_id,
            "user_id": user_id,
            "income": total_cost,
            "model": model
        }
        car_node = Node(data=car_node_data)
        car_node.save()

        user_node = Node.objects.filter(data__has_key='user', data__user=str(user_id)).first()

        if user_node is None:
            # Если узел не найден, обработать соответствующую логику
            print("Узел с информацией о пользователе не найден")
        else:
            print(user_node.data['user'])
        edge = Edge(previous_node=user_node, next_node=car_node)
        edge.save()

        return redirect('home')
    else:
        # Обрабатываем случай, когда метод запроса не является POST
        return HttpResponse(status=405)
def generate_payment_receipt(request):
    rental_id = request.POST['rental_id']
    car_model = request.POST['car_model']
    car_year = request.POST['car_year']
    car_number = request.POST['car_number']
    start_date = request.POST['start_date']
    end_date = request.POST['end_date']
    total_cost = request.POST['total_cost']
    rental = Rental.objects.get(rental_id=rental_id)
    user = User.objects.get(user_id=rental.user_id)

    buffer = io.BytesIO()
    p = canvas.Canvas(buffer)

    # Устанавливаем шрифт "Helvetica"
    p.setFont("Helvetica", 12)

    # Настраиваем размеры текста
    line_height = 14
    margin = 50

    # Получаем текущую дату и время и форматируем его в "день.месяц.год часы:минуты"
    current_datetime = datetime.now().strftime("%d.%m.%Y %H:%M")

    # Генерируем содержимое квитанции
    p.drawString(margin, 800 - line_height * 2, smart_str(f"Order ID: {rental_id}"))
    p.drawString(margin, 800 - line_height * 3, smart_str(f"User name: {user.first_name} {user.last_name}"))
    p.drawString(margin, 800 - line_height * 4, smart_str(f"Start date: {rental.start_date}"))
    p.drawString(margin, 800 - line_height * 5, smart_str(f"End date: {rental.end_date}"))
    p.drawString(margin, 800 - line_height * 6, smart_str(f"Total cost: {total_cost}"))
    p.drawString(margin, 800 - line_height * 7, smart_str(f"Current date and time: {current_datetime}"))

    # Завершаем генерацию PDF
    p.showPage()
    p.save()

    buffer.seek(0)
    response = HttpResponse(buffer, content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="receipt.pdf"'

    return response
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
def addNewCars(num_rows):
    for _ in range(num_rows):
        brand = random.choice(list(carsDictionary.keys()))
        model = random.choice(list(carsDictionary[brand]["models"].keys()))
        color = random.choice(colors)
        year = carsDictionary[brand]["models"][model]["year"]
        status = random.choice(status_options)
        letters = ''.join(random.choices(string.ascii_uppercase, k=3))
        numbers = ''.join(random.choices(string.digits, k=3))
        number = letters + numbers
        max_location_id = Location.objects.aggregate(max_location_id=Max('location_id'))['max_location_id']
        min_location_id = Location.objects.aggregate(min_location_id=Min('location_id'))['min_location_id']
        location_id = random.randint(min_location_id, max_location_id)

        car = Car.objects.create(
            brand=brand,
            model=model,
            color=color,
            year=year,
            status=status,
            number=number,
            location_id=location_id,
            price=carsDictionary[brand]["models"][model]["price"]
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

    # Создаем новый элемент для записи данных
    data_element = ET.Element('data')

    # Проходим по списку streets и создаем элементы street
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
                    # Создаем элемент street и добавляем его в элемент data
                    street_element = ET.Element('street')
                    street_element.text = street_name
                    street_element.set('lat', str(lat))
                    street_element.set('lon', str(lon))
                    data_element.append(street_element)

                    print(f'Adding {street_name}')
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
                        # Создаем элемент street и добавляем его в элемент data
                        street_element = ET.Element('street')
                        street_element.text = name
                        street_element.set('lat', str(lat))
                        street_element.set('lon', str(lon))
                        data_element.append(street_element)

                        print(f'Adding {name}')
                    else:
                        print(f"Invalid coordinates for {name}: {coordinates}")

    # Создаем новое дерево XML и записываем в него данные
    xml_tree = ET.ElementTree(data_element)

    xml_file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'streetsWithCoordinates.xml')

    # Записываем данные в XML файл
    xml_tree.write(xml_file_path, encoding='utf-8', method='xml')
    print(streets)
    return
def import_streets_from_xml():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'streetsWithCoordinates.xml')
    tree = ET.parse(file_path)
    root = tree.getroot()

    for street in root.findall('street'):
        lat = street.get('lat')
        lon = street.get('lon')
        address = street.text

        location = Location(address=address)
        location.geom = f'POINT({lon} {lat})'
        location.save()
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
    locations = Location.objects.all()

    for _ in range(num_rows):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = fake.email()
        prefix = "+375"
        area_code = random.choice(["29", "25", "44"])
        phone_number = prefix + area_code + ''.join(random.choices(string.digits, k=7))

        # Получаем случайный адрес из списка locations_list
        random_address = random.choice(locations)

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
        node_data = {
            "user": f"{user.user_id}",
        }
        node = Node(data=node_data)
        node.save()
def encrypt_decrypt_password(password, key):
    encrypted_password = ''
    for char in password:
        # Применить операцию XOR для каждого символа пароля с ключом
        encrypted_char = chr(ord(char) ^ key)
        encrypted_password += encrypted_char
    return encrypted_password

def generate_orders(num_rows):
    for _ in range(num_rows):
        car_id = random.randint(1, 100)
        user_id = random.randint(1, 1000)
        start_date = datetime.now() + timedelta(days=random.randint(1, 30))
        end_date = start_date + timedelta(days=random.randint(1, 7))
        total_cost = random.randint(100, 1000)

        car = Car.objects.get(car_id=car_id)
        car.is_free = False
        car.save()
        rental = Rental(car_id=car_id, user_id=user_id, start_date=start_date, end_date=end_date, total_cost=total_cost)
        rental.save()

        model = f"{car.brand} {car.model}"

        car_node_data = {
            "car": car_id,
            "user_id": user_id,
            "income": total_cost,
            "model": model
        }
        car_node = Node(data=car_node_data)
        car_node.save()

        user_node = Node.objects.filter(data__has_key='user', data__user=str(user_id)).first()

        if user_node is None:
            # Если узел не найден, обработать соответствующую логику
            print("Узел с информацией о пользователе не найден")
        else:
            print(user_node.data['user'])
        edge = Edge(previous_node=user_node, next_node=car_node)
        edge.save()

def export_data_to_xml():
    # Получаем все объекты из таблиц
    locations = Location.objects.all()
    cars = Car.objects.all()
    users = User.objects.all()
    rentals = Rental.objects.all()

    # Преобразуем объекты в XML-представление и сохраняем их в отдельные файлы
    current_dir = os.path.dirname(os.path.abspath(__file__))
    locations_file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'locations.xml')
    cars_file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'cars.xml')
    users_file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'users.xml')
    rentals_file_path = os.path.join(current_dir, 'static', 'main', 'xml', 'rentals.xml')

    with codecs.open(locations_file_path, 'w', encoding='utf-8') as locations_file:
        locations_xml = serialize('xml', locations)
        locations_file.write(locations_xml)

    with codecs.open(cars_file_path, 'w', encoding='utf-8') as cars_file:
        cars_xml = serialize('xml', cars)
        cars_file.write(cars_xml)

    with codecs.open(users_file_path, 'w', encoding='utf-8') as users_file:
        users_xml = serialize('xml', users)
        users_file.write(users_xml)

    with codecs.open(rentals_file_path, 'w', encoding='utf-8') as rentals_file:
        rentals_xml = serialize('xml', rentals)
        rentals_file.write(rentals_xml)

    print('Data exported successfully')