
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/firebase_options.dart';
import 'package:study_with/server/auth_provider.dart';
import 'package:study_with/view/pages/login_page.dart';
import 'package:study_with/view/pages/splash_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

late Size ratio;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkLoginStatus(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Pretendard",
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: mainBlue,

          // TextField 스타일 통일
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: mainBlue, fontSize: 16),
            prefixIconColor: mainBlue,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainBlue, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainBlue, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            // MediaQuery가 올바르게 초기화되었는지 확인
            final mediaQuery = MediaQuery.of(context);
            if (mediaQuery.size == null) {
              return const Center(
                  child: CircularProgressIndicator()); // 로딩 화면 표시
            }
            ratio =
                Size(mediaQuery.size.width / 412, mediaQuery.size.height / 892);
            return AuthHandler();
          },
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            boldText: false,
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        ),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return LoginScreen();
    } else {
      return SplashScreen();
    }
  }
}
