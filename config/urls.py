from django.conf import settings
from django.contrib import admin
from django.urls import include, path

import debug_toolbar

urlpatterns = [
    path("", include("demo_project.demo_app.urls", namespace="demo_app")),
    path("api/", include("demo_project.api.urls")),
    path("admin/", admin.site.urls),
]

if settings.ALLOW_DEBUG:
    urlpatterns = [
        path("__debug__/", include(debug_toolbar.urls)),
        path("__reload__/", include("django_browser_reload.urls")),
    ] + urlpatterns
