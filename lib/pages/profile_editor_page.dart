import 'dart:math';

import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/shared/app_toast.dart';
import 'package:bingio/shared/button_solid.dart';
import 'package:bingio/shared/button_widget.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
import 'package:bingio/shared/input_field.dart';
import 'package:bingio/shared/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({super.key});

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  final User? user = AuthService().getCurrentUser();
  final TextEditingController txtCntrl = TextEditingController();
  final FocusNode txtFocus = FocusNode();
  final double vertSpacing = 10;

  List<WidgetButton> get pictureChildren => AppProfileSettings.profilePics.asMap().entries.map((entry) {
    return WidgetButton(
      width: 80,
      height: 50,
      borderColor: AppColors.shadow,
      borderRadius: 0,
      child: Image.asset(entry.value),
      onPressSelect: () {
        setState(() {
          _picNum = entry.key;
        });
      },
    );
  }).toList();
  List<WidgetButton> get bgChildren => AppProfileSettings.profileColors.asMap().entries.map((entry) {
    return WidgetButton(
      width: 50,
      height: 50,
      backgroundColor: entry.value,
      backgroundColorFocused: entry.value,
      borderColor: AppColors.shadow,
      onPressSelect: () {
        setState(() {
          _bgColor = entry.key;
        });
      },
    );
  }).toList();
  List<WidgetButton> get picColorChildren => AppProfileSettings.profileColors.asMap().entries.map((entry) {
    return WidgetButton(
      width: 50,
      height: 50,
      backgroundColor: entry.value,
      backgroundColorFocused: entry.value,
      borderColor: AppColors.shadow,
      onPressSelect: () {
        setState(() {
          _picColor = entry.key;
        });
      },
    );
  }).toList();

  bool _isCreateDisabled = false;
  bool _kidsProfile = false;
  int _bgColor = 0;
  int _picColor = 1;
  int _picNum = 99;

  void _randomize() {
    setState(() {
      _bgColor = Random().nextInt(AppProfileSettings.profileColors.length);
      _picColor = Random().nextInt(AppProfileSettings.profileColors.length);
      _picNum = Random().nextInt(AppProfileSettings.profilePics.length);
    });
  }

  void _saveProfile(BuildContext context) async {
    setState(() {
      _isCreateDisabled = true;
    });
    await FirestoreDatabase().createOrUpdate(
      ProfileModel.collection,
      ProfileModel(
        accountUID: user!.uid,
        displayName: txtCntrl.text.trim(),
        bgColor: _bgColor,
        picColor: _picColor,
        picNumber: _picNum,
        kidsProfile: _kidsProfile
      ),
      onSuccess: () => Navigator.of(context).pop(),
      onError: (error) {
        showAppError('Create Profile error: $error');
        setState(() {
          _isCreateDisabled = false;
        });
      }
    );
  }

  @override
  void initState() {
    super.initState();
    txtCntrl.text = 'New User';
    _randomize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              SizedBox(height: vertSpacing * 2),
              GradientText(
                text: 'New User Profile',
                style: AppStyles.title2Text,
              ),

              SizedBox(height: vertSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Kids Profile:',
                        style: AppStyles.regularText,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: Switch(
                            value: _kidsProfile,
                            activeTrackColor: AppColors.link,
                            activeThumbColor: AppColors.background,
                            inactiveThumbColor: AppColors.background,
                            trackOutlineColor: WidgetStateColor.transparent,
                            onChanged: (val) => setState(() {
                              _kidsProfile = val;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  WidgetButton(
                    autoFocus: true,
                    onPressSelect: _randomize,
                    child: ProfilePic(
                      width: 100,
                      height: 100,
                      bgColor: _bgColor,
                      picColor: _picColor,
                      picNum: _picNum,
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
                            hintText: 'Display Name',
                            textInputType: TextInputType.name,
                            autofillHints: [],
                            style: AppStyles.title2Text,
                            onChanged: (val) => setState((){ txtCntrl.text = val.substring(0, 8); }),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pictureChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                'Background Color:',
                style: AppStyles.regularText,
              ),
              Row(
                children: bgChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                'Foreground Color:',
                style: AppStyles.regularText,
              ),
              Row(
                children: picColorChildren,
              ),

              SizedBox(height: vertSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SolidButton(text: _isCreateDisabled ? 'Saving Profile...' : 'Create Profile', onPressed: () => _isCreateDisabled ? null : _saveProfile(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}