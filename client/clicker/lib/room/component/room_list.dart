import 'package:clicker/common/const/style.dart';
import 'package:clicker/room/model/room_model.dart';
import 'package:clicker/room/provider/room_provider.dart';
import 'package:clicker/room/view/room_screen.dart';
import 'package:clicker/seat/model/seat_info_model.dart';
import 'package:clicker/seat/provider/seat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomList extends ConsumerWidget {
  const RoomList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RoomModel> roomModels = ref.watch(roomListProvider);
    final Map<int, List<SeatInfoModel>> roomInfos = ref.watch(seatInfoProvider);

    return Container(
      height: 340,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: roomModels.length,
        itemBuilder: (BuildContext context, int index) {
          final RoomModel roomModel = roomModels[index];

          final List<SeatInfoModel>? seatInfos = roomInfos[roomModel.id];
          final int occupiedSeats = seatInfos != null
              ? seatInfos.where((seatInfo) => seatInfo.rent != null).length
              : 0;

          return _RoomCard(
            roomModel: roomModel,
            occupiedSeats: occupiedSeats,
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomModel roomModel;
  final int occupiedSeats;

  const _RoomCard({
    required this.roomModel,
    required this.occupiedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final double occupancyRate = occupiedSeats / roomModel.totalSeat;

    return InkWell(
      onTap: () {
        if (roomModel.name == 'Test Room') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomScreen(
                roomId: roomModel.id,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomModel.name,
              style: homeContentTextStyle,
            ),
            const SizedBox(height: 7),
            LinearProgressIndicator(
              value: occupancyRate,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$occupiedSeats석 사용중',
                  style: homeContentTextStyle,
                ),
                Text(
                  '전체 ${roomModel.totalSeat}석',
                  style: homeContentTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// final List<RoomModel> roomModels = [
//   RoomModel(id: 1, name: '(중) 제1열람실 (지하)', totalSeat: 100),
//   RoomModel(id: 2, name: '(중) 제2열람실 (지하)', totalSeat: 100),
//   RoomModel(id: 3, name: '(중) 2층자료실 (동편)', totalSeat: 100),
//   RoomModel(id: 4, name: '(중) 2층자료실 (북편)', totalSeat: 100),
//   RoomModel(id: 5, name: '(중) 2층자료실 (서편)', totalSeat: 100),
//   RoomModel(id: 6, name: '(중) 3층자료실 (동편)', totalSeat: 100),
//   RoomModel(id: 7, name: '(중) 3층자료실 (북편)', totalSeat: 100),
//   RoomModel(id: 8, name: '(중) 3층자료실 (서편)', totalSeat: 100),
//   RoomModel(id: 9, name: '(과) 1층 과학기술자료실1', totalSeat: 100),
//   RoomModel(id: 10, name: '(과) 1층 과학기술자료실2', totalSeat: 100),
//   RoomModel(id: 11, name: '(과) 2층 제1열람실[LINC+LC 1]', totalSeat: 100),
//   RoomModel(id: 12, name: '(과) 2층 제1열람실[LINC+LC 2]', totalSeat: 100),
//   RoomModel(id: 13, name: '(과) 2층 스마트 러닝커먼스', totalSeat: 100),
//   RoomModel(id: 14, name: '(과) 3층 제2열람실', totalSeat: 100),
//   RoomModel(id: 15, name: '(과) 3층 크리에이티브 러닝커먼스', totalSeat: 100),
//   RoomModel(id: 16, name: '(과) 4층 제3열람실', totalSeat: 100),
//   RoomModel(id: 17, name: '(과) 4층 커리어라운지', totalSeat: 100),
// ];