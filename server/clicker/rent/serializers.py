from .models import Rent
from rest_framework import serializers
from seat.serializers import SeatSerializer

        
class RentSerializer(serializers.ModelSerializer):
    seat = SeatSerializer(read_only=True)
    
    class Meta:
        model = Rent
        fields = '__all__'
        
        
class RentPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rent
        fields = ['seat', 'userId'] 