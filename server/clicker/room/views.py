import os
import cv2
import matplotlib.pyplot as plt
from matplotlib import patches
from django.conf import settings
from django.http import JsonResponse
from django.utils import timezone
from django.db import transaction
from datetime import timedelta
from rest_framework import viewsets
from rest_framework.decorators import api_view
from ultralytics import YOLO
from seat.models import Seat
from .models import Room, RoomImage
from .serializers import RoomSerializer
from rent.models import Rent

class RoomViewSet(viewsets.ModelViewSet):
    # Room 모델에 대한 기본 CRUD 뷰셋 정의
    queryset = Room.objects.all()
    serializer_class = RoomSerializer

# YOLO 모델 로드 (yolov8m.pt 사용)
model = YOLO("yolov8m.pt")
plt.switch_backend('Agg')  # 백엔드를 'Agg'로 변경해 그래픽 출력 방지

def save_image(image_file):
    # 이미지 파일을 지정된 경로에 저장
    image_path = os.path.join(settings.MEDIA_ROOT, image_file.name)
    os.makedirs(os.path.dirname(image_path), exist_ok=True)
    with open(image_path, 'wb') as dest:
        for chunk in image_file.chunks():
            dest.write(chunk)
    return image_path

def save_room_image(room_id, image_file):
    # RoomImage 모델에 이미지 경로 저장
    image_relative_path = os.path.join('images', image_file.name)
    RoomImage(roomId=room_id, image=image_relative_path).save()

def detect_people_in_regions(img, regions, results):
    # 주어진 이미지의 각 영역에서 사람 탐지
    detected_regions = []
    for i, (x1, y1, x2, y2) in enumerate(regions):
        person_detected = False
        for detection, cls_id in zip(results[0].boxes.xyxy, results[0].boxes.cls):
            bx1, by1, bx2, by2 = detection[:4].tolist()
            # 클래스 ID가 0이면 사람으로 간주하고 영역 내 위치 확인
            if cls_id == 0 and bx1 >= x1 and bx2 <= x2 and by1 >= y1 and by2 <= y2:
                person_detected = True
                break
        detected_regions.append((i + 1, person_detected))  # 좌석 번호와 감지 여부 저장
    return detected_regions

def update_seat_detection(detected_regions, room_id):
    # 감지된 좌석에 대해 lastDetected 시간 업데이트
    for seat_number, detected in detected_regions:
        if detected:
            Seat.objects.filter(number=seat_number, room_id=room_id).update(lastDetected=timezone.now())

def handle_expired_seats():
    # 감지되지 않은 좌석의 배정 취소 처리
    with transaction.atomic(): 
        for seat in Seat.objects.all():
            # 마지막 감지된 시간이 2시간 이상 경과한 경우
            if seat.lastDetected < timezone.now() - timedelta(hours=2):
                try:
                    # 가장 최근의 Rent 객체 찾기
                    latest_rent = Rent.objects.filter(seat=seat, seat__room_id=seat.room_id).latest('startedAt')
                    # 종료되지 않은 배정에 대해 종료 시간 설정
                    if latest_rent.endedAt is None or latest_rent.endedAt > timezone.now():
                        latest_rent.endedAt = timezone.now()
                        latest_rent.save()
                        print(f'{seat.number}번 배정이 취소되었습니다')
                except Rent.DoesNotExist:
                    pass  # Rent 객체가 없을 경우 예외 처리

@api_view(['POST'])
def upload_image(request):
    if request.method == 'POST':
        # 이미지 파일과 roomId 추출
        image_file = request.FILES['image']
        room_id = request.data['roomId']
        
        # 이미지 저장 및 RoomImage 모델에 경로 저장
        image_path = save_image(image_file)
        save_room_image(room_id, image_file)

        # OpenCV로 이미지 읽고 RGB로 변환
        img = cv2.imread(image_path)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Matplotlib 설정
        fig, ax = plt.subplots(figsize=(10, 5))
        ax.imshow(img)
        ax.axis('off')

        # YOLO 모델로 객체 탐지
        results = model(img)
        img_height, img_width, _ = img.shape
        one_eighth_height = img_height // 7.5
        usable_height = img_height - 2 * one_eighth_height
        step_x = img_width // 4
        step_y = usable_height // 4 + 20

        # 4x4 그리드 생성
        regions = [(x * step_x, one_eighth_height + y * step_y, (x + 1) * step_x, one_eighth_height + (y + 1) * step_y)
                   for x in range(4) for y in range(4)]

        # 사람 탐지 및 좌석 상태 업데이트
        detected_regions = detect_people_in_regions(img, regions, results)
        update_seat_detection(detected_regions, room_id)
        handle_expired_seats()

        # 탐지 결과 표시
        for (x1, y1, x2, y2), (seat_number, detected) in zip(regions, detected_regions):
            rect = patches.Rectangle((x1, y1), x2-x1, y2-y1, linewidth=1, edgecolor='r', facecolor='none')
            ax.add_patch(rect)
            ax.text((x1 + x2) / 2, (y1 + y2) / 2, f'{seat_number} {"detected" if detected else "No detected"}',
                    color='white', bbox=dict(facecolor='red' if detected else 'blue', alpha=0.5),
                    horizontalalignment='center', verticalalignment='center')

        # 처리된 이미지 저장
        processed_image_path = os.path.join(settings.MEDIA_ROOT, 'processed', image_file.name)
        os.makedirs(os.path.dirname(processed_image_path), exist_ok=True)
        plt.savefig(processed_image_path)

        # 처리 결과 반환
        return JsonResponse({'message': 'Image processed successfully', 'roomId': room_id}, status=200)

    # POST 요청이 아닐 경우 에러 반환
    return JsonResponse({'error': 'Only POST request is supported'}, status=400)
