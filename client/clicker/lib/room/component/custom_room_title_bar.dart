import 'package:flutter/material.dart';

class CustomRoomTitleBar extends StatelessWidget {
  const CustomRoomTitleBar({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const SizedBox(width: 5),
            InkWell(
              onTap: onTap,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              '뒤로',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const Text(
          '좌석배정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 70)
      ],
    );
  }
}
