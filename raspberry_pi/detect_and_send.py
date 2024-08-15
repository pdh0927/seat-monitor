import cv2
import numpy as np
import datetime
import requests
import time
import os

# 서버 URL 및 데이터 설정
server_url = "http://192.168.137.221:8000/upload/" # ip에 맞게 변경
data = {'roomId': 2}

# 카메라 초기화 및 버퍼 크기 설정
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

def capture_frame():
    """카메라에서 최신 프레임을 캡처"""
    # 버퍼를 비워 최신 프레임을 얻음
    for _ in range(5):
        cap.read()
    ret, frame = cap.read()
    if not ret:
        print("Unable to capture video")
        return None
    return frame

def save_image(frame, quality=50):
    """프레임을 이미지 파일로 저장, 화질 조절 가능"""
    timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    filename = f'/home/pi/image_{timestamp}.jpg'
    
    # JPEG 화질 설정하여 이미지 저장
    cv2.imwrite(filename, frame, [int(cv2.IMWRITE_JPEG_QUALITY), quality])
    
    return filename

def send_image_to_server(filename):
    """이미지를 서버로 전송하고, 전송 후 파일 제거"""
    with open(filename, 'rb') as f:
        files = {'image': f}
        response = requests.post(server_url, files=files, data=data)
    os.remove(filename)

while True:
    start_time = time.time()

    # 프레임 캡처 및 저장
    # 사람 인식이 가능한 최소의 화질을 설정하여 용량 최소화
    frame = capture_frame()
    if frame is not None:
        filename = save_image(frame, quality=50)
        send_image_to_server(filename)
    
    print(f"{time.time() - start_time:.4f} sec")

    # 테스트용으로 10초 대기
    # 실제 사용할 때는 원하는 시간으로 조절
    time.sleep(10)

cap.release()