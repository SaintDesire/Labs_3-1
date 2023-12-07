from django.urls import path, include
from . import views

urlpatterns = [
    path('', views.index, name='home'),
    path('', views.search_street, name='search_street')
]
