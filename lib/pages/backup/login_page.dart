import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   toolbarHeight: 70,
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff5b0060),
                  Color(0xff870160),
                  Color(0xffac255e),
                  Color(0xffca485c),
                  Color(0xffe16b5c),
                  Color(0xfff39060),
                  Color.fromARGB(255, 255, 196, 136),
                  Color.fromARGB(255, 255, 221, 186),
                  Color.fromARGB(255, 248, 241, 233),
                  // Color.fromRGBO(254, 242, 229, 1),
                  // Color.fromRGBO(255, 251, 247, 1),
                ],
                tileMode: TileMode.mirror,
              ),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(35),
              //   topRight: Radius.circular(35),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 70.0),
                FlutterLogo(
                  size: 100.0,
                ),
                Card(
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
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 78, 56),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Colors.black,
                            //   ),
                            //   borderRadius: BorderRadius.circular(20),
                            // ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            // fillColor: Colors.white10,
                            // filled: true,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            Text(
                              'Forgot username?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //
                              },
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 78, 56),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: Colors.black,
                                //   ),
                                //   borderRadius: BorderRadius.circular(20),
                                // ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                // fillColor: Colors.white10,
                                // filled: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            Text(
                              'Forgot password?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
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
                    Navigator.pushNamed(context, 'Home');
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 246, 78, 56)),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
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
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    horizontalLine(),
                    Text(
                      'Login with',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    horizontalLine()
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Image.asset('asset/images/google.png'),
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: Image.asset('asset/images/facebook.png'),
                      onPressed: () {
                        // Handle Facebook login
                      },
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
                        // Handle "Help center" action
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
                SizedBox(height: 70.0),
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
        width: 100,
        height: 1.0,
        color: Color(0xff1f005c).withOpacity(.2),
      ),
    );
