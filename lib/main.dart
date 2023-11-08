import 'package:flutter/material.dart';
import 'package:uts_flutter/pages/login_page.dart';
import 'package:uts_flutter/pages/register_page.dart';
import 'package:uts_flutter/pages/forgot_username_page.dart';
import 'package:uts_flutter/pages/reset_username_page.dart';
import 'package:uts_flutter/pages/forgot_password_page.dart';
// import 'package:uts_flutter/pages/newPassword.dart';
import 'package:uts_flutter/pages/homepage.dart';
import 'package:uts_flutter/pages/user_page.dart';
import 'package:uts_flutter/pages/timeline_page.dart';
import 'package:uts_flutter/pages/sets_page.dart';
import 'package:flutter/services.dart';
import 'package:uts_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(248, 138, 73, 3),
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme:
              AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)),
      home: LoginPage(), //ThemeData
      routes: {
        // "/": (context) => HomePage(),
        "Login": (context) => LoginPage(),
        "Register": (context) => RegisterPage(),
        "Forgot Username": (context) => ForgotUsernamePage(),
        "Reset Username": (context) => ResetUsernamePage(),
        "Forgot Password": (context) => ForgotPasswordPage(),
        // "New Password": (context) => NewPassword(),
        "Home": (context) => HomePage(),
        "Timeline": (context) => TimelinePage(),
        "Profile": (context) => UserPage(),
        "setsPage": (context) => setsPage(),
      },
    ); //MaterialApp
  }
}
