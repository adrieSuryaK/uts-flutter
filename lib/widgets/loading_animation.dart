import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingAnimationWidget.discreteCircle(
          color: Colors.white,
          secondRingColor: Color.fromARGB(248, 212, 81, 0),
          thirdRingColor: Color.fromARGB(248, 218, 149, 30),
          size: 75,
        ),
      ),
    );
  }
}
