import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:uts_flutter/widgets/help_center_drawer.dart';
import 'dart:async'; //delayed

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController handphoneController = TextEditingController();
  bool agreeToTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    handphoneController.dispose();
    super.dispose();
  }

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
            SizedBox(height: 40.0),
            Expanded(
              child: Container(
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
                        SizedBox(height: 20.0),
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
                        RegisterTextField(
                            label: 'Name', controller: nameController),
                        RegisterTextField(
                            label: 'Email Address',
                            controller: emailController),
                        RegisterTextField(
                            label: 'Username', controller: usernameController),
                        RegisterTextField(
                            label: 'Password',
                            isPassword: true,
                            controller: passwordController),
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
                            controller: handphoneController,
                            initialCountryCode: 'ID',
                          ),
                        ),
                        Container(
                          child: _image == null
                              ? ElevatedButton(
                                  onPressed: () async {
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    setState(() {
                                      if (pickedFile != null) {
                                        _image = File(pickedFile.path);
                                      } else {
                                        print('No image selected');
                                      }
                                    });
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
                                      'Select Image',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0.0),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
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
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Image.file(_image!, fit: BoxFit.cover),
                                ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              checkColor: Color.fromARGB(248, 138, 73, 3),
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                return Colors.white;
                              }),
                              value: agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  agreeToTerms = value ?? false;
                                });
                              },
                            ),
                            Text(
                              'I agree with the terms and conditions',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            if (agreeToTerms) {
                              _uploadDataToServer();
                            } else {
                              print('Please agree to terms and conditions');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Please agree to terms and conditions'),
                                backgroundColor:
                                    Color.fromARGB(248, 218, 149, 30),
                              ));
                            }
                          },
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

  Future<void> _uploadDataToServer() async {
    String serverUrl = 'http://192.168.1.7:3005/users';

    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.fields['name'] = nameController.text;
    request.fields['email'] = emailController.text;
    request.fields['username'] = usernameController.text;
    request.fields['password'] = passwordController.text;
    request.fields['handphone'] = handphoneController.text;
    request.fields['agreed_to_terms'] = agreeToTerms.toString();

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data uploaded successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data upload successfully.'),
          backgroundColor: Color.fromARGB(248, 218, 149, 30),
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    } else {
      print('Data upload failed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please complete your personal data.'),
        backgroundColor: Color.fromARGB(248, 218, 149, 30),
      ));
    }
  }
}

class RegisterTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  RegisterTextField({
    required this.label,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextField(
        style: TextStyle(color: Colors.black),
        obscureText: isPassword,
        controller: controller,
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
