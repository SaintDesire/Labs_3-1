from django.urls import path, include
from . import views

urlpatterns = [
    path('', views.index, name='home'),
    path('login/', views.login, name='login'),
    path('signup/', views.signup, name='signup'),
    path('account/', views.account, name='account'),
    path('logout/', views.logout, name='logout'),
    path('addRent/', views.addRent, name='addRent'),
    path('car_rent/', views.car_rent, name='car_rent'),
    path('update_account/', views.update_account, name='update_account'),
    path('/admin/', views.admin_login, name='admin'),
    path('receipt/', views.generate_payment_receipt, name='receipt'),
    path('deleteAccount/', views.delete_account, name='deleteAccount'),
]
