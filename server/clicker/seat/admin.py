from django.contrib import admin

from .models import Seat


@admin.register(Seat)
class SeatAdmin(admin.ModelAdmin):
    readonly_fields = ('id',)  # 상세보기에서 보기위해서 