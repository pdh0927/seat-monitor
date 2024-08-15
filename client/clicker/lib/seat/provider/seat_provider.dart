import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/seat/model/seat_info_model.dart';
import 'package:clicker/seat/repository/seat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seatInfoProvider =
    StateNotifierProvider<SeatInfoStateNotifier, Map<int, List<SeatInfoModel>>>(
        (ref) {
  final seatRepository = ref.watch(seatRepositoryProvider);

  return SeatInfoStateNotifier(
    repository: seatRepository,
  );
});

class SeatInfoStateNotifier
    extends StateNotifier<Map<int, List<SeatInfoModel>>> {
  final SeatRepository repository;

  SeatInfoStateNotifier({
    required this.repository,
  }) : super({});

  Future<List<SeatInfoModel>> getSeatInfos(int roomId) async {
    try {
      final response = await repository.getSeatInfos(roomId: roomId);
      final List<SeatInfoModel> seatInfoList = (response.data as List<dynamic>)
          .map((data) => SeatInfoModel.fromJson(data))
          .toList();

      // Create a copy of the existing state
      final Map<int, List<SeatInfoModel>> newState = Map.from(state);

      // Update the state for the specified roomId
      newState[roomId] = seatInfoList;
      // Assign the updated copy to the state
      state = newState;

      return seatInfoList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void clearRentByRoomAndSeat(int roomId, int seatId) {
    try {
      final Map<int, List<SeatInfoModel>> newState = Map.from(state);

      final List<SeatInfoModel>? seatInfos = newState[roomId];

      if (seatInfos != null) {
        newState[roomId] = seatInfos.map((seatInfo) {
          if (seatInfo.seat.id == seatId) {
            return seatInfo.copyWith(rent: null);
          } else {
            return seatInfo;
          }
        }).toList();

        // 새로운 상태를 state에 할당합니다.
        state = newState;
      }
    } catch (e) {
      print(e);
    }
  }

  void setRentByRoomAndSeat(int roomId, int seatId, RentModel rent) {
    try {
      final Map<int, List<SeatInfoModel>> newState = Map.from(state);

      final List<SeatInfoModel>? seatInfos = newState[roomId];

      if (seatInfos != null) {
        newState[roomId] = seatInfos.map((seatInfo) {
          if (seatInfo.seat.id == seatId) {
            // 주어진 RentModel 객체로 rent 속성을 업데이트합니다.
            return seatInfo.copyWith(rent: rent);
          } else {
            return seatInfo;
          }
        }).toList();

        // 새로운 상태를 state에 할당합니다.
        state = newState;
      }
    } catch (e) {
      print(e);
    }
  }
}
