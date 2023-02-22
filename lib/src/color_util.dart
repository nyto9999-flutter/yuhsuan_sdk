import 'package:flutter/material.dart';

class MyColorUtil {
  // Returns a color that contrasts well with the given color.
  static Color getContrastingColor(Color color) {
    // Counting the perceptive luminance - human eye favors green color...
    double a = 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return a < 0.5 ? Colors.black : Colors.white;
  }

  //return a color that can be darker by a single given percentage
  static Color darkern(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);
    return Color.fromARGB(
      color.alpha,
      (color.red * (1.0 - percentage)).round(),
      (color.green * (1.0 - percentage)).round(),
      (color.blue * (1.0 - percentage)).round(),
    );
  }

  //return a color that can be lighter by a single given percentage
  static Color lightern(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);
    return Color.fromARGB(
      color.alpha,
      (color.red + ((255 - color.red) * percentage)).round(),
      (color.green + ((255 - color.green) * percentage)).round(),
      (color.blue + ((255 - color.blue) * percentage)).round(),
    );
  }

  //return a color that complementary for a given color
  static Color complementary(Color color) {
    return Color.fromARGB(
      color.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }
}
