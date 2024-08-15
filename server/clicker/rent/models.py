from django.db import models
from django.utils import timezone
from datetime import timedelta

from seat.models import Seat
from user.models import User

# 현재 시간에서 4시간을 더해서 반환하는 함수
def four_hours_from_now():
    return timezone.now() + timedelta(hours=4)

class Rent(models.Model):
    id = models.AutoField(primary_key=True)
    seat = models.ForeignKey(Seat, on_delete=models.CASCADE)
    userId = models.ForeignKey(User, on_delete=models.CASCADE)
    startedAt = models.DateTimeField("배정 시간", default=timezone.now)
    endedAt = models.DateTimeField("반납 시간", default=four_hours_from_now)

    def __str__(self):
        return f"{self.seat}({self.userId})"