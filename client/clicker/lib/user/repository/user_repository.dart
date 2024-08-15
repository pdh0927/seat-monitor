import 'package:clicker/common/const/data.dart';
import 'package:clicker/common/dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio, baseUrl: 'http://$ip/user');
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  // POST: 로그인 엔드포인트
  @POST('/login/')
  Future<HttpResponse> login(@Body() Map<String, dynamic> body);
}
