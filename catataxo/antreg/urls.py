from django.urls import path
from antreg import views

urlpatterns = [
    path('', views.especie, name="especie"),