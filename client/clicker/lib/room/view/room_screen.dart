import 'package:clicker/room/component/custom_room_title_bar.dart';
import 'package:clicker/room/component/seats.dart';
import 'package:clicker/seat/provider/seat_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomScreen extends ConsumerWidget {
  final int roomId;

  const RoomScreen({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(seatInfoProvider.notifier).getSeatInfos(roomId);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomRoomTitleBar(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: Seats(roomId: roomId)),
          ],
        ),
      ),
    );
  }
}
