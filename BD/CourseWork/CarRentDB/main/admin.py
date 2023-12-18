import json

from django.contrib import admin
from django.db import connection
from django.db.models import Sum, FloatField
from django.db.models.functions import Cast

from main.models import *
from main.views import encrypt_decrypt_password


class CarAdmin(admin.ModelAdmin):
    list_display = ('car_id', 'brand', 'model', 'color', 'year', 'status', 'number', 'is_free', 'get_location_address')

    def get_location_address(self, obj):
        return obj.location.address

admin.site.register(Car, CarAdmin)

class UserAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'email', 'phone', 'get_address', 'get_decrypted_password', 'is_active')

    def get_address(self, obj):
        return obj.address.address

    def get_decrypted_password(self, obj):
        key = 15  # Здесь укажите свой ключ
        decrypted_password = encrypt_decrypt_password(obj.password, key)
        return decrypted_password

    def save_model(self, request, obj, form, change):
        if obj.pk:
            # Если пользователь уже существует
            if 'password' not in form.changed_data:
                # Если поле password не изменено, оставляем его без изменений
                obj.password = User.objects.get(pk=obj.pk).password
            else:
                # Если поле password изменено, шифруем новый пароль
                obj.password = encrypt_decrypt_password(obj.password, 15)

        super().save_model(request, obj, form, change)

admin.site.register(User, UserAdmin)


class NodeAdmin(admin.ModelAdmin):
    list_display = ('id', 'user_count', 'transaction_count', 'total_income', 'popular_cars')
    readonly_fields = ('user_count', 'transaction_count', 'total_income', 'popular_cars')

    def user_count(self, obj):
        with connection.cursor() as cursor:
            cursor.execute("SELECT count(data->>'user') AS user FROM main_node;")
            result = cursor.fetchone()
            return result[0] if result else None

    user_count.short_description = 'User Count'

    def transaction_count(self, obj):
        with connection.cursor() as cursor:
            cursor.execute("SELECT count(data->>'car') AS transaction FROM main_node;")
            result = cursor.fetchone()
            return result[0] if result else None

    transaction_count.short_description = 'Transaction Count'

    def popular_cars(self, obj):
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT data->>'car' AS car, COUNT(*) AS popularity
                FROM main_node
                GROUP BY data->>'car'
                ORDER BY popularity DESC;
            """)
            return cursor.fetchall()

    def total_income(self, obj):
        with connection.cursor() as cursor:
            cursor.execute("SELECT SUM((data->>'income')::NUMERIC) AS total_income FROM main_node;")
            result = cursor.fetchone()
            return result[0] if result else None

    total_income.short_description = 'Total Income'


admin.site.register(Node, NodeAdmin)


class EdgeAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'car_count', 'car_list')

    def user_id(self, obj):
        return obj.previous_node.data.get('user')

    user_id.short_description = 'User ID'

    def car_count(self, obj):
        with connection.cursor() as cursor:
            query = """
                SELECT COUNT(*) AS count
                FROM main_edge
                WHERE previous_node_id = %s;
            """
            cursor.execute(query, [obj.previous_node_id])
            result = cursor.fetchone()
            return result[0] if result else None

    car_count.short_description = 'Car Count'

    def car_list(self, obj):
        with connection.cursor() as cursor:
            query = """
                 SELECT next_node_id
                 FROM main_edge
                 WHERE previous_node_id = %s;
             """
            cursor.execute(query, [obj.previous_node_id])
            rows = cursor.fetchall()
            car_ids = [row[0] for row in rows]

        car_list = []
        for car_id in car_ids:
            car_node = Node.objects.get(id=car_id)
            car_data = json.loads(car_node.data['car'])
            car_list.append(car_data)

        return car_list


admin.site.register(Edge, EdgeAdmin)