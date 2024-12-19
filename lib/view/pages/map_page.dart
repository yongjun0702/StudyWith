import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/widgets/button_widget.dart';
import 'package:study_with/view/widgets/dialog_widget.dart';
import 'package:study_with/view/widgets/tab_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 모든 마커 정보 및 세부 목록 데이터
  final List<Map<String, dynamic>> _markerData = [
    {
      'id': 'VisionTower',
      'name': '비전타워',
      'lat': 37.4494874,
      'lng': 127.1271825,
      'details': [
        '아르테크네 스페이스 2층',
        '아르테크네 스페이스 3층',
        '아르테크네 스페이스 4층',
        '아르테크네 스페이스 5층',
        '아르테크네 스페이스 6층',
        'C-CUBE 1층'
      ]
    },
    {
      'id': 'GachonHall',
      'name': '가천관',
      'lat': 37.4504147,
      'lng': 127.1299445,
      'details': ['아르테크네 스페이스 지하1층', '라곰 스페이스 1층']
    },
    {
      'id': 'GlobalCenter',
      'name': '글로벌센터',
      'lat': 37.4519359,
      'lng': 127.1271641,
      'details': ['아르테크네 스페이스 4층', '아르테크네 스페이스 5층', 'G-SPACE 1층']
    },
    {
      'id': 'Engineering1',
      'name': '공과대학1',
      'lat': 37.4516691,
      'lng': 127.1281045,
      'details': ['아르테크네 스페이스 2층']
    },
    {
      'id': 'GraduateSchool',
      'name': '교육대학원',
      'lat': 37.4518701,
      'lng': 127.1316762,
      'details': ['아르테크네 스페이스 1층', '아르테크네 스페이스 2층', '아르테크네 스페이스 4층']
    },
    {
      'id': 'IT',
      'name': 'AI공학관',
      'lat': 37.4551790,
      'lng': 127.1337842,
      'details': [
        '아르테크네 스페이스 2층',
        '아르테크네 스페이스 4층',
        '아르테크네 스페이스 5층',
        '아르테크네 스페이스 7층'
      ]
    },
    {
      'id': 'Engineering2',
      'name': '공과대학2',
      'lat': 37.4493148,
      'lng': 127.1285074,
      'details': ['아르테크네 스페이스 1층']
    },
    {
      'id': 'Art1',
      'name': '예술·체육대학1',
      'lat': 37.4523127,
      'lng': 127.1287385,
      'details': ['아르테크네 스페이스 1층', '아르테크네 스페이스 2층']
    },
    {
      'id': 'Art2',
      'name': '예술·체육대학2',
      'lat': 37.4516900,
      'lng': 127.1296501,
      'details': ['아르테크네 스페이스 3층']
    },
    {
      'id': 'StudentUnion',
      'name': '학생회관',
      'lat': 37.4531849,
      'lng': 127.1343712,
      'details': ['아르테크네 스페이스 1층']
    },
    {
      'id': 'Law',
      'name': '비전타워(법과대학)',
      'lat': 37.4492392,
      'lng': 127.1275551,
      'details': ['하나라운지 1층']
    },
  ];
  bool _isBottomSheetOpen = false;

  void _showBottomSheet(String title, String loungeId, List<String> details) {
    setState(() {
      _isBottomSheetOpen = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isDismissible: false,
      // 바깥을 눌러도 닫히지 않도록 설정
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: mainBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 세부 내용 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: mainBlue, width: 1.5),
                      ),
                      elevation: 0,
                      // 그림자 제거
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        title: Text(
                          details[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: mainBlue,
                          size: 18,
                        ),
                        onTap: () {
                          _selectLounge(loungeId, title, details[index]);
                        },
                      ),
                    );
                  },
                ),
              ),

              Center(
                child: CustomButton(
                    width: 100,
                    height: 50,
                    text: "닫기",
                    func: () {
                      setState(() {
                        _isBottomSheetOpen = false; // 바텀시트 상태 업데이트
                      });
                      Navigator.pop(context);
                    },
                    buttonCount: 1),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      // 바텀시트가 닫힐 때 상태 업데이트
      setState(() {
        _isBottomSheetOpen = false;
      });
    });
  }

  void _selectLounge(String loungeId, String loungeName, String detail) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentReference userDoc =
        _firestore.collection('user_sessions').doc(uid);
    final DocumentReference loungeDoc =
        _firestore.collection('lounges').doc(loungeId);

    try {
      // 사용자 세션 확인
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        // 활성 세션 확인
        if (userData.containsKey('active_session') &&
            userData['active_session']['end_time'] == null) {
          final activeSession = userData['active_session'];
          CustomDialog(
            context: context,
            title: "선택 실패",
            dialogContent:
                "이미 ${activeSession['lounge_name']}에서 이용하고 있어요.\n종료 후 다시 선택해주세요.",
            buttonText: "확인",
            buttonCount: 1,
            func: () {
              Navigator.pop(context);
            },
          );
          return;
        }
      }

      final Timestamp now = Timestamp.now(); // Firestore의 현재 시간

      // 새로운 활성 세션 추가
      await userDoc.set({
        'active_session': {
          'lounge_id': loungeId,
          'lounge_name': loungeName,
          'selected_space': "[$loungeName] $detail",
          'start_time': now,
          'end_time': null
        },
        'session_history': FieldValue.arrayUnion([
          {
            'lounge_id': loungeId,
            'lounge_name': loungeName,
            'selected_space': "[$loungeName] $detail",
            'start_time': now,
            'end_time': null
          }
        ])
      }, SetOptions(merge: true));

      // 라운지 데이터 업데이트
      final loungeSnapshot = await loungeDoc.get();
      if (loungeSnapshot.exists) {
        await loungeDoc.update({
          'current_users': FieldValue.increment(1),
          'total_users': FieldValue.increment(1),
        });
      } else {
        await loungeDoc.set({
          'name': loungeName,
          'current_users': 1,
          'total_users': 1,
        });
      }

      CustomDialog(
        context: context,
        title: "라운지 선택",
        dialogContent: "[$loungeName] $detail\n선택되었습니다.",
        buttonText: "확인",
        buttonCount: 1,
        func: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      CustomDialog(
        context: context,
        title: "오류",
        dialogContent: "라운지 선택 중 오류가 발생했습니다.\n$e",
        buttonText: "확인",
        buttonCount: 1,
        func: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = _markerData.map((data) {
      return Marker(
        markerId: MarkerId(data['id']),
        position: LatLng(data['lat'], data['lng']),
        onTap: () =>
            _showBottomSheet(data['name'], data['id'], data['details']),
      );
    }).toSet();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: const Text("라운지 선택",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.451039959670574, 127.12875330395157),
                zoom: 17.2,
              ),
              mapType: kIsWeb ? MapType.normal : MapType.hybrid,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _mapControllerCompleter.complete(controller);
              },
            ),
            // 웹에서 바텀시트가 열릴 때 지도를 터치하지 못하도록 하는 투명 오버레이
            if (_isBottomSheetOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {}, // 아무 작업도 하지 않음
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // 반투명 오버레이
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
