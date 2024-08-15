from django.contrib import admin
from django.urls import path, include
from room.views import upload_image

urlpatterns = [
    path("admin/", admin.site.urls),
    path('user/', include('user.urls')),
    path('room/', include('room.urls')),
    path('seat/', include('seat.urls')),
    path('rent/', include('rent.urls')),
    path('upload/', upload_image, name='upload-image'),
]