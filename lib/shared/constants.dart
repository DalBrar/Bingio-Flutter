import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF050505);
  static const Color shadow = Color(0xFF141414);
  static const Color text = Color(0xFFCDCDCD);
  static const Color hint = Color(0xFF8A8A8A);
  static const Color link = Color(0xFFC8C8FF);
  static const Color active = Color(0xFFA8FFA8);
  static const Color warn = Color(0xFFFFD052);
  static const Color error = Colors.redAccent;
  static const LinearGradient gradient = LinearGradient(
    colors: [Color(0xFFFFC8C8), Color(0xFFC8FFC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppProfileSettings {
  static const List<Color> profileColors = [
    Color.fromARGB(255, 205, 205, 205),
    Color.fromARGB(255, 20, 20, 20),
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
}

class AppStrings {
  static const String appName = 'Bingio';

  static const String alreadyHaveAccount = "Already have an account? ";
  static const String emailLogIn = 'Email Log In';
  static const String emailSentCheckAccount = 'Email sent, please check your account';
  static const String errAccountDisabled = 'Account disabled';
  static const String errAuthenticationExpired = 'Authentication expired';
  static const String errEmailAlreadyInUse = 'Email address already in use';
  static const String errEmailAndPasswordRequired = 'Must provide Email and Password';
  static const String errGoogleCredentialsExpired = 'Credential has expired, try clearing app storage';
  static const String errGoogleSignInCancelled = 'Google Sign In cancelled';
  static const String errGoogleAccountExistsDifferentCredential = 'Account exists with different credential, remove from Google Apps & Services';
  static const String errIncorrectCredentials = 'Incorrect Email or Password';
  static const String errInvalidEmail = 'Invalid email format';
  static const String errMethodNotEnabled = 'This method is not enabled';
  static const String errNameRequired = 'You must enter a name';
  static const String errNetworkConnection = 'Network error, check your connection';
  static const String errPasswordMismatch = 'Passwords do not match';
  static const String errTooManyRequests = 'Too many requests, please wait a bit and try again later';
  static const String errWeakPassword = 'Weak password, password must be at least 6 characters';
  static const String goBack = 'Go Back';
  static const String hintEmail = 'Email';
  static const String hintPassword = 'Password';
  static const String hintPasswordConfirm = 'Confirm Password';
  static const String hintUser = 'User';
  static const String kidsProfile = 'Kids Profile';
  static const String logIn = 'Log In';
  static const String logOut = 'Log Out';
  static const String newProfile = 'New Profile';
  static const String orDashed = '-- OR --';
  static const String pleaseLoginToContinue = 'Please log in to continue.';
  static const String pleaseRegisterToContinue = 'Please register to continue.';
  static const String pleaseVerifyEmail = 'Please verify your email to continue.';
  static const String pleaseWaitBeforeTryAgain = 'Please wait a bit before trying again';
  static const String pressBackAgainToExit = 'Press back again to exit';
  static const String sendVerificationTo = 'Send verification email to';
  static const String signInWithGoogle = 'Sign In with Google';
  static const String signUp = 'Sign Up';
  static const String signUpWithEmail = 'Sign Up with Email';
  static const String switchOn = 'On';
  static const String switchOff = 'Off';
  static const String userProfileBackgroundColor = 'Background Color';
  static const String userProfileCreate = 'Create Profile';
  static const String userProfileDisplayName = 'Display Name';
  static const String userProfileForegroundColor = 'Foreground Color';
  static const String userProfileEdit = 'Edit User Profile';
  static const String userProfileNew = 'New User Profile';
  static const String userProfileProtrait = 'Portrait';
  static const String userProfileSave = 'Save Profile';
  static const String userProfileSaving = 'Saving Profile...';
  static const String welcome = 'Welcome to $appName';
  static const String whosWatching = 'Who\'s binging?';
}

class AppStyles {
  static const TextStyle titleText = TextStyle(
    fontSize: 32,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );

  static const TextStyle title2Text = TextStyle(
    fontSize: 22,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );

  static const TextStyle title3Text = TextStyle(
    fontSize: 19,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );

  static const TextStyle title4Text = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );


  static const TextStyle largeText = TextStyle(
    fontSize: 22,
    color: AppColors.text,
  );

  static const TextStyle mediumText = TextStyle(
    fontSize: 19,
    color: AppColors.text,
  );

  static const TextStyle regularText = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    color: AppColors.hint,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle solidButtonText = TextStyle(
    fontSize: 18,
    color: AppColors.background,
  );

  static const TextStyle solidButtonDisabledText = TextStyle(
    fontSize: 18,
    color: AppColors.hint,
  );


  static ButtonStyle plainTextButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return AppColors.active;
        }
        return Colors.transparent;
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return AppColors.background;
        }
        return AppColors.link;
      },
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    ),
  );

  static ButtonStyle solidButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return AppColors.active;
        }
        return AppColors.link;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ButtonStyle solidButtonDisabledStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        return AppColors.shadow;
      },
    ),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

}

class AppValues {
  static const int maxProfiles = 6;
}
