import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_with/server/auth_provider.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/pages/home_page.dart';
import 'package:study_with/view/widgets/tab_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
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
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isKeyboardOpen)
                Column(
                  children: [
                    SizedBox(height: 50),
                    Image.asset("assets/img/logo.png",
                        width: 180, height: 180, fit: BoxFit.contain),
                  ],
                ),
              SizedBox(height: isKeyboardOpen ? 30 : 80),

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
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              SizedBox(height: 40),

              // 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  if (_validateFields()) {
                    try {
                      await authProvider.signInWithEmail(
                          _emailController.text, _passwordController.text);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => RootTab()),
                            (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      setState(() {
                        _errorMessage = "로그인 실패: 이메일 또는 비밀번호를 확인하세요.";
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
                child:
                Text("로그인", style: TextStyle(fontSize: 20, color: white)),
              ),
              SizedBox(height: 5),

              // 회원가입 버튼
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: mainBlue, width: 0.5))),
                  child: Text(
                    '계정이 없으신가요? 회원가입',
                    style: TextStyle(fontSize: 16, color: mainBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _obscureText = true;
  String? _errorMessage;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _validateFields() {
    if (_nicknameController.text.isEmpty) {
      setState(() {
        _errorMessage = "닉네임을 입력하세요.";
      });
      return false;
    }
    if (!_emailController.text.contains('@')) {
      setState(() {
        _errorMessage = "이메일 형식이 맞지 않습니다.";
      });
      return false;
    }
    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = "비밀번호는 6자 이상이어야 합니다.";
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

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "간단한 정보를 입력 후\n서비스를 이용하세요.",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              // 닉네임 입력
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임',
                  prefixIcon: Icon(Icons.person, color: mainBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '이메일',
                  prefixIcon: Icon(Icons.email, color: mainBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
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
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              SizedBox(height: 40),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: () async {
                  if (_validateFields()) {
                    try {
                      await authProvider.signUpWithEmail(
                          _emailController.text,
                          _passwordController.text,
                          _nicknameController.text);
                      Navigator.pop(context); // 로그인 화면으로 돌아가기
                    } catch (e) {
                      setState(() {
                        _errorMessage = "회원가입 실패: 다시 시도하세요.";
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
                child:
                Text("회원가입", style: TextStyle(fontSize: 20, color: white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}