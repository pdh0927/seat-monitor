from django.db import models
from django.utils import timezone

class Room(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField("열람실명", max_length=20)
    totalSeat =  models.IntegerField("총 좌석수")

    def __str__(self):
        return f"{self.name} (총 좌석 수: {self.totalSeat})"
    

class RoomImage(models.Model):
    id = models.AutoField(primary_key=True)
    roomId = models.IntegerField("Room Id")
    image = models.ImageField()  
    startedAt = models.DateTimeField("촬영 시간", default=timezone.now)

    def __str__(self):
        return self.roomId + '('+ self.startedAt+')'
