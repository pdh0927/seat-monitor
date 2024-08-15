from django.contrib.auth import authenticate, login
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from rest_framework import viewsets
from .models import User
from .serializers import UserSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

@csrf_exempt
def login_view(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        student_number = data.get('student_number')
        password = data.get('password')

        user = authenticate(request, username=student_number, password=password)
        if user is not None:
            login(request, user)
            # 로그인 성공 시 FCM 토큰 업데이트
            user.save()
            return JsonResponse( UserSerializer(user).data, status=200)
        else:
            return JsonResponse({'status': 'failure', 'message': 'Invalid credentials'}, status=401)
    return JsonResponse({'status': 'failure', 'message': 'Invalid request method'}, status=400)
