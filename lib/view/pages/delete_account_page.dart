import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_with/server/auth_provider.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/pages/login_page.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _validateFields() {
    if (!_emailController.text.contains('@')) {
      setState(() {
        _errorMessage = "이메일 형식이 맞지 않습니다.";
      });
      return false;
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "비밀번호를 입력하세요.";
      });
      return false;
    }
    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          "회원탈퇴",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isKeyboardOpen)
                Text(
                  "회원탈퇴를 진행하려면\n이메일과 비밀번호를 입력하세요.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              if (!isKeyboardOpen) SizedBox(height: 40),

              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '이메일',
                  prefixIcon: Icon(Icons.mail, color: mainBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).nextFocus(); // 다음 필드로 이동
                },
              ),
              SizedBox(height: 20),

              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  prefixIcon: Icon(Icons.lock, color: mainBlue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: mainBlue,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  FocusScope.of(context).unfocus(); // 키보드 닫기
                },
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              SizedBox(height: 40),

              // 회원탈퇴 버튼
              ElevatedButton(
                onPressed: _isLoading
                    ? null // 로딩 중에는 버튼 비활성화
                    : () async {
                  if (_validateFields()) {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    try {
                      await authProvider.deleteAccount(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      setState(() {
                        _errorMessage = "회원탈퇴 실패: 이메일 또는 비밀번호를 확인하세요.";
                      });
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                  color: white,
                  strokeWidth: 4,
                )
                    : Text(
                  "회원탈퇴",
                  style: TextStyle(fontSize: 20, color: white),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}