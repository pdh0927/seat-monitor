import 'package:clicker/room/model/room_model.dart';
import 'package:clicker/room/repository/room_repository.dart';
import 'package:clicker/seat/provider/seat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomListProvider =
    StateNotifierProvider<RoomStateNotifier, List<RoomModel>>((ref) {
  final roomRepository = ref.watch(roomRepositoryProvider);

  return RoomStateNotifier(
    ref: ref,
    repository: roomRepository,
  );
});

class RoomStateNotifier extends StateNotifier<List<RoomModel>> {
  final RoomRepository repository;
  final Ref ref;

  RoomStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]) {
    getRooms();
  }

  Future<List<RoomModel>?> getRooms() async {
    try {
      final response = await repository.getRooms();

      // final List<RoomModel> roomList = (response.data as List<dynamic>)
      //     .map((data) => RoomModel.fromJson(data))
      //     .toList();

      final List<RoomModel> roomList = [];
      for (final data in response.data as List<dynamic>) {
        final room = RoomModel.fromJson(data);
        roomList.add(room);
        ref.read(seatInfoProvider.notifier).getSeatInfos(room.id);
      }

      state = roomList;

      return state;
    } catch (e) {
      print(e);
      return state;
    }
  }
}
