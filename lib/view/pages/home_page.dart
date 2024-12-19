import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/pages/detail_page.dart';
import 'package:study_with/view/pages/map_page.dart';
import 'package:study_with/view/pages/setting_screen.dart';
import 'package:study_with/view/widgets/container_widget.dart';
import 'package:study_with/view/widgets/dialog_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> imageList = [
    "assets/img/lounge_img2.png",
    "assets/img/lounge_img9.png",
    "assets/img/lounge_img3.png",
    "assets/img/lounge_img10.png",
    "assets/img/lounge_img4.png",
    "assets/img/lounge_img1.png",
  ];
  int _currentIndex = 0;
  String? _userName;
  String formattedDate = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _userName = currentUser.displayName;
      });
    }
  }

  Future<void> _endSession() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // 유저 세션 문서 가져오기
      final DocumentReference userDoc =
      _firestore.collection('user_sessions').doc(uid);
      final DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // 유저 문서가 존재하지 않음
        CustomDialog(
          context: context,
          title: "종료 불가",
          dialogContent: "현재 이용 중인 라운지가 없습니다.",
          buttonText: "확인",
          buttonCount: 1,
          func: () {
            Navigator.pop(context);
          },
        );
        return;
      }

      // 데이터 타입 캐스팅
      final Map<String, dynamic> userData =
      userSnapshot.data() as Map<String, dynamic>;

      if (!userData.containsKey('active_session')) {
        // 활성 세션이 없는 경우
        CustomDialog(
          context: context,
          title: "종료 불가",
          dialogContent: "현재 이용 중인 라운지가 없습니다.",
          buttonText: "확인",
          buttonCount: 1,
          func: () {
            Navigator.pop(context);
          },
        );
        return;
      }

      final activeSession = userData['active_session'];

      if (activeSession['end_time'] != null) {
        // 세션이 이미 종료된 경우
        CustomDialog(
          context: context,
          title: "종료 불가",
          dialogContent: "현재 이용 중인 라운지가 없습니다.",
          buttonText: "확인",
          buttonCount: 1,
          func: () {
            Navigator.pop(context);
          },
        );
        return;
      }

      final loungeId = activeSession['lounge_id'];

      // 세션 종료 처리
      final Timestamp now = Timestamp.now();
      await userDoc.update({
        'active_session.end_time': now, // 활성 세션에 종료 시간 기록
        'session_history': FieldValue.arrayUnion([
          {
            ...activeSession,
            'end_time': now,
          }
        ])
      });

      // 라운지 데이터 업데이트
      final DocumentReference loungeDoc =
      _firestore.collection('lounges').doc(loungeId);
      await loungeDoc.update({
        'current_users': FieldValue.increment(-1),
      });

      CustomDialog(
        context: context,
        title: "종료 완료",
        dialogContent: "라운지 이용이 성공적으로 종료되었습니다.",
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
        dialogContent: "종료 처리 중 오류가 발생했습니다. 다시 시도해주세요.",
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
    String displayName = (_userName?.length ?? 0) > 10
        ? '${_userName!.substring(0, 10)}...'
        : _userName ?? '사용자';

    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: background,
          title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 70,
                height: 70,
                child: Image.asset("assets/img/logo.png"),
              )),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  "assets/img/settings.png",
                  color: subBlue,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$formattedDate\n',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: '$displayName님 안녕하세요!',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapPage()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: mainBlue,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 15),
                                          side: BorderSide(
                                            color: mainBlue,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: const Text(
                                          "라운지 선택",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: _endSession,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: mainBlue,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 15),
                                          side: BorderSide(
                                            color: mainBlue,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: const Text(
                                          "이용 종료",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: grey20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                stream: _firestore
                                    .collection('user_sessions')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || !snapshot.data!.exists) {
                                    // 데이터가 없을 경우
                                    return const Text(
                                      "현재 이용 내역이 없습니다.",
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    );
                                  }

                                  final userData = snapshot.data!.data() as Map<String, dynamic>;

                                  // 활성 세션 확인
                                  final activeSession = userData['active_session'];
                                  if (activeSession != null && activeSession['end_time'] == null) {
                                    // 현재 활성 세션이 있는 경우
                                    final selectedSpace = activeSession['selected_space'] ?? '알 수 없음';
                                    final startTime = (activeSession['start_time'] as Timestamp).toDate();
                                    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(startTime);

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "현재 이용 중인 라운지",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "$formattedTime\n$selectedSpace",
                                          style: TextStyle(fontSize: 15, color: mainBlue),
                                        ),
                                      ],
                                    );
                                  }


                                  // 최근 이용 내역 확인
                                  final sessionHistory = userData['session_history'] as List<dynamic>? ?? [];
                                  if (sessionHistory.isNotEmpty) {
                                    final recentSession = sessionHistory.last as Map<String, dynamic>;
                                    final selectedSpace = recentSession['selected_space'] ?? '알 수 없음';
                                    final startTime = (recentSession['start_time'] as Timestamp).toDate();
                                    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(startTime);

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "최근 이용 내역",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "$formattedTime\n$selectedSpace",
                                          style: TextStyle(fontSize: 15, color: mainBlue),
                                        ),
                                      ],
                                    );
                                  }

                                  // 활성 세션도 없고, 내역도 없는 경우
                                  return const Text(
                                    "현재 이용 내역이 없습니다.",
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          enlargeCenterPage: false,
                          enableInfiniteScroll: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: imageList.map((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => setState(() {
                                _currentIndex = entry.key;
                              }),
                              child: Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                      _currentIndex == entry.key ? 0.9 : 0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // 인기 라운지 섹션
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('lounges')
                        .snapshots(), // Firestore에서 데이터 가져오기
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 데이터를 가져온 후 클라이언트에서 정렬
                      final List<DocumentSnapshot> lounges = snapshot.data!.docs;

                      lounges.sort((a, b) {
                        final currentA = a['current_users'] as int;
                        final currentB = b['current_users'] as int;

                        if (currentA != currentB) {
                          return currentB.compareTo(currentA); // current_users로 내림차순 정렬
                        }

                        // current_users가 같으면 total_users로 정렬
                        final totalA = a['total_users'] as int;
                        final totalB = b['total_users'] as int;
                        return totalB.compareTo(totalA);
                      });

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "실시간 인기 라운지",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: lounges.map((lounge) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: '🔥',
                                                style: TextStyle(fontSize: 15, color: Colors.red),
                                              ),
                                              TextSpan(
                                                text: ' ${lounge['name']} (${lounge['current_users']}명)',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "누적 이용자: ${lounge['total_users']}명",
                                          style: TextStyle(fontSize: 15, color: mainBlue),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // 나의 이용 내역 섹션
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('user_sessions')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomContainer(
                            child: const Text(
                              "현재 이용 내역이 없습니다.",
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        );
                      }

                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      final sessionHistory = userData['session_history'] as List<dynamic>? ?? [];

                      if (sessionHistory.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomContainer(
                            child: const Text(
                              "현재 이용 내역이 없습니다.",
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        );
                      }

                      // 최근 세션 3개 가져오기
                      final recentSessions = sessionHistory.reversed.take(3).toList();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "나의 이용 내역",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...recentSessions.map((session) {
                                final sessionData = session as Map<String, dynamic>;
                                final selectedSpace = sessionData['selected_space'] ?? '알 수 없음';
                                final startTime =
                                (sessionData['start_time'] as Timestamp).toDate();
                                final formattedTime =
                                DateFormat('yyyy-MM-dd HH:mm').format(startTime);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "$formattedTime\n$selectedSpace",
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  // 자세히 보기 클릭 시 전체 내역 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "자세히 보기",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: mainBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              )
            ],
          ),
        ));
  }
}
