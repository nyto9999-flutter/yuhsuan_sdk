import 'package:flutter/material.dart';

class Widgets {
  Widget snackMessage(String message) {
    return ScaffoldMessenger(child: SnackBar(content: Text(message)));
  }
}
