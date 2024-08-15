from django.utils import timezone
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status
from .models import Rent
from .serializers import RentPostSerializer, RentSerializer

class RentViewSet(viewsets.ModelViewSet):
    queryset = Rent.objects.all()
    serializer_class = RentSerializer
    
    def create(self, request, *args, **kwargs):
        # RentPostSerializer를 사용하여 입력 데이터를 검증하고 객체를 생성
        serializer = RentPostSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        
        # Rent 객체 생성 후, RentSerializer를 사용하여 응답 데이터 생성
        rent = serializer.instance
        response_serializer = RentSerializer(rent)
        
        # 해당 Rent 객체와 연결된 Seat의 lastDetected 필드를 현재 시간으로 업데이트
        seat = rent.seat
        seat.lastDetected = timezone.now()
        seat.save()
        
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    
    @action(detail=False, methods=['get'], url_path='user/(?P<userId>\d+)')
    def user_rent(self, request, userId=None):
        if userId is not None:
            # 주어진 userId 대한 가장 최근의 Rent 객체를 가져옴
            # startedAt에 대해서 내림차순 정렬하여 가장 첫번째꺼 가져옴
            # endedAt이 현재시각 이후에 거만 가져옴
            rent = Rent.objects.filter(userId=userId, endedAt__gt=timezone.now()).order_by('-startedAt').first()
            if rent:
                # Rent 객체가 존재하면, 이를 시리얼라이즈하여 반환
                serializer = self.get_serializer(rent)
                return Response(serializer.data)
            else:
                # Rent 객체가 존재하지 않으면, 404 Not Found 에러를 반환
                return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            # userId 제공되지 않으면, 400 Bad Request 에러를 반환
            return Response(status=status.HTTP_400_BAD_REQUEST)
    