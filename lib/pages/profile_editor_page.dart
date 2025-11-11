import 'dart:math';

import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/shared/btn_solid.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:bingio/shared/my_app_bar.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileNotifier extends ChangeNotifier {
  int picNum = 99;
  int bgColor = 0;
  int picColor = 1;
  bool kidsProfile = false;

  void update({int? picNum, int? bgColor, int? picColor, bool? kidsProfile}) {
    if (picNum != null) this.picNum = picNum;
    if (bgColor != null) this.bgColor = bgColor;
    if (picColor != null) this.picColor = picColor;
    if (kidsProfile != null) this.kidsProfile = kidsProfile;
    notifyListeners();
  }
}

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({super.key});

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  static const maxDisplayNameLength = 8;
  final User? user = AuthService().getCurrentUser();
  final TextEditingController txtCntrl = TextEditingController();
  final FocusNode txtFocus = FocusNode();
  final FocusNode picFocus = FocusNode();
  final double vertSpacing = 10;
  final profile = ProfileNotifier();
  bool _isLoading = true;

  late List<FocusWrap> pictureChildren = List.generate(AppProfileSettings.profilePics.length,
    (index) => FocusWrap(
      width: 60,
      height: 60,
      borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
      padding: EdgeInsetsGeometry.all(2),
      borderColor: Colors.transparent,
      onPressSelect: () => profile.update(picNum: index),
      child: Image.asset(AppProfileSettings.profilePics[index]),
    )
  );
  late List<FocusWrap> bgChildren = List.generate(AppProfileSettings.profileColors.length,
    (index) => FocusWrap(
      width: 45,
      height: 45,
      backgroundColor: AppProfileSettings.profileColors[index],
      backgroundColorFocused: AppProfileSettings.profileColors[index],
      onPressSelect: () => profile.update(bgColor: index),
    )
  );
  late List<FocusWrap> picColorChildren = List.generate(AppProfileSettings.profileColors.length,
    (index) => FocusWrap(
      width: 45,
      height: 45,
      backgroundColor: AppProfileSettings.profileColors[index],
      backgroundColorFocused: AppProfileSettings.profileColors[index],
      onPressSelect: () => profile.update(picColor: index),
    )
  );

  bool _isCreateDisabled = false;

  void _randomize() {
    int picNum = Random().nextInt(AppProfileSettings.profilePics.length);
    int bgColor = Random().nextInt(AppProfileSettings.profileColors.length);
    int picColor = Random().nextInt(AppProfileSettings.profileColors.length);
    profile.update(picNum: picNum, bgColor: bgColor, picColor: picColor);
  }

  void _saveProfile(BuildContext context) async {
    if (txtCntrl.text.trim().isEmpty) {
      showAppError('You must enter a name');
      return;
    }

    setState(() {
      _isCreateDisabled = true;
    });
    
    await FirestoreDatabase().createOrUpdate(
      ProfileModel.collection,
      ProfileModel(
        accountUID: user!.uid,
        displayName: txtCntrl.text.trim(),
        bgColor: profile.bgColor,
        picColor: profile.picColor,
        picNumber: profile.picNum,
        kidsProfile: profile.kidsProfile
      ),
      onSuccess: (docId) {
        Navigator.of(context).pop(docId);
      },
      onError: (error) {
        showAppError('Create Profile error: $error');
        setState(() {
          _isCreateDisabled = false;
        });
      }
    );
  }

  void delayedLoad() async {
    await Future.delayed(Duration(seconds: 1));
    _randomize();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    delayedLoad();
  }

  @override
  void dispose() {
    txtFocus.dispose();
    picFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: MyAppBar(hideLogoutButton: true, showBackButton: true,),
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              GradientText(
                text: 'New User Profile',
                style: AppStyles.title2Text,
              ),

              SizedBox(height: vertSpacing),
              Wrap(
                children: [
                  Column(
                    children: [
                      Text(
                        'Kids Profile: ${profile.kidsProfile ? 'On' : 'Off'}',
                        style: AppStyles.regularText,
                      ),
                      ListenableBuilder(
                        listenable: profile,
                        builder: (context, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Switch(
                              value: profile.kidsProfile,
                              activeTrackColor: AppColors.link,
                              activeThumbColor: AppColors.background,
                              inactiveThumbColor: AppColors.background,
                              trackOutlineColor: WidgetStateColor.transparent,
                              focusColor: AppColors.active.withAlpha(125),
                              onChanged: (val) => profile.update(kidsProfile: val),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListenableBuilder(
                    listenable: profile,
                    builder: (context, child) => FocusWrap(
                      autoFocus: true,
                      focusNode: picFocus,
                      onPressSelect: _randomize,
                      padding: EdgeInsetsGeometry.all(0),
                      child: ProfilePic(
                        width: 100,
                        height: 100,
                        bgColor: profile.bgColor,
                        picColor: profile.picColor,
                        picNum: profile.picNum,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Display Name:',
                        style: AppStyles.regularText,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 170,
                          height: 50,
                          child: InputField(
                            controller: txtCntrl,
                            focusNode: txtFocus,
                            nextFocus: picFocus,
                            hintText: 'User',
                            textInputType: TextInputType.name,
                            autofillHints: [],
                            style: AppStyles.title2Text,
                            onChanged: (val) { txtCntrl.text = val.substring(0, min(val.length, maxDisplayNameLength)); },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: vertSpacing),
              Text(
                'Portrait:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: pictureChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                'Background Color:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: bgChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                'Foreground Color:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: picColorChildren,
              ),

              SizedBox(height: vertSpacing),
              Wrap(
                children: [
                  SolidBtn(
                    text: _isCreateDisabled ? 'Saving Profile...' : 'Create Profile',
                    onPressed: () => _saveProfile(context),
                    isDisabled: _isCreateDisabled,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}