import 'dart:math';

import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/shared/btn_input_field.dart';
import 'package:bingio/shared/btn_solid.dart';
import 'package:bingio/shared/focus_wrap.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
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
  final String? profileId;

  const ProfileEditorPage({
    super.key,
    this.profileId
  });

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  static const double paddingSpace = 2;
  static const double colorPalletSize = 45;
  final User? user = AuthService().getCurrentUser();
  final TextEditingController txtCntrl = TextEditingController();
  final FocusNode txtFocus = FocusNode();
  final FocusNode picFocus = FocusNode();
  final double vertSpacing = 10;
  final profile = ProfileNotifier();
  bool _isLoading = true;

  late List<FocusWrap> picPortraitChildren = List.generate(AppProfileSettings.profilePics.length,
    (index) => FocusWrap(
      width: 60,
      height: 60,
      borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
      padding: EdgeInsetsGeometry.all(paddingSpace),
      borderColor: Colors.transparent,
      onPressSelect: () => profile.update(picNum: index),
      child: Image.asset(AppProfileSettings.profilePics[index]),
    )
  );
  late List<FocusWrap> bgColorChildren = List.generate(AppProfileSettings.profileColors.length,
    (index) => FocusWrap(
      width: colorPalletSize,
      height: colorPalletSize,
      padding: EdgeInsetsGeometry.all(paddingSpace),
      borderRadius: BorderRadius.circular(50),
      onPressSelect: () => profile.update(bgColor: index),
      child: 
        Container(
          width: colorPalletSize,
          height: colorPalletSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [AppProfileSettings.profileColors[index], AppProfileSettings.profileColors[index].withAlpha(0)]
            )
          ),
        ),
    )
  );
  late List<FocusWrap> picColorChildren = List.generate(AppProfileSettings.profileColors.length,
    (index) => FocusWrap(
      width: 45,
      height: 45,
      padding: EdgeInsetsGeometry.all(paddingSpace),
      borderRadius: BorderRadius.circular(50),
      onPressSelect: () => profile.update(picColor: index),
      child: 
        Container(
          width: colorPalletSize,
          height: colorPalletSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppProfileSettings.profileColors[index],
          ),
        ),
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
      showAppError(AppStrings.errNameRequired);
      return;
    }

    setState(() {
      _isCreateDisabled = true;
    });
    
    await FirestoreDB().createOrUpdate(
      ProfileModel.collection,
      ProfileModel(
        id: widget.profileId,
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
        showAppError('Save Profile error: $error');
        setState(() {
          _isCreateDisabled = false;
        });
      }
    );
  }

  void delayedLoad() async {
    await Future.delayed(Duration(seconds: 1));
    if (widget.profileId != null) {
      final model = await FirestoreDB().getDocById(
        collection: ProfileModel.collection,
        docId: widget.profileId!,
        fromMap: ProfileModel.fromMap,
        onError: (error) {
          showAppError('${AppStrings.errTryingToGet} Profile, Id: ${widget.profileId}');
        },
      );

      if (model == null && mounted) Navigator.of(context).pop(widget.profileId);
      final p = model!;
      profile.update(
        picNum: p.picNumber,
        bgColor: p.bgColor,
        picColor: p.picColor,
        kidsProfile: p.kidsProfile
      );
      txtCntrl.text = p.displayName;
    } else {
      _randomize();
    }
    
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
    txtCntrl.dispose();
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
      appBar: MyAppBar(hideLogoutButton: true, showGoBackButton: true),
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              GradientText(
                text: (widget.profileId == null) ? AppStrings.userProfileNew : AppStrings.userProfileEdit,
                style: AppStyles.title2Text,
              ),

              SizedBox(height: vertSpacing),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: ListenableBuilder(
                        listenable: profile,
                        builder: (context, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${AppStrings.kidsProfile}: ${profile.kidsProfile ? AppStrings.switchOn : AppStrings.switchOff}',
                                style: AppStyles.regularText,
                              ),
                              SizedBox(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.center,
                      child: ListenableBuilder(
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
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: Column(
                        children: [
                          Text(
                            '${AppStrings.userProfileDisplayName}:',
                            style: AppStyles.regularText,
                          ),
                          InputFieldBtn(
                            width: 165,
                            height: 50,
                            textController: txtCntrl,
                            focusNode: txtFocus,
                            hintText: AppStrings.hintUser,
                            textInputType: TextInputType.name,
                            autofillHints: [],
                            maxLength: 8,
                            style: AppStyles.title3Text,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: vertSpacing),
              Text(
                '${AppStrings.userProfileProtrait}:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: picPortraitChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                '${AppStrings.userProfileBackgroundColor}:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: bgColorChildren,
              ),

              SizedBox(height: vertSpacing),
              Text(
                '${AppStrings.userProfileForegroundColor}:',
                style: AppStyles.regularText,
              ),
              Wrap(
                children: picColorChildren,
              ),

              SizedBox(height: vertSpacing),
              Wrap(
                children: [
                  SolidBtn(
                    text: _isCreateDisabled ? AppStrings.userProfileSaving : ((widget.profileId == null) ? AppStrings.userProfileCreate : AppStrings.userProfileSave),
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