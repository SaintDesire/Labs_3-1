from django.db import models


class Location(models.Model):
    location_id = models.AutoField(primary_key=True)
    address = models.CharField(max_length=100)
    geom = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'locations'


class Car(models.Model):
    car_id = models.AutoField(primary_key=True)
    brand = models.CharField(max_length=50)
    model = models.CharField(max_length=50)
    color = models.CharField(max_length=20)
    year = models.IntegerField()
    status = models.CharField(max_length=20)
    number = models.CharField(max_length=20)
    location = models.ForeignKey(Location, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = 'cars'


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    address = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'users'


class Rental(models.Model):
    rental_id = models.AutoField(primary_key=True)
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    start_date = models.DateField()
    end_date = models.DateField()
    total_cost = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'rentals'


class Graph(models.Model):
    graph_id = models.AutoField(primary_key=True)
    graph_name = models.CharField(max_length=50)
    graph_data = models.TextField()

    class Meta:
        managed = False
        db_table = 'graphs'


carsDictionary = {
    "bmw": {
        "models": {
            "X5": {
                "year": 2020,
            },
            "3 Series": {
                "year": 2019,
            }
        }
    },
    "toyota": {
        "models": {
            "Camry": {
                "year": 2020,
            },
            "Corolla": {
                "year": 2021,
            }
        }
    },
    "honda": {
        "models": {
            "Civic": {
                "year": 2021,
            },
            "Accord": {
                "year": 2020,
            }
        }
    },
    "audi": {
        "models": {
            "A3": {
                "year": 2019,
            },
            "A4": {
                "year": 2020,
            }
        }
    },
    "mercedes": {
        "models": {
            "C-Class": {
                "year": 2021,
            },
            "E-Class": {
                "year": 2020,
            }
        }
    },
    "volkswagen": {
        "models": {
            "Golf": {
                "year": 2021,
            },
            "Passat": {
                "year": 2020,
            }
        }
    },
    "ford": {
        "models": {
            "Focus": {
                "year": 2021,
            },
            "Mustang": {
                "year": 2020,
            }
        }
    },
    "chevrolet": {
        "models": {
            "Cruze": {
                "year": 2020,
            },
            "Malibu": {
                "year": 2019,
            }
        }
    },
    "nissan": {
        "models": {
            "Sentra": {
                "year": 2021,
            },
            "Altima": {
                "year": 2020,
            }
        }
    },
    "subaru": {
        "models": {
            "Impreza": {
                "year": 2021,
            },
            "Forester": {
                "year": 2020,
            }
        }
    }
}