from django.contrib import admin

from .models import Rent


@admin.register(Rent)
class RentAdmin(admin.ModelAdmin):
    readonly_fields = ('id',)  # 상세보기에서 보기위해서 