import 'package:bingio/services/auth_service.dart';
import 'package:bingio/services/firestore/firestore_database.dart';
import 'package:bingio/services/firestore/models/profile_model.dart';
import 'package:bingio/services/preferences_service.dart';
import 'package:bingio/shared/functions.dart';
import 'package:bingio/shared/exit_on_back_catcher.dart';
import 'package:bingio/shared/constants.dart';
import 'package:bingio/shared/gradient_text.dart';
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
  void dispose() {
    newUserNode.dispose();
    super.dispose();
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
                StreamBuilder(
                  stream: FirestoreDatabase().streamDocsByUID<ProfileModel>(ProfileModel.collection, user!.uid, ProfileModel.keyAccountUID, ProfileModel.fromMap),
                  builder:(context, snapshot) {
                    final profiles = snapshot.data?.toList() ?? List.empty();
                    profiles.sort((a,b) => a.displayName.compareTo(b.displayName));
                    
                    final children = profiles.map((profile) {
                      return ProfileCard(
                        name: profile.displayName,
                        bgColor: profile.bgColor,
                        picColor: profile.picColor,
                        picNum: profile.picNumber,
                        onPressed: () {
                          profile.bgColor = 5;
                          profile.picColor = 4;
                          FirestoreDatabase().createOrUpdate(ProfileModel.collection, profile, onSuccess: () => showAppToast('Update success!'), onError: (error) => showAppError('Update error $error'));
                        },
                        onLongPressed: () {
                          FirestoreDatabase().delete(ProfileModel.collection, profile.id!, onSuccess: () => showAppToast('Delete success!'), onError: (error) => showAppError('Delete error $error'));
                        },
                      );
                    }).toList();
            
                    if (profiles.length < 5) {
                      children.add(ProfileCard(
                        name: 'New User',
                        bgColor: 1,
                        picColor: 0,
                        picNum: 99,
                        focusNode: newUserNode,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditorPage()));
                        },
                        onLongPressed: () => AuthService().logOut(),
                      ));
                    }
            
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
