import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/services/preferences_service.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/exit_on_back_catcher.dart';
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

  void getSelectedProfile() async {
    final sp = await PrefsService.getSelectedProfile();
    setState(() { _selectedProfile = sp; });
  }

  Future<void> setSelectedProfile(String? profileID) async {
    await PrefsService.setSelectedProfile(profileID);
    setState(() {
      _selectedProfile = profileID;
    });
  }

  void createNewUser() async {
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

  @override
  void initState() {
    super.initState();
    loadingSpinnerHide();
    getSelectedProfile();
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
    return ExitOnBackCatcher(
      child: Scaffold(
        appBar: MyAppBar(hideLogoutButton: false),
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
                StreamBuilder(
                  stream: FirestoreDatabase().streamDocsByUID<ProfileModel>(ProfileModel.collection, user!.uid, ProfileModel.keyAccountUID, ProfileModel.fromMap),
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
                          setSelectedProfile(profile.id!);
                        },
                        onDelete: () {
                          FirestoreDatabase().delete(
                            ProfileModel.collection,
                            profile.id!,
                            onSuccess: () async { await setSelectedProfile(null); showAppToast('Profile deleted!'); },
                            onError: (error) => showAppError('Profile delete error $error')
                          );
                        },
                      );
                    }).toList();
            
                    if (profiles.length < AppValues.maxProfiles) {
                      children.add(ProfileCard(
                        key: ValueKey('newprofile'),
                        name: 'New Profile',
                        bgColor: 1,
                        picColor: 0,
                        picNum: 99,
                        autoFocus: _selectedProfile == null,
                        focusNode: newUserNode,
                        onPressed: createNewUser,
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
