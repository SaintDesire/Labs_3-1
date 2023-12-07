from django.http import JsonResponse
from django.shortcuts import render
import xml.etree.ElementTree as ET
import os

# Create your views here.
def index(request):
    return render(request, 'main/index.html')

def search_street(request):
    print('test')
    search_value = request.GET.get('search', '')
    # Здесь может быть логика для обработки запроса и получения подсказок
    hints = ['Подсказка 1', 'Подсказка 2', 'Подсказка 3']
    data = {
        'hints' : hints,
    }
    return render(request, 'main/index.html', data)