from django.urls import path, include
from .views import UserViewSet, login_view
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('', UserViewSet)

urlpatterns = [
    path('login/', login_view, name='login'),
    path('', include(router.urls)),
    
]