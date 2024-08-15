from django.db import models
from django.contrib.auth.models import BaseUserManager 
from django.contrib.auth.models import AbstractBaseUser

class UserManager(BaseUserManager):
    def create_user(self, student_number, password=None):
        if not student_number:
            raise ValueError('Users must have a student number')

        user = self.model(
            student_number=student_number,
        )
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, student_number, password=None):
        user = self.create_user(
            student_number=student_number,
            password=password
        )
        user.is_admin = True
        user.save(using=self._db)
        return user



class User(AbstractBaseUser):
	# DB에 저장할 데이터를 선언
    username = models.CharField("사용자 계정", max_length=20, blank=True)
    password = models.CharField("비밀번호", max_length=128)  # 해시되기 때문에 max_length가 길어야함
    student_number = models.IntegerField("학번", unique=True)
    name = models.CharField("이름", max_length=20)
    created_at = models.DateField("가입일", auto_now_add=True)
    is_attending = models.BooleanField(default=True)    # 재학 중인지 여부
     
    # 활성화 여부 (기본값은 True)
    is_active = models.BooleanField(default=True)

    # 관리자 권한 여부 (기본값은 False)
    is_admin = models.BooleanField(default=False)

    # 실제 로그인에 사용되는 아이디
    USERNAME_FIELD = 'student_number'

    # 어드민 계정을 만들 때 입력받을 정보 ex) email
    # 사용하지 않더라도 선언이 되어야함
    # USERNAME_FIELD와 비밀번호는 기본적으로 포함되어있음
    REQUIRED_FIELDS = []

    # custom user 생성 시 필요
    objects = UserManager()
	
    # 어드민 페이지에서 데이터를 제목을 어떻게 붙여줄 것인지 지정
    def __str__(self):
        return f"{str(self.student_number)} / {self.name}"

    # 로그인 사용자의 특정 테이블의 crud 권한을 설정, perm table의 crud 권한이 들어간다.
    # admin일 경우 항상 True, 비활성 사용자(is_active=False)의 경우 항상 False
    # 일반적으로 선언만 해두고 건들지않는다
    def has_perm(self, perm, obj=None):
        return True
	
    # 로그인 사용자의 특정 app에 접근 가능 여부를 설정, app_label에는 app 이름이 들어간다.
    # admin일 경우 항상 True, 비활성 사용자(is_active=False)의 경우 항상 False
    # 일반적으로 선언만 해두고 건들지않는다
    def has_module_perms(self, app_label):
        return True
    
    # admin 권한 설정
    @property
    def is_staff(self):
        return self.is_admin
