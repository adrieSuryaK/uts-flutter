import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uts_flutter/pages/login_page.dart';
import 'package:uts_flutter/pages/register_page.dart';
import 'package:uts_flutter/pages/forgot_username_page.dart';
import 'package:uts_flutter/pages/reset_username_page.dart';
import 'package:uts_flutter/pages/forgot_password_page.dart';
// import 'package:uts_flutter/pages/newPassword.dart';
import 'package:uts_flutter/pages/homepage.dart';
import 'package:uts_flutter/pages/homepage_admin.dart';
import 'package:uts_flutter/pages/user_page.dart';
import 'package:uts_flutter/pages/timeline_page.dart';
import 'package:uts_flutter/pages/sets_page.dart';
import 'package:flutter/services.dart';
import 'package:uts_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:uts_flutter/pages/detail_menu.dart';
import 'package:uts_flutter/pages/shoping_cart_page.dart';
import 'package:uts_flutter/pages/paypage.dart';
import 'package:uts_flutter/pages/splash_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(248, 138, 73, 3),
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Platform.isAndroid
  //     ? await Firebase.initializeApp(
  //         options: FirebaseOptions(
  //           apiKey: "AIzaSyDWJk7KNl0Db3qk1908GVAm01uFKl2hRqM",
  //           appId: "1:465417672785:android:d89d6d666d741aa918c070",
  //           messagingSenderId: "465417672785",
  //           projectId: "uts-flutter-51dfc",
  //         ),
  //       )
  //     : await Firebase.initializeApp();
  FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // get documentSnapshot => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme:
              AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)),
      home: SplashScreen(), //ThemeData
      routes: {
        // "/": (context) => HomePage(),
        "Login": (context) => LoginPage(),
        "Register": (context) => RegisterPage(),
        "Forgot Username": (context) => ForgotUsernamePage(),
        "Reset Username": (context) => ResetUsernamePage(),
        "Forgot Password": (context) => ForgotPasswordPage(),
        // "New Password": (context) => NewPassword(),
        "Home": (context) => HomePage(),
        "Home Admin": (context) => HomePageAdmin(),
        "Timeline": (context) => TimelinePage(),
        "Profile": (context) => UserPage(),
        "setsPage": (context) => setsPage(),
        "payPage": (context) => payPage(),
      },
    ); //MaterialApp
  }
}
