import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  static const List<Color> profileColors = [
    Color.fromARGB(255, 205, 205, 205),
    Color.fromARGB(255, 5, 5, 5),
    Color.fromARGB(255, 244, 67, 54),
    Color.fromARGB(255, 76, 175, 80),
    Color.fromARGB(255, 33, 150, 243),
    Color.fromARGB(255, 255, 193, 7),
    Color.fromARGB(255, 255, 64, 129),
    Color.fromARGB(255, 96, 125, 139),
    Color.fromARGB(255, 124, 77, 255),
    Color.fromARGB(255, 121, 85, 72),
  ];

  static const List<String> profilePics = [
    'assets/images/profile_pic_m1.png',
    'assets/images/profile_pic_m2.png',
    'assets/images/profile_pic_m3.png',
    'assets/images/profile_pic_w1.png',
    'assets/images/profile_pic_w2.png',
    'assets/images/profile_pic_w3.png',
  ];

  final int bgColor;
  final int picColor;
  final int picNum;
  final double? width;
  final double? height;

  const ProfilePic({
    super.key,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = profileColors[(this.bgColor < 10) ? this.bgColor : 0];
    final picColor = profileColors[(this.picColor < 10) ? this.picColor : 1];
    final picture = (picNum < 6) ? profilePics[picNum] : 'assets/images/profile_new.png';

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: bgColor,
      ),
      child: ShaderMask(
        blendMode: BlendMode.modulate,
        shaderCallback: (rect) => LinearGradient(
          colors: [picColor, picColor]
        ).createShader(rect),
        child: Image.asset(picture),
      ),
    );
  }
  
}