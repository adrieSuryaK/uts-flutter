import 'package:flutter/material.dart';

class payButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "Total:",
                //   style: TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                // Text(
                //   "\Rp.00",
                //   style: TextStyle(
                //     fontSize: 25,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF4C53A5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Menggunakan Navigator untuk berpindah ke halaman PIN
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => pinPage()));
                },
                child: Text(
                  "Pay Now",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
