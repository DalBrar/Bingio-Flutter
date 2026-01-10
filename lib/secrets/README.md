File `secrets.dart` should look like the following where `MY_SECRET_KEY-PLATFORM` are the respective platform's Google Firebase API keys:
- NOTE: You can obtain each platform's respective api key by going to `Firebase Console > Project Settings > {platform app}`.

```
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !! DO NOT UPLOAD THIS FILE TO GIT REPO !!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// These are used in "lib/firebase_options.dart"
class GoogleFirebaseApiKeys {
  GoogleFirebaseApiKeys._();
  
  static const String web = 'MY_SECRET_KEY-WEB';
  // Dont forget to copy the android api key into "android/app/google-services.json"
  static const String android = 'MY_SECRET_KEY-ANDROID';
  // Dont forget to copy this ios key into "ios/Runner/GoogleService-info.plist"
  static const String ios = 'MY_SECRET_KEY-IOS';
  // Dont forget to copy this macos key into "macos/Runner/GoogleService-info.plist"
  static const String macos = 'MY_SECRET_KEY-MACOS';
  static const String windows = 'MY_SECRET_KEY-WINDOWS';
}

// Obtained from: https://www.themoviedb.org/settings/api
class MiscApiKeys {
  MiscApiKeys._();

  static const String tmdbApiKey = 'MY_SECRET_TMDB_API_KEY';
}
```
