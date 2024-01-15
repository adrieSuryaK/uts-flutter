import 'package:flutter/material.dart';
import 'package:uts_flutter/pages/homepage.dart';
import 'package:uts_flutter/pages/user_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_flutter/pages/homepage_admin.dart';

class TimelinePage extends StatelessWidget {
  final int initialIndex;
  TimelinePage({this.initialIndex = 1});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Timeline',
          style: TextStyle(
            color: Color.fromARGB(248, 212, 81, 0),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // elevation: 0,
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
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(35),
            //   topRight: Radius.circular(35),
            // ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final username = prefs.getString('username') ?? "";

          switch (index) {
            case 0:
              if (username.toLowerCase() == 'admin') {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return HomePageAdmin();
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
              } else {
                Navigator.pushReplacement(
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
              }
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
        backgroundColor: Colors.white,
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
        index: initialIndex,
      ),
    );
  }
}
