from django.shortcuts import render, get_object_or_404
from .models import Especie
from django.views.generic import (
    CreateView,
    DetailView,
    ListView,
    UpdateView,
    DeleteView
)


# Create your views here.

class EspecieListView(ListView):
    model = Especie
    temaplate_name = 'ant_register/especie_list.html'

class EspecieDetailView(DetailView):
    temaplate_name = 'ant_register/especie_detail.html'
    queryset = Especie.objects.all()

    
