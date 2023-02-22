//code generate by github copilot
import 'package:flutter/material.dart';

class Homie {
  //create a jumping ball by using animation controller
  Widget jumpingBall(
      {required AnimationController controller,
      required double size,
      required Color color}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, controller.value * 100),
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  //create given shape object which can be dragged by using gesture detector, and name it as draggableObject
  Widget draggableObject(
      {required Widget child,
      required double width,
      required double height,
      required double left,
      required double top}) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: (details) {
          left += details.delta.dx;
          top += details.delta.dy;
        },
        child: Container(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }

  //create a search bar by using text field, textcontroller with a icon at the left, and name it as searchBar
  Widget searchBar(
      {required TextEditingController controller,
      required String hintText,
      required IconData icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
