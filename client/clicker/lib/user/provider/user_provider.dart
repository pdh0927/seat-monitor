// 로그인 상태를 관리하는 provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicker/user/model/user_model.dart';
import 'package:clicker/user/repository/user_repository.dart';

final userProvider =
    StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserStateNotifier(ref: ref, userRepository: userRepository);
});

class UserStateNotifier extends StateNotifier<UserModel?> {
  final Ref ref; // Riverpod의 Ref 객체
  final UserRepository userRepository; // 서버와 통신하는 repository

  // 초기 상태를 null로 설정
  UserStateNotifier({required this.ref, required this.userRepository})
      : super(null);

  // 로그인 처리
  Future<void> login(int studentNumber, String password) async {
    try {
      // 서버로 로그인 요청
      final response = await userRepository.login({
        'student_number': studentNumber,
        'password': password,
      });

      // 로그인 성공 시 상태 업데이트
      if (response.response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final user = UserModel.fromJson(responseData);
        state = user;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      // 예외 처리
      print('Login error: $e');
      throw Exception('Login error: $e');
    }
  }

  // 로그아웃 처리
  void logout() {
    state = null;
  }
}
