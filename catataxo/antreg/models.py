from django.db import models
from django.utils import timezone

# Create your models here.

class Genero(models.Model):
    
    nombre       = models.CharField(max_length=120) # max_length = required
    # subfamilia = models.ForeignKey(SubFamilia, on_delete=models.CASCADE)
    description  = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.nombre

class Especie(models.Model):
    
    nombre       = models.CharField(max_length=120)
    genero 	     = models.ForeignKey(Genero, on_delete=models.CASCADE)
    description  = models.TextField(blank=True, null=True)
    descubridor  = models.CharField(max_length=120)
    fechadescub  = models.DateTimeField(blank=True, null=True)
    # imagen       = models.ImageField()

    def __str__(self):
        return self.nombre
 
