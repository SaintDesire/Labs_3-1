from django.contrib import admin
from main.models import *
from main.views import encrypt_decrypt_password


class CarAdmin(admin.ModelAdmin):
    list_display = ('brand', 'model', 'color', 'year', 'status', 'number', 'get_location_address')

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