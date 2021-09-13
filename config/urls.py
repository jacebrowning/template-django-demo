from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("", include("demo_project.demo_app.urls", namespace="demo_app")),
    path("api/", include("demo_project.api.urls")),
    path("admin/", admin.site.urls),
    path("grappelli/", include("grappelli.urls")),
]
