from django.urls import path
from .views import (
    EspecieCreateView,
    EspecieDetailView,
    EspecieListView
)

urlpatterns = [
    path('especie_form', EspecieCreateView.as_view(), name="especie_create"),
    path('especie_list', EspecieListView.as_view(), name="especie_list"),
    path('<int:pk>/', EspecieDetailView.as_view(), name="especie_detail"),
]