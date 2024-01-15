import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final IconData icon;

  CategoryWidget({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30.0,
            color: Color.fromARGB(248, 212, 81, 0),
          ),
        ),
      ),
    );
  }
}

class SmallCategoryWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  SmallCategoryWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      child: Column(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(248, 212, 81, 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
