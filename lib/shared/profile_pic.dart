import 'package:bingio/shared/constants.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final int bgColor;
  final int picColor;
  final int picNum;
  final double? width;
  final double? height;

  ProfilePic({
    super.key,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    this.width,
    this.height,
  });

  final _colorSize = AppProfileSettings.profileColors.length;
  final _picsSize = AppProfileSettings.profilePics.length;

  @override
  Widget build(BuildContext context) {
    final bgColor = AppProfileSettings.profileColors[(this.bgColor < _colorSize) ? this.bgColor : 0];
    final picColor = (picNum < _picsSize) ? (AppProfileSettings.profileColors[(this.picColor < _colorSize) ? this.picColor : 1]) : AppColors.hint;
    final picture = (picNum < _picsSize) ? AppProfileSettings.profilePics[picNum] : 'assets/images/profile_new.png';

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [bgColor, bgColor.withAlpha(0)]
            )
          ),
        ),
        SizedBox(
          width: width,
          height: height,
          child: ShaderMask(
            blendMode: BlendMode.modulate,
            shaderCallback: (rect) => LinearGradient(
              colors: [picColor, picColor]
            ).createShader(rect),
            child: Image.asset(picture),
          ),
        ),
      ],
    );
  }
  
}