from django.urls import path

from . import views


urlpatterns = [
    path('', views.current_datetime),
]

app_name = 'demo_app'
