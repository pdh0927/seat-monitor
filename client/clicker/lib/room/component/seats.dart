import 'dart:math';

import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/rent/model/rent_post_model.dart';
import 'package:clicker/rent/provider/rent_provider.dart';
import 'package:clicker/seat/model/seat_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicker/seat/provider/seat_provider.dart';

class Seats extends ConsumerWidget {
  const Seats({
    super.key,
    required this.roomId,
  });
  final int roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seatInfos = ref.watch(seatInfoProvider)[roomId];
    const int maxSeatsPerRow = 4;

    // seatInfos를 4개씩 나누기
    final dividedSeatInfos = seatInfos != null
        ? [
            for (int i = 0; i < seatInfos.length; i += maxSeatsPerRow)
              seatInfos.sublist(i, min(i + maxSeatsPerRow, seatInfos.length))
          ]
        : [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (int index = 0; index < dividedSeatInfos.length; index++) ...[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (final seatInfo in dividedSeatInfos[index])
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (ref.read(rentProvider) == null) {
                        RentModel? rentModel =
                            await ref.read(rentProvider.notifier).postRentInfo(
                                  RentPostModel(
                                    seat: seatInfo.seat.id,
                                    userId: 1,
                                  ),
                                );
                        ref
                            .read(seatInfoProvider.notifier)
                            .setRentByRoomAndSeat(
                                roomId, seatInfo.seat.id, rentModel!);
                        Navigator.pop(context);
                      }
                    },
                    child: SeatContainer(
                      seatInfo: seatInfo,
                    ),
                  ),
                  const SizedBox(height: 16), // 좌석 간격 조절
                ],
              ),
          ]),
          if (index % 2 == 0 && index < dividedSeatInfos.length - 1) ...[
            const SizedBox(width: 8), // 좌석과 벽 사이의 간격
            Container(
              // 책상이나 벽을 나타내는 위젯
              width: 20,
              height: 300, // 벽의 높이를 키움
              color: Colors.grey,
            ),
            const SizedBox(width: 8), // 벽과 다음 줄 좌석 사이의 간격
          ] else
            const SizedBox(width: 20),
        ]
      ]),
    );
  }
}

class SeatContainer extends StatelessWidget {
  final SeatInfoModel seatInfo;

  const SeatContainer({
    Key? key,
    required this.seatInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerSize = MediaQuery.of(context).size.height * 0.07;
    double maxTime = 4 * 60; // 4시간을 분 단위로 표현

    double usedRatio = 0.0;

    if (seatInfo.rent != null) {
      final remainedMinutes = seatInfo.rent!.endedAt
          .difference(DateTime.now())
          .inMinutes
          .toDouble();
      usedRatio = remainedMinutes / maxTime; // 최대 1.0까지로 제한
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      height: containerSize,
      width: containerSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.green),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: usedRatio * containerSize,
                  height: double.maxFinite,
                  color: Colors.purple,
                ),
                if (seatInfo.rent != null)
                  Expanded(
                    flex: ((1.0 - usedRatio) * containerSize).toInt(),
                    child: Container(
                      height: double.maxFinite,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '${seatInfo.seat.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
