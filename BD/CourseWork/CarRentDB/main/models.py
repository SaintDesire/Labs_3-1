from datetime import timezone, date, timedelta

from django.contrib.auth.models import User
from django.contrib.gis.db import models
from django.core.validators import MinValueValidator



class Location(models.Model):
    location_id = models.AutoField(primary_key=True)
    address = models.CharField(max_length=100)
    geom = models.PointField(srid=4326, default=None)

    def __str__(self):
        return self.address

class Car(models.Model):
    car_id = models.AutoField(primary_key=True)
    brand = models.CharField(max_length=50, default=None)
    model = models.CharField(max_length=50, default=None)
    color = models.CharField(max_length=20, default=None)
    year = models.IntegerField()
    status = models.CharField(max_length=20, default=None)
    number = models.CharField(max_length=20, default='Unknown')
    location = models.ForeignKey(Location, on_delete=models.CASCADE, null=True, default=None)
    is_free = models.BooleanField(default=True)

class User(models.Model):
    ROLES = (
        ('user', 'User'),
        ('admin', 'Admin'),
    )
    user_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=50, default=None)
    last_name = models.CharField(max_length=50, default=None)
    email = models.CharField(max_length=100, default=None)
    phone = models.CharField(max_length=20, default=None)
    address = models.ForeignKey(Location, on_delete=models.CASCADE, null=True, default=None)
    password = models.CharField(max_length=128, default=None)
    role = models.CharField(max_length=50, choices=ROLES, default='user')
    ban_end_date = models.DateField(null=True, blank=True, validators=[MinValueValidator(limit_value=date.today() + timedelta(days=1))])
    is_active = models.BooleanField(default=True)
    is_banned = models.BooleanField(default=False)
    def is_admin(self):
        return self.role == 'admin'

    def is_banned(self):
        return self.ban_end_date is not None and self.ban_end_date >= timezone.now().date()

    def save(self, *args, **kwargs):
        if self.is_banned:
            self.ban_end_date = date.today() + timedelta(days=1)
        else:
            self.ban_end_date = None
        super().save(*args, **kwargs)


class Rental(models.Model):
    rental_id = models.AutoField(primary_key=True)
    car = models.ForeignKey(Car, on_delete=models.CASCADE, default=None)
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=None)
    start_date = models.DateField()
    end_date = models.DateField()
    total_cost = models.DecimalField(max_digits=10, decimal_places=2)




carsDictionary = {
    "BMW": {
        "models": {
            "X5": {
                "year": 2020,
            },
            "3 Series": {
                "year": 2019,
            }
        }
    },
    "Toyota": {
        "models": {
            "Camry": {
                "year": 2020,
            },
            "Corolla": {
                "year": 2021,
            }
        }
    },
    "Honda": {
        "models": {
            "Civic": {
                "year": 2021,
            },
            "Accord": {
                "year": 2020,
            }
        }
    },
    "Audi": {
        "models": {
            "A3": {
                "year": 2019,
            },
            "A4": {
                "year": 2020,
            }
        }
    },
    "Mercedes": {
        "models": {
            "C-Class": {
                "year": 2021,
            },
            "E-Class": {
                "year": 2020,
            }
        }
    },
    "Volkswagen": {
        "models": {
            "Golf": {
                "year": 2021,
            },
            "Passat": {
                "year": 2020,
            }
        }
    },
    "Ford": {
        "models": {
            "Focus": {
                "year": 2021,
            },
            "Mustang": {
                "year": 2020,
            }
        }
    },
    "Chevrolet": {
        "models": {
            "Cruze": {
                "year": 2020,
            },
            "Malibu": {
                "year": 2019,
            }
        }
    },
    "Nissan": {
        "models": {
            "Sentra": {
                "year": 2021,
            },
            "Altima": {
                "year": 2020,
            }
        }
    },
    "Subaru": {
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