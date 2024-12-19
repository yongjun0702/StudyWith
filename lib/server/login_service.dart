import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 사용자 가져오기
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 이메일 및 비밀번호로 로그인
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('이메일 로그인 실패: $e');
      rethrow;
    }
  }

  // 이메일 및 비밀번호로 회원가입
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('회원가입 실패: $e');
      rethrow;
    }
  }

  // 사용자 프로필 닉네임 업데이트
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload(); // 사용자 정보 새로고침
    } catch (e) {
      print('닉네임 업데이트 실패: $e');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("로그아웃 성공");
    } catch (e) {
      print('로그아웃 실패: $e');
      rethrow;
    }
  }

  // 재인증 (이메일 및 비밀번호)
  Future<void> reauthenticateWithEmail(String email, String password) async {
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
          email: email, password: password);
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      print("재인증 성공");
    } catch (e) {
      print("재인증 실패: $e");
      rethrow;
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      print("회원탈퇴 성공");
    } catch (e) {
      print('회원탈퇴 실패: $e');
      rethrow;
    }
  }
}