from .models import Seat
from .serializers import SeatSerializer
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Seat
from rent.models import Rent
from rent.serializers import RentSerializer
from rest_framework import status
from django.utils import timezone

class SeatViewSet(viewsets.ModelViewSet):
    queryset = Seat.objects.all()
    serializer_class = SeatSerializer
    
    @action(detail=False, methods=['get'], url_path='room/(?P<roomId>\d+)')
    def seats_with_rents(self, request, roomId=None):
        if roomId is not None:
            # 주어진 roomId에 해당하는 모든 좌석을 가져옴
            seats = self.get_queryset().filter(room_id=roomId)
            # 각 좌석에 대한 최신 임대 정보를 포함하여 결과를 구성
            results = []
            for seat in seats:
                
                rent = Rent.objects.filter(seat=seat, endedAt__gt=timezone.now()).order_by('-startedAt').first()
                seat_data = self.get_serializer(seat).data  # Seat 정보를 직렬화
                rent_data = RentSerializer(rent).data if rent else None
                results.append({
                    'seat': seat_data,
                    'rent': rent_data
                })

            return Response(results)
        else:
            # roomId가 제공되지 않으면, 400 Bad Request 에러를 반환
            return Response(status=status.HTTP_400_BAD_REQUEST)