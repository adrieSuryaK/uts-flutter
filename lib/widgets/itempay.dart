import 'package:flutter/material.dart';

class ItemPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Text(
            "PAYMENT METHODS",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        for (int i = 1; i < 5; i++)
          Container(
            height: 80,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Radio(
                  value: "",
                  groupValue: "",
                  activeColor: Color.fromARGB(248, 212, 81, 0),
                  onChanged: (index) {},
                ),
                Container(
                  height: 90,
                  width: 90,
                  margin: EdgeInsets.only(right: 15),
                  child: Image.asset("assets/payment/$i.png"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
