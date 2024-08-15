from django.urls import path, include
from .views import RoomViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('', RoomViewSet)

urlpatterns =[
    path('', include(router.urls)),
]