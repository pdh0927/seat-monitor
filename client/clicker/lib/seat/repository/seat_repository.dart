import 'package:clicker/common/const/data.dart';
import 'package:clicker/common/dio/dio.dart';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'seat_repository.g.dart';

final seatRepositoryProvider = Provider<SeatRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return SeatRepository(dio, baseUrl: 'http://$ip/seat');
});

// baseUrl : http://$ip/seat
@RestApi()
abstract class SeatRepository {
  factory SeatRepository(Dio dio, {String baseUrl}) = _SeatRepository;

  @GET('/room/{roomId}')
  Future<HttpResponse> getSeatInfos({
    @Path("roomId") required int roomId,
  });
}
