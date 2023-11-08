import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:uts_flutter/pages/timeline_page.dart';
import 'package:uts_flutter/pages/user_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_flutter/widgets/user_controller.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  HomePage({this.initialIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.5:3000/users/$username'),
      );

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        setState(() {
          userData = userDataJson["data"];
        });
      } else {
        //
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Homepage',
          style: TextStyle(
            color: Color.fromARGB(248, 212, 81, 0),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Cari...",
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.search_rounded,
                        size: 27, color: Color.fromARGB(248, 212, 81, 0)),
                  ],
                ),
              ),
              CircleAvatar(
                foregroundImage:
                    NetworkImage(UserController.user?.photoURL ?? ''),
              ),
              Text(UserController.user?.displayName ?? ''),
              Text(UserController.user?.email ?? ''),
              Text(UserController.user?.phoneNumber.toString() ?? ''),
              Text(UserController.user?.toString() ?? ''),
              // Display user data
              // userData.isEmpty
              //     ? CircularProgressIndicator()
              //     : Column(
              //         children: [
              //           CircleAvatar(
              //             radius: 50,
              //             backgroundImage: NetworkImage(
              //               'http://192.168.1.5:3000/images/${userData['photo']}',
              //             ),
              //           ),
              //           Text("Name: ${userData['name']}"),
              //           Text("Email: ${userData['email']}"),
              //           Text("Username: ${userData['username']}"),
              //           Text("Handphone: ${userData['handphone']}"),
              //         ],
              //       ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return TimelinePage();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return UserPage();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              break;
          }
        },
        height: 70,
        backgroundColor: Color.fromARGB(249, 255, 234, 127),
        color: Color.fromARGB(248, 138, 73, 3),
        buttonBackgroundColor: Color.fromARGB(248, 212, 81, 0),
        items: [
          Icon(
            Icons.home_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.timeline_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_rounded,
            size: 30,
            color: Colors.white,
          ),
        ],
        index: widget.initialIndex,
      ),
    );
  }
}
