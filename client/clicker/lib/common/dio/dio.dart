import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // dio를 사용할 떄, 중간 과정에서 intercepter를 추가해서 추가적인 작업 해줌
  dio.interceptors.add(CustomIntercepter(ref: ref));

  return dio;
});

class CustomIntercepter extends Interceptor {
  final Ref ref;

  CustomIntercepter({
    required this.ref,
  });

  // 1) 요청을 보낼 때
  // 요청이 보내질 때마다, 만약에 요청의 header에 accessToken : true라는 값이 있다면
  // (storage에서) 실제 토큰을 가져와서 authorization : Bearer $token으로 헤더를 변경한다
  @override
  void onRequest // 요청을 보내기 직전 가로채서 실행
      (
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQ] [${options.method}] ${options.uri}');

    return super.onRequest(options, handler); // 요청을 보냄
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    return handler.reject(err);
  }
}
