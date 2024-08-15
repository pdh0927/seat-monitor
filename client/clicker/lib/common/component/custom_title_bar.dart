import 'package:clicker/common/const/colors.dart';
import 'package:clicker/rent/provider/rent_provider.dart';
import 'package:clicker/room/provider/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomHomeTitleBar extends ConsumerWidget {
  const CustomHomeTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        InkWell(
          onTap: () {
            ref.read(rentProvider.notifier).getRentInfo();
            ref.read(roomListProvider.notifier).getRooms();
            print('이거1');
          },
          child: Image.asset(
            'assets/image/yu.png',
            width: 40.w,
            height: 8.w,
            fit: BoxFit.fill,
          ),
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {},
          icon: Icon(
            Icons.settings,
            color: PRIMARY_COLOR,
            size: 10.w,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
