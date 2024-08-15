import 'package:clicker/common/component/custom_menu_bar.dart';
import 'package:clicker/common/component/custom_seat_container.dart';
import 'package:clicker/common/component/custom_title_bar.dart';
import 'package:clicker/rent/provider/rent_provider.dart';
import 'package:clicker/room/component/room_list.dart';
import 'package:clicker/common/const/colors.dart';
import 'package:clicker/common/const/style.dart';
import 'package:clicker/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHomeTitleBar(),
            CustomMenuBar(),
            Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  @override
  Widget build(BuildContext context) {
    final rentInfo = ref.watch(rentProvider);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('박동환', style: homeTitleTextStyle),
            const SizedBox(height: 6.0),
            rentInfo != null
                ? CustomSeatContainer(
                    rentModel: rentInfo,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      '제 5회 도서관 책.사랑.나눔 행사 안내(교내 구성원 대상 무료 배부) 10/30(월)~31(화) 10:00-16:00 중앙도서관 1층 로비\n*상세내용은 도서관 홈페이지 참조',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
            const SizedBox(height: 6.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: _BodyMenu(),
            ),
            const SizedBox(height: 10.0),
            Text(
              '좌석 배정',
              style: homeTitleTextStyle,
            ),
            const SizedBox(height: 6.0),
            const RoomList(),
            const SizedBox(height: 6.0),
            const LogoutButton()
          ],
        ),
      ),
    );
  }
}

class _BodyMenu extends StatelessWidget {
  _BodyMenu();

  final List<IconData> icons = [
    Icons.chair_sharp,
    Icons.wifi_tethering,
    Icons.note_alt_outlined,
    Icons.perm_contact_calendar_rounded,
    Icons.cast_for_education_sharp,
    Icons.light,
    Icons.phone_android_rounded,
    Icons.add_alert_rounded,
    Icons.key_rounded,
    Icons.qr_code_2_sharp,
    Icons.home_filled,
    Icons.help_sharp,
  ];

  final List<String> menuNames = [
    '좌석배정',
    '컴퓨터실',
    '그룹학습실/\n세미나실',
    '연구알람실',
    '스마트 열람증',
    'MyClicker',
    'App\n등록관리',
    '메세지',
    '사물함',
    'QR',
    '도서관 홈',
    '도움말',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      alignment: Alignment.center,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 3 / 3.1,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 1),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(
                    color: PRIMARY_COLOR,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icons[index],
                  size: 30,
                  color: PRIMARY_COLOR,
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                child: Text(
                  menuNames[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 1),
            ],
          );
        },
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: const Text('로그아웃'),
      ),
    );
  }
}
