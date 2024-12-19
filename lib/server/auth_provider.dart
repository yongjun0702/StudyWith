import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final LoginService _loginService = LoginService();

  AuthProvider() {
    _initializeUser();
    checkLoginStatus();
  }

  User? get user => _user;
  String? get uid => _user?.uid;
  String? get displayName => _user?.displayName;

  void checkLoginStatus() {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  void _initializeUser() {
    _user = _loginService.getCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (_user != user) {
        _user = user;
        notifyListeners();
      }
    });
  }

  // 이메일 및 비밀번호로 로그인
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final User? user = await _loginService.signInWithEmail(email, password);
      if (_user != user) {
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      print('이메일 로그인 실패: $e');
      rethrow;
    }
  }

  // 이메일 및 비밀번호로 회원가입 + 닉네임 설정
  Future<void> signUpWithEmail(String email, String password, String nickname) async {
    try {
      final User? user = await _loginService.signUpWithEmail(email, password);
      if (user != null) {
        await _loginService.updateDisplayName(nickname);
        _user = FirebaseAuth.instance.currentUser; // 최신 사용자 정보 불러오기
        notifyListeners();
      }
    } catch (e) {
      print('회원가입 실패: $e');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _loginService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('로그아웃 실패: $e');
      rethrow;
    }
  }

  // 닉네임 업데이트
  Future<void> updateNickname(String nickname) async {
    try {
      await _loginService.updateDisplayName(nickname);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      print('닉네임 업데이트 실패: $e');
      rethrow;
    }
  }

  // 회원탈퇴 (이메일 재인증 후 삭제)
  Future<void> deleteAccount(String email, String password) async {
    try {
      // 먼저 재인증을 수행
      await _loginService.reauthenticateWithEmail(email, password);

      // 계정 삭제
      await _loginService.deleteAccount();
      _user = null; // 로컬 사용자 상태 초기화
      notifyListeners();
      print('회원탈퇴 성공');
    } catch (e) {
      print('회원탈퇴 실패: $e');
      rethrow;
    }
  }
}