Files `secrets.dart` should look like the following where `MY_SECRET_KEY-PLATFORM` are the respective platform's Google Firebase API keys:
- NOTE: You can obtain each platform's respective api key by going to `Firebase Console > Project Settings > {platform app}`.

```
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !! DO NOT UPLOAD THIS FILE TO GIT REPO !!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

class GoogleFirebaseApiKeys {
  static const String web = 'MY_SECRET_KEY-WEB';
  // Dont forget to copy the android api key into "android/app/google-services.json"
  static const String android = 'MY_SECRET_KEY-ANDROID';
  static const String ios = 'MY_SECRET_KEY-IOS';
  static const String macos = 'MY_SECRET_KEY-MACOS';
  static const String windows = 'MY_SECRET_KEY-WINDOWS';
}
```
