import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:uts_flutter/widgets/help_center_drawer.dart';

class RegisterPage extends StatelessWidget {
  final FocusNode focusNode = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HelpCenterDrawer(),
      backgroundColor: Colors.transparent,
      body: Container(
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
          children: <Widget>[
            SizedBox(height: 80.0),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 180,
                  child: Lottie.asset('asset/images/ramenaruto.json'),
                ),
                Positioned(
                  right: 95,
                  bottom: -10,
                  child: Container(
                    width: 90,
                    height: 50,
                    child: Image.asset('asset/images/ninjaramen.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white30,
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(35),
                //     topRight: Radius.circular(35),
                //   ),
                // ),
                child: Card(
                  elevation: 1,
                  color: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Enter your details to register',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        RegisterTextField(label: 'Name'),
                        RegisterTextField(label: 'Email Address'),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: IntlPhoneField(
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
                            languageCode: "en",
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ' + country.name);
                            },
                          ),
                        ),
                        RegisterTextField(label: 'Password', isPassword: true),
                        RegisterTextField(
                            label: 'Confirm Password', isPassword: true),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            CheckboxExample(),
                            Text(
                              'I agree with the terms and conditions',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: Text(
                              'Next',
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
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final String label;

  final bool isPassword;

  RegisterTextField({
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextField(
        style: TextStyle(color: Colors.black),
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(248, 138, 73, 3),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    return Checkbox(
      checkColor: Color.fromARGB(248, 138, 73, 3),
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
