import 'package:bingio/pages/home_page.dart';
import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/services/preferences_service.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/on_back_catcher.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/my_app_bar.dart';
import 'package:bingio/shared/profile_card.dart';
import 'package:bingio/pages/profile_editor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  final User? user = AuthService().getCurrentUser();
  final FocusNode newUserNode = FocusNode();
  final Map<String, FocusNode> cardFocusNodes = {};
  String? _selectedProfile;

  void loadSelectedProfile() async {
    final sp = await PrefsService.getSelectedProfile();
    _selectedProfile = sp;
  }

  Future<void> setSelectedProfile(String? profileId) async {
    _selectedProfile = profileId;
    await PrefsService.setSelectedProfile(profileId);
    setState(() {
      _selectedProfile = profileId;
    });
  }

  Future<void> loadProfile(String profileId, String profileName) async {
    loadingSpinnerShow(context);
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(profileId: profileId, profileName: profileName))
    ).then((returnValue) async {
      loadingSpinnerHide();
    });
  }

  void createNewProfile() async {
    loadingSpinnerShow(context);
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditorPage())
    ).then((returnValue) async {
      await setSelectedProfile(returnValue);
      loadingSpinnerHide();
    });
  }

  void editProfile(String profileId) async {
    loadingSpinnerShow(context);
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditorPage(profileId: profileId))
    ).then((returnValue) async {
      loadingSpinnerHide();
    });
  }

  void deleteProfile(String profileId, String profileName) {
    showYesNoDialog(
      context: context,
      title: AppStrings.dialogConfirmDelete,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${AppStrings.dialogAboutToDeleteA} $profileName${AppStrings.dialogAboutToDeleteB}\n'),
          Text(AppStrings.dialogAboutToDeleteC, style: TextStyle(color: AppColors.warn)),
        ],
      ),
      onYes: () {
        FirestoreDB().delete(
          ProfileModel.collection,
          profileId,
          onSuccess: () async { await setSelectedProfile(null); showAppToast('Profile deleted!'); },
          onError: (error) => showAppError('Profile delete error $error')
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    loadingSpinnerHide();
    loadSelectedProfile();
  }

  @override
  void dispose() {
    newUserNode.dispose();
    for (final node in cardFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackCatcher(
      onBack: (ctx){},
      child: Scaffold(
        appBar: MyAppBar(hideLogoutButton: false),
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  AppStrings.whosWatching,
                  style: AppStyles.title2Text,
                ),
                SizedBox(height: 50),
                StreamBuilder(
                  stream: FirestoreDB().streamDocsByKey<ProfileModel>(
                    collection: ProfileModel.collection,
                    whereKey: ProfileModel.keyAccountUID,
                    matchingValue: user!.uid,
                    fromMap: ProfileModel.fromMap
                  ),
                  builder:(context, snapshot) {
                    if (snapshot.data == null) return CircularProgressIndicator();
                    final profiles = snapshot.data?.toList() ?? List.empty();
                    profiles.sort((a,b) => a.displayName.compareTo(b.displayName));

                    final children = profiles.map((profile) {
                      // Create and track FocusNodes
                      cardFocusNodes.putIfAbsent(profile.id!, () => FocusNode());

                      return ProfileCard(
                        key: ValueKey(profile.id),
                        name: profile.displayName,
                        bgColor: profile.bgColor,
                        picColor: profile.picColor,
                        picNum: profile.picNumber,
                        autoFocus: profile.id == _selectedProfile,
                        focusNode: cardFocusNodes[profile.id],
                        showOptions: true,
                        onPressed: () {
                          loadProfile(profile.id!, profile.displayName);
                        },
                        onEdit: () => editProfile(profile.id!),
                        onDelete: () => deleteProfile(profile.id!, profile.displayName),
                      );
                    }).toList();
            
                    if (profiles.length < AppValues.maxProfiles) {
                      children.add(ProfileCard(
                        key: ValueKey('newprofile'),
                        name: AppStrings.newProfile,
                        bgColor: 1,
                        picColor: 0,
                        picNum: 99,
                        autoFocus: _selectedProfile == null,
                        focusNode: newUserNode,
                        onPressed: createNewProfile,
                      ));
                    }
            
                    return Wrap(
                      children: children,
                    );
                  },
                ),
              ]
            ),
          )
        ),
      ),
    );
  }
}
