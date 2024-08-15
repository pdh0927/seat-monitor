import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/rent/model/rent_post_model.dart';
import 'package:clicker/rent/repository/rent_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rentProvider =
    StateNotifierProvider<RentStateNotifier, RentModel?>((ref) {
  final rentRepository = ref.watch(rentRepositoryProvider);

  return RentStateNotifier(
    repository: rentRepository,
  );
});

class RentStateNotifier extends StateNotifier<RentModel?> {
  final RentRepository repository;

  RentStateNotifier({
    required this.repository,
  }) : super(null) {
    getRentInfo();
  }

  Future<RentModel?> getRentInfo() async {
    try {
      final response = await repository.getRentInfo(userId: 1);
      state = RentModel.fromJson(response.data);

      return state;
    } catch (e) {
      state = null;
      print(e);
      return state;
    }
  }

  Future<RentModel?> postRentInfo(RentPostModel rentModel) async {
    try {
      final response = await repository.postRentInfo(rentModel: rentModel);
      state = RentModel.fromJson(response.data);
      print(response.data);
      return state;
    } catch (e) {
      print(e);
      return state;
    }
  }

  Future<RentModel?> updateRentInfo(
      {required int rentId, required RentModel updateModel}) async {
    try {
      final response = await repository.updateRentInfo(
        rentId: rentId,
        rentModel: updateModel,
      );

      if (updateModel.endedAt.difference(DateTime.now()).inMinutes != 0) {
        state = RentModel.fromJson(response.data);
      } else {
        state = null;
      }

      return state;
    } catch (e) {
      print(e);
      return state;
    }
  }
}
