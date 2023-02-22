import 'package:flutter/material.dart';

class ReusableWidgets {
  Widget snackMessage(String message) {
    return ScaffoldMessenger(child: SnackBar(content: Text(message)));
  }

  Widget alertMessage(BuildContext context, String title, String message) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  //create a gradient progress indicator by given two colors and name it as gradientSpinner
  Widget gradientSpinner(Color color1, Color color2) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color1),
        backgroundColor: color2,
      ),
    );
  }

  //create a text within a sizedbox, align center by given required parameters and name it as textSizedBox
  Widget textSizedBox(
      {required String text,
      required double width,
      required double height,
      required double fontSize,
      required Color color}) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
          ),
        ),
      ),
    );
  }
}
