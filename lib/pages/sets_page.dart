import 'package:flutter/material.dart';
import 'package:uts_flutter/widgets/item_profil.dart';

class setsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Color.fromARGB(248, 212, 81, 0),
              fontSize: 23,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // elevation: 0,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 240, 242, 236),
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
              child: Column(
                children: [
                  ItemProfil(),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
