import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uts_flutter/pages/suksesPage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uts_flutter/widgets/loading_animation.dart';

class pinPage extends StatefulWidget {
  @override
  _pinPageState createState() => _pinPageState();
}

class _pinPageState extends State<pinPage> {
  String enteredPin = '';
  bool showSpinner = false;

  void _handlePinButtonPress(String digit) {
    if (enteredPin.length < 4) {
      setState(() {
        enteredPin += digit;
      });
    }

    if (enteredPin.length == 4) {
      setState(() {
        // showSpinner = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LoadingAnimation();
          },
        );
      });

      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
        setState(() {
          showSpinner = false;
        });
      });
    }
  }

  void _handleClearButtonPress() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Security Code',
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Container(
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'INSERT SECURITY CODE:',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                Text(
                  enteredPin,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('1'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('2'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('3'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('4'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('5'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('6'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('7'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('8'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('9'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 95,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPinButton('0'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: _buildClearButton(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinButton(String digit) {
    return ElevatedButton(
      onPressed: () => _handlePinButtonPress(digit),
      child: Text(
        digit,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(248, 212, 81, 0),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(25),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: _handleClearButtonPress,
      child: Icon(
        CupertinoIcons.delete_left,
        color: Color.fromARGB(248, 212, 81, 0),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(248, 212, 81, 0),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
