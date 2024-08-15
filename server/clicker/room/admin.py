from django.contrib import admin

from .models import Room, RoomImage

@admin.register(Room)
class RoomAdmin(admin.ModelAdmin):
    readonly_fields = ('id',)  # 상세보기에서 보기위해서 
    
@admin.register(RoomImage)
class RoomImageAdmin(admin.ModelAdmin):
    readonly_fields = ('id',)  # 상세보기에서 보기위해서 

