from django.urls import path, include
from .views import RentViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('', RentViewSet)

urlpatterns =[
    path('', include(router.urls))
]