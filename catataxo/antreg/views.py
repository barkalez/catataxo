from django.shortcuts import render, get_object_or_404
from .models import Especie
from .forms import EspecieModelForm
from django.views.generic import (
    CreateView,
    DetailView,
    ListView,
    UpdateView,
    DeleteView
)


# Create your views here.

class EspecieCreateView(CreateView):
    temaplate_name = 'ant_register/especie_create.html'
    form_class = EspecieModelForm
    queryset = Especie.objects.all()

    def form_valid(self, form):
        print(form.cleaned_data)
        return super().form_valid(form)
    
    

class EspecieListView(ListView):
    model = Especie
    temaplate_name = 'ant_register/especie_list.html'

class EspecieDetailView(DetailView):
    temaplate_name = 'ant_register/especie_detail.html'
    queryset = Especie.objects.all()

    
