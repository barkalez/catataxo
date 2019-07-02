from django import forms
from .models import Especie

class EspecieModelForm(forms.ModelForm):
    class Meta:
        model = Especie
        fields =[
            'nombre',
            'genero' ,  
            'description',
            'descubridor',
            'fechadescub'
        ]