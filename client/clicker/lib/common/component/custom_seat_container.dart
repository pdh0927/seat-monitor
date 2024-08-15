import 'package:clicker/common/const/colors.dart';
import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/rent/provider/rent_provider.dart';
import 'package:clicker/seat/provider/seat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomSeatContainer extends ConsumerWidget {
  final RentModel rentModel;

  const CustomSeatContainer({
    Key? key,
    required this.rentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 남은 시간 계산
    final totalMinutes =
        (rentModel.endedAt).difference(DateTime.now()).inMinutes;
    final percent = totalMinutes / 240; // 가정: 최대 4시간 배정

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: _CustomCircularIndicator(
              percent: percent,
              totalMinutes: totalMinutes,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${rentModel.seat.room.name}: ${rentModel.seat.number}번',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '배정시간: ${formatTimeRange(rentModel.startedAt, rentModel.endedAt)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CustomButton(
                      color: Colors.grey,
                      text: '상세정보',
                      onTap: () {},
                    ),
                    _CustomButton(
                      color: Colors.grey,
                      text: '연장',
                      onTap: () {
                        ref.read(rentProvider.notifier).updateRentInfo(
                              rentId: rentModel.id,
                              updateModel: rentModel.copyWith(
                                endedAt: DateTime.now().add(
                                  const Duration(hours: 4),
                                ),
                              ),
                            );
                      },
                    ),
                    _CustomButton(
                      color: Colors.red,
                      text: '반납',
                      onTap: () {
                        ref.read(rentProvider.notifier).updateRentInfo(
                              rentId: rentModel.id,
                              updateModel:
                                  rentModel.copyWith(endedAt: DateTime.now()),
                            );
                        ref
                            .read(seatInfoProvider.notifier)
                            .clearRentByRoomAndSeat(
                                rentModel.seat.room.id, rentModel.seat.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 시간 범위를 포맷팅하는 함수
  String formatTimeRange(DateTime start, DateTime end) {
    return '${formatTime(start)} - ${formatTime(end)}';
  }

  // DateTime을 시간 문자열로 변환
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _CustomCircularIndicator extends StatelessWidget {
  const _CustomCircularIndicator({
    Key? key,
    required this.percent,
    required this.totalMinutes,
  }) : super(key: key);

  final double percent;
  final int totalMinutes;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 55.0,
      lineWidth: 10.0,
      percent: percent,
      center: Text(
        '$totalMinutes분\n남음',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      backgroundColor: PRIMARY_COLOR,
      progressColor: Colors.grey,
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final Color color;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
