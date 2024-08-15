from room.serializers import RoomSerializer
from .models import Seat
from rest_framework import serializers

class SeatSerializer(serializers.ModelSerializer):
    room = RoomSerializer(read_only=True)
    
    class Meta:
        model = Seat
        fields = '__all__'