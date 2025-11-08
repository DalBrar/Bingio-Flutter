import 'package:bingio/services/preferences_service.dart';
import 'package:bingio/shared/app_toast.dart';
import 'package:bingio/shared/button_widget.dart';
import 'package:bingio/shared/exit_on_back_catcher.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:bingio/shared/responsive_text.dart';
import 'package:flutter/material.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  String? selectProfile;

  void setSelectedProfile(String profileID) async {
    await PrefsService.setSelectedProfile(profileID);
  }

  void initSelectedProfile() async {
    String? sp = await PrefsService.getSelectedProfile();
    setState(() {
      selectProfile = sp;
    });
  }

  @override
  void initState() {
    super.initState();
    initSelectedProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ExitOnBackCatcher(
      child: Scaffold(
        appBar: AppBar(
          title: GradientText(text: AppStrings.appName),
          centerTitle: true,
          backgroundColor: AppColors.background,
        ),
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Who\'s binging?',
                  style: AppStyles.title2Text,
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileCard(
                      name: 'Dal',
                      bgColor: 2,
                      picColor: 9,
                      picNum: 0,
                      autoFocus: (selectProfile == 'Dal'),
                      onPressed: () => showAppToast('Dal pressed!'),
                    ),
                    ProfileCard(
                      name: 'New User',
                      bgColor: 1,
                      picColor: 0,
                      picNum: 99,
                      autoFocus: (selectProfile == null),
                      onPressed: () => showAppToast('new user pressed!'),
                    ),
                  ],
                )
              ]
            ),
          )
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final int bgColor;
  final int picColor;
  final int picNum;
  final VoidCallback onPressed;
  final bool autoFocus;

  const ProfileCard({
    super.key,
    required this.name,
    required this.bgColor,
    required this.picColor,
    required this.picNum,
    required this.onPressed,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: WidgetButton(
        autoFocus: autoFocus,
        onPressed: onPressed,
        child: SizedBox(
          width: 80,
          height: 122,
          child: Column(
            children: [
              SizedBox(height: 10),
              ProfilePic(
                bgColor: bgColor,
                picColor: picColor,
                picNum: picNum,
              ),
              ResponsiveText(
                text: name,
                style: AppStyles.title2Text,
              )
            ],
          ),
        ),
      ),
    );
  }
}