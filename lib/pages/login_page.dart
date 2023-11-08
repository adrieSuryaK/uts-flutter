import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:uts_flutter/widgets/help_center_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:uts_flutter/widgets/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final usernameController = TextEditingController();
final passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        saveUsername(username);
        savePassword(password);
        print('username');
        print(username);
        print('password');
        print(password);
        Navigator.pushNamed(context, 'Home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Login failed, please check your username and password again.'),
          backgroundColor: Color.fromARGB(248, 218, 149, 30),
        ));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  void savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HelpCenterDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  Color.fromARGB(248, 138, 73, 3),
                  Color.fromARGB(248, 201, 146, 87),
                  Color.fromARGB(249, 255, 234, 127),
                  Color.fromARGB(248, 138, 73, 3),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 60.0),
                // Container(
                //   height: 140,
                //   width: 140,
                //   // decoration: BoxDecoration(
                //   //     color: Color.fromARGB(249, 255, 234, 127),
                //   //     borderRadius: BorderRadius.circular(70)),
                //   // child: Center(
                //   //   child: Lottie.asset('assets/images/ramenaruto.json'),
                //   // ),
                //   child: Center(
                //     child: Image.asset('assets/images/ninjaramen.png'),
                //   ),
                // ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 180,
                      child: Lottie.asset('assets/images/ramenaruto.json'),
                    ),
                    Positioned(
                      right: 95,
                      bottom: -10,
                      child: Container(
                        width: 90,
                        height: 50,
                        child: Image.asset('assets/images/ninjaramen.png'),
                      ),
                    ),
                  ],
                ),

                Card(
                  elevation: 1,
                  margin: EdgeInsets.all(30.0),
                  color: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          controller: usernameController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(248, 138, 73, 3),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'Forgot Username');
                              },
                              child: Text(
                                'Forgot username?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            TextField(
                              controller: passwordController,
                              style: TextStyle(color: Colors.black),
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(248, 138, 73, 3),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'Forgot Password');
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    login(context, usernameController.text,
                        passwordController.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(248, 137, 87, 33),
                          Color.fromARGB(248, 205, 161, 85),
                          Color.fromARGB(248, 218, 149, 30),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account ?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'Register');
                      },
                      child: Text(
                        ' Register ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text("or continue with"),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    horizontalLine(),
                    IconButton(
                      iconSize: 40,
                      icon: Image.asset('assets/images/google.png'),
                      onPressed: () async {
                        try {
                          final user = await UserController.loginWithGoogle();
                          if (user != null) {
                            final nameFromGoogle =
                                UserController.user?.displayName ?? '';
                            final emailFromGoogle =
                                UserController.user?.email ?? '';
                            final username =
                                UserController.user?.displayName ?? '';
                            final passwordFromGoogle =
                                'please fill in password';
                            final photo = UserController.user?.photoURL ?? '';
                            final handphoneFromGoogle =
                                'please fill in handphone';

                            // save SharedPreferences
                            saveUsername(username);

                            //post
                            await postUserData(
                                nameFromGoogle,
                                emailFromGoogle,
                                username,
                                passwordFromGoogle,
                                photo,
                                handphoneFromGoogle);

                            Navigator.pushNamed(context, 'Home');
                          }
                          ;
                        } on FirebaseAuthException catch (error) {
                          print(error.message);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            error.message ?? "Something went wrong",
                          )));
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            error.toString(),
                          )));
                        }
                      },
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: Image.asset('assets/images/facebook.png'),
                      onPressed: () {
                        // Handle Facebook login
                      },
                    ),
                    horizontalLine()
                  ],
                ),
                SizedBox(height: 60.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Need help? Visit our",
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Text(
                        ' Help center ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 80,
        height: 1.0,
        color: Color.fromARGB(249, 255, 234, 127),
      ),
    );

//post google data to our server
Future<void> postUserData(
    String nameFromGoogle,
    String emailFromGoogle,
    String username,
    String passwordFromGoogle,
    String photoURL,
    String handphoneFromGoogle) async {
  try {
    var dio = Dio();
    var response = await dio.get(photoURL,
        options: Options(responseType: ResponseType.bytes));

    if (response.statusCode == 200) {
      // get photo from download
      final photoBytes = response.data;

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.1.5:3000/users'));
      request.fields['name'] = nameFromGoogle;
      request.fields['email'] = emailFromGoogle;
      request.fields['username'] = username;
      request.fields['password'] = passwordFromGoogle;
      request.fields['handphone'] = handphoneFromGoogle;

      if (photoBytes != null) {
        request.files.add(http.MultipartFile.fromBytes('photo', photoBytes,
            filename: 'photo.jpg'));
      }

      var httpResponse = await request.send();

      if (httpResponse.statusCode == 200) {
        print('Google data is successfully stored on the server.');
        // print(nameFromGoogle);
        // print(emailFromGoogle);
      } else {
        print('Google data failed to be saved on the server.');
      }
    } else {
      print('failed to download image.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
