import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: _isLoading ? 0 : 100,
                height: _isLoading ? 0 : 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(248, 212, 81, 0),
                  shape: BoxShape.circle,
                ),
                child: _isLoading
                    ? Container()
                    : Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      )),
            SizedBox(
              height: 16,
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Text(
                    'Payment Succesfully',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(248, 212, 81, 0),
                    ),
                  ),
            SizedBox(height: 24),
            _isLoading
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Home');
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: Text(
                        'UAS Done',
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
    );
  }
}
