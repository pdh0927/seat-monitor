from django.urls import path, include
from .views import SeatViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('', SeatViewSet)

urlpatterns =[
    path('', include(router.urls))
]