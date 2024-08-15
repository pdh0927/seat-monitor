from django.db import models
from django.utils import timezone
from room.models import Room

class Seat(models.Model):
    id = models.AutoField(primary_key=True)
    number = models.IntegerField("좌석 번호")
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    lastDetected = models.DateTimeField("마지막 감지", default=timezone.now)

    def __str__(self):
        return f"{self.number} (마지막 감지 : {self.lastDetected})"