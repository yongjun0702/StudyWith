import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/server/auth_provider.dart';
import 'package:study_with/view/pages/delete_account_page.dart';
import 'package:study_with/view/pages/login_page.dart';
import 'package:study_with/view/widgets/dialog_widget.dart';
import 'package:study_with/view/widgets/privacy_policy_widget.dart';


class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String? photoURL = authProvider.user?.photoURL; // 사용자 이미지 URL

    void _showPrivacyPolicy() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const PrivacyPolicyBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }

    void _showTermPolicy() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const TermPolicyBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }
    void _showDeveloper() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 스크롤 가능하게 설정
        builder: (BuildContext context) {
          return const DeveloperBottomSheet(); // 바텀시트 위젯 호출
        },
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("설정", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: background,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(children: [
                    CircleAvatar(
                      backgroundImage: photoURL != null && photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : AssetImage('assets/img/lounge_img2.png')
                      as ImageProvider,
                      // 기본 이미지 추가
                      radius: 50,
                      backgroundColor: Colors.grey[300], // 배경 색상 설정
                    ),
                    SizedBox(height: 16),
                    Text(
                      authProvider.user?.displayName ?? '사용자 이름',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      authProvider.user?.email ?? '이메일 정보 없음',
                      style: TextStyle(
                        fontSize: 16,
                        color: subBlue,
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  CustomDialog(
                      context: context,
                      title: "로그아웃",
                      dialogContent: "로그아웃 하시겠습니까?",
                      buttonText: "확인",
                      buttonCount: 2,
                      func: () async {
                        try {
                          await authProvider.signOut();
                          // 로그아웃 성공 후 LoginScreen으로 이동
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                                  (route) => false);
                        } catch (e) {
                          print("로그아웃 실패: $e");
                        }
                      });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "로그아웃",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainBlue,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/img/navigation.png", color: mainBlue,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "회원탈퇴",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainBlue,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/img/navigation.png", color: mainBlue,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _showPrivacyPolicy();
                        },
                        child: Text(
                          "개인정보처리방침",
                          style: TextStyle(color: subBlue, fontSize: 18),
                        )),
                    SizedBox(height: 5),
                    GestureDetector(
                        onTap: () {
                          _showTermPolicy();
                        },
                        child: Text(
                          "서비스 이용약관",
                          style: TextStyle(color: subBlue, fontSize: 18),
                        )),
                    SizedBox(height: 5),
                    GestureDetector(
                        onTap: () {
                          _showDeveloper();
                        },
                        child: Text(
                          "개발자 정보",
                          style: TextStyle(color: subBlue, fontSize: 18),
                        )),
                    SizedBox(height: 5),
                    Text(
                      "ver 1.0.0",
                      style: TextStyle(color: subBlue, fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
