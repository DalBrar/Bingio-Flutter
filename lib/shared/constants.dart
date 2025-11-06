import 'package:flutter/material.dart';

class APPCOLORS {
  static const Color background = Color(0xFF050505);
  static const Color text = Color(0xFFCDCDCD);
  static const Color hint = Color(0xFF8A8A8A);
  static const Color link = Color(0xFFC8C8FF);
  static const Color active = Color(0xFFA8FFA8);
  static const LinearGradient gradient = LinearGradient(
    colors: [Color(0xFFFFC8C8), Color(0xFFC8FFC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class APPSTYLES {
  static const TextStyle titleText = TextStyle(
    fontSize: 32,
    color: APPCOLORS.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );

  static const TextStyle regularText = TextStyle(
    fontSize: 16,
    color: APPCOLORS.text,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    color: APPCOLORS.hint,
    fontStyle: FontStyle.italic,
  );

  static ButtonStyle plainTextButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return APPCOLORS.active;
        }
        return Colors.transparent;
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return APPCOLORS.background;
        }
        return APPCOLORS.link;
      },
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    ),
  );

  static const TextStyle solidButtonText = TextStyle(
    fontSize: 18,
    color: APPCOLORS.background,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle solidButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return APPCOLORS.active;
        }
        return APPCOLORS.link;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

}

class STRINGS {
  static const String appName = 'Bingio';
}