import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:uts_flutter/widgets/help_center_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uts_flutter/pages/new_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FocusNode focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
                        Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Reset using phone or email',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
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
                        Text(
                          'OR',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        IntlPhoneField(
                          controller: phoneController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Handphone',
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
                          initialCountryCode: 'US',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _sendResetRequest(context);
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        child: Text(
                          'Submit',
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
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        child: Text(
                          'Cancel',
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
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Need help? Visit our"),
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

  Future<void> _sendResetRequest(BuildContext context) async {
    final String email = emailController.text;
    final String phone = phoneController.text;

    if (email.isEmpty && phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email or password must be entered.'),
          backgroundColor: Color.fromARGB(248, 218, 149, 30),
        ),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.7:3005/users?email=$email&phone=$phone'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData != null && responseData['data'] != null) {
        final data = responseData['data'] as List;

        String? userId; // initial null userId

        for (var userData in data) {
          if (userData['email'] == email || userData['handphone'] == phone) {
            userId = userData['id'].toString();
            break;
          }
        }

        if (userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => NewPassword(userId: userId!),
              builder: (context) =>
                  NewPassword(userId: userId ?? 'default_value'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid user data.'),
              backgroundColor: Color.fromARGB(248, 218, 149, 30),
            ),
          );
        }
      } else {
        print('Response Data: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('data does not match.'),
            backgroundColor: Color.fromARGB(248, 218, 149, 30),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reset request.'),
        ),
      );
    }
  }
}
