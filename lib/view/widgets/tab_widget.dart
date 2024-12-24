
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/pages/home_page.dart';
import 'package:study_with/view/pages/setting_page.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;  /// 탭 전환을 제어
  int index = 0;  /// 현재 선택된 탭의 인덱스

  @override
  void initState() {
    super.initState();
    _permissionWithNotification();
    controller = TabController(length: 2, vsync: this);  /// 세 개의 탭으로 구성된 컨트롤러 초기화
    controller.addListener(tabListner);  /// 탭 변경 시 리스너 호출
  }


  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }


  @override
  void dispose() {
    controller.removeListener(tabListner);
    controller.dispose();
    super.dispose();
  }

  void tabListner() {
    setState(() {
      index = controller.index;  /// 현재 탭의 인덱스를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),  /// 스크롤로 탭 전환을 비활성화
        controller: controller,
        children: [
          HomePage(),
          SettingScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: mainBlue,
        unselectedItemColor: grey60,
        backgroundColor: white,
        selectedFontSize: 14,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,  /// 고정된 네비게이션 바 타입 설정
        onTap: (int index) {
          controller.animateTo(index);  /// 탭 선택 시 해당 탭으로 전환
        },
        currentIndex: index,  /// 현재 선택된 탭의 인덱스
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label: '설정'),
        ],
      ),
    );
  }
}
