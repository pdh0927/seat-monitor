import 'package:clicker/common/const/data.dart';
import 'package:clicker/common/dio/dio.dart';
import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/rent/model/rent_post_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'rent_repository.g.dart';

final rentRepositoryProvider = Provider<RentRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return RentRepository(dio, baseUrl: 'http://$ip/rent');
});

// baseUrl : http://$ip/rent
@RestApi()
abstract class RentRepository {
  factory RentRepository(Dio dio, {String baseUrl}) = _RentRepository;

  // GET : 특정 사용자의 Rent 정보를 불러옴
  @GET('/user/{userId}/')
  Future<HttpResponse> getRentInfo({
    @Path("userId") required int userId,
  });

  @POST('/')
  Future<HttpResponse> postRentInfo({
    @Body() required RentPostModel rentModel,
  });

  // PATCH : 특정 Rent를 업데이트
  @PATCH('/{rentId}/')
  Future<HttpResponse> updateRentInfo({
    @Path("rentId") required int rentId,
    @Body() required RentModel rentModel,
  });
}
