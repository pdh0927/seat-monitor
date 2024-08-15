from django.contrib import admin

from .models import User



@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    readonly_fields = ('id',)  # 상세보기에서 보기위해서 