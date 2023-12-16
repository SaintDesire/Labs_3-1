var map = L.map('map').setView([53.9, 27.5667], 12);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors',
    maxZoom: 18,
}).addTo(map);

var carsData = [];
var count = 0;
var carElements = document.getElementsByClassName('car');
for (var i = 0; i < carElements.length; i++) {
    var carElement = carElements[i];
    var isFree = carElement.getAttribute('data-is-free');
    if (isFree) {  // Добавлено условие проверки значения поля is_free
        var carData = {
            coordinates: {
                latitude: parseFloat(carElement.getAttribute('data-latitude').replace(',', '.')),
                longitude: parseFloat(carElement.getAttribute('data-longitude').replace(',', '.'))
            },
            car: {
                car_id: carElement.getAttribute('data-car-id'),
                brand: carElement.getAttribute('data-brand'),
                model: carElement.getAttribute('data-model'),
                color: carElement.getAttribute('data-color'),
                number: carElement.getAttribute('data-number')
            }

        };
        carsData.push(carData);
    }
}


function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

var currentUserElement = document.querySelector('.current-user');
var currentUserId = currentUserElement.getAttribute('data-user-id');

for (var i = 0; i < carsData.length; i++) {
    var carData = carsData[i];
    var carMarker = L.marker([carData.coordinates.latitude, carData.coordinates.longitude]).addTo(map);
    carMarker.bindPopup(`
        <div>
            <form action="car_rent/" method="POST">
                <input type="hidden" name="csrfmiddlewaretoken" value="${getCookie('csrftoken')}">
                Car ID: <input type="text" name="car_id" value="${carData.car.car_id}" readonly style="border: none; background-color: transparent; outline: none; width: 50px"><br>
                Brand: <input type="text" name="brand" value="${carData.car.brand}" readonly style="border: none; background-color: transparent; outline: none; width: 50px"><br>
                Model: <input type="text" name="model" value="${carData.car.model}" readonly style="border: none; background-color: transparent; outline: none; width: 50px"><br>
                Color: <input type="text" name="color" value="${carData.car.color}" readonly style="border: none; background-color: transparent; outline: none; width: 50px"><br>
                Number: <input type="text" name="number" value="${carData.car.number}" readonly style="border: none; background-color: transparent; outline: none; width: 50px"><br>
                ${currentUserId !== "None" ? '<input type="submit" value="Забронировать">' : '<p>Авторизуйтесь чтобы забронировать</p>'}
            </form>
        </div>
    `);
}

var currentUserElement = document.querySelector('.current-user');
var userLatitude = parseFloat(currentUserElement.getAttribute('data-user-latitude').replace(',', '.'));
var userLongitude = parseFloat(currentUserElement.getAttribute('data-user-longitude').replace(',', '.'));
var markerIcon = L.icon({
iconUrl: 'https://mapmarker.io/api/v3/font-awesome/v6/pin?text=Me&size=75&color=FFF&background=BC5AF4&hoffset=0&voffset=0',
iconSize: [50, 50],
iconAnchor: [30, 45]
});
var userMarker = L.marker([userLatitude, userLongitude], { icon: markerIcon }).addTo(map);
userMarker.bindPopup('User Location');