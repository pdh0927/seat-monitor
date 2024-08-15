import 'package:clicker/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomMenuBar extends StatefulWidget {
  const CustomMenuBar({super.key});

  @override
  State<CustomMenuBar> createState() => _CustomMenuBarState();
}

class _CustomMenuBarState extends State<CustomMenuBar> {
  int menu = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.w,
      width: 100.w,
      decoration: BoxDecoration(color: Colors.grey[500]),
      padding: EdgeInsets.only(top: 2.w),
      child: Row(
        children: getMenus(),
      ),
    );
  }

  void changeMenu(int menu) {
    setState(() {
      this.menu = menu;
    });
  }

  final List<String> menuNames = ['홈', '스마트 열람증', 'MyClicker', '메세지'];

  List<_MenuItem> getMenus() {
    List<_MenuItem> childs = [];

    for (int i = 0; i < menuNames.length; i++) {
      childs.add(_MenuItem(
        name: menuNames[i],
        changeMenu: () => changeMenu(i),
        isSelected: menu == i,
      ));
    }

    return childs;
  }
}

class _MenuItem extends StatelessWidget {
  final VoidCallback changeMenu;
  final String name;
  final bool isSelected;

  const _MenuItem({
    required this.name,
    required this.changeMenu,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        changeMenu();
      },
      child: Container(
        width: 25.w,
        padding: EdgeInsets.only(top: isSelected ? 4 : 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: isSelected ? 4 : 0,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? PRIMARY_COLOR : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
