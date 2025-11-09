import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
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
    final bgColor = AppProfileSettings.profileColors[(this.bgColor < 10) ? this.bgColor : 0];
    final picColor = AppProfileSettings.profileColors[(this.picColor < 10) ? this.picColor : 1];
    final picture = (picNum < 6) ? AppProfileSettings.profilePics[picNum] : 'assets/images/profile_new.png';

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