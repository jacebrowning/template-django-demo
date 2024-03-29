from django.conf import settings
from django.urls import include, path

from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from rest_framework import routers

# Root

root = routers.DefaultRouter()


# App: demo_app

# root.register(...)


# URLs

schema_view = get_schema_view(
    openapi.Info(
        title="demo_project",
        default_version="0",
        description="The API for demo_project.",
    ),
    url=settings.BASE_URL,
)

urlpatterns = [
    path("", include(root.urls)),
    path("client/", include("rest_framework.urls")),
    path("docs/", schema_view.with_ui("swagger")),
]
