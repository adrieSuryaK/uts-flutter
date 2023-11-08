import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_flutter/pages/homepage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  final int initialIndex;
  UserPage({this.initialIndex = 2});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
          'My Profile',
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "setsPage");
              },
              child: Icon(
                Icons.settings,
                size: 32,
                color: Color.fromARGB(248, 212, 81, 0),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 700,
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
          child: userData.isEmpty
              ? CircularProgressIndicator() // Loading
              : Column(
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'http://192.168.1.5:3000/images/${userData['photo']}',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    // buildInfoCard("Photo", userData['photo'] ?? ''),
                    buildInfoCard("Name", userData['name'] ?? ''),
                    buildInfoCard("Username", userData['username'] ?? ''),
                    buildInfoCard("Email", userData['email'] ?? ''),
                    buildInfoCard("Handphone", userData['handphone'] ?? ''),
                    SizedBox(height: 30.0),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return HomePage();
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
            case 1:
              //
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

  Widget buildInfoCard(String label, String value) {
    if (value.isNotEmpty) {
      return Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    label == "Name"
                        ? Icons.person_rounded
                        : label == "Username"
                            ? Icons.verified_rounded
                            : label == "Email"
                                ? Icons.mail_rounded
                                : Icons.phone_rounded,
                    size: 20,
                    color: Color.fromARGB(248, 212, 81, 0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
