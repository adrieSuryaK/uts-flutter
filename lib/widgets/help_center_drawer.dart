import 'package:flutter/material.dart';

class HelpCenterDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 28),
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
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color.fromARGB(255, 241, 220, 192),
                          Color.fromARGB(248, 205, 161, 85),
                          Color.fromARGB(248, 218, 149, 30),
                          Color.fromARGB(248, 184, 118, 47),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Help Center',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_center_rounded),
              title: Text('Guides'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.forum_rounded),
              title: Text('Community'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help_rounded),
              title: Text('Help'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.question_answer_rounded),
              title: Text("FAQ's"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.support_agent_rounded),
              title: Text('Support'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.rate_review_rounded),
              title: Text('Feedback'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.verified_rounded),
              title: Text('Terms & Conditions'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock_rounded),
              title: Text('Privacy Policy'),
            ),
          ],
        ),
      ),
    );
  }
}
