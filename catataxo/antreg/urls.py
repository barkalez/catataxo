from django.urls import path
from .views import (
    EspecieListView,
    EspecieDetailView
)

urlpatterns = [
    path('especie_list', EspecieListView.as_view(), name="especie_list"),
    path('<int:pk>/', EspecieDetailView.as_view(), name="especie_detail"),
]