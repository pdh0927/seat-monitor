import 'package:clicker/common/const/data.dart';
import 'package:clicker/common/dio/dio.dart';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'room_repository.g.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return RoomRepository(dio, baseUrl: 'http://$ip/room');
});

// baseUrl : http://$ip/rent
@RestApi()
abstract class RoomRepository {
  factory RoomRepository(Dio dio, {String baseUrl}) = _RoomRepository;

  // GET : 특정 사용자의 Rent 정보를 불러옴
  @GET('/')
  Future<HttpResponse> getRooms();
}
