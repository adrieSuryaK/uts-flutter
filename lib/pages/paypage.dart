import 'package:flutter/material.dart';
import 'package:uts_flutter/widgets/itempay.dart';
import 'package:uts_flutter/widgets/paybar.dart';
import 'package:uts_flutter/widgets/paybutton.dart';
import 'package:uts_flutter/pages/pinpage.dart';

class payPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            color: Color.fromARGB(248, 212, 81, 0),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
      ),
      body: ListView(
        children: [
          Container(
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
              children: [
                ItemPay(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => pinPage()));
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
                      'Pay Now',
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
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: payButton(),
    );
  }
}
