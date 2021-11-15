# Profile App

Flutter Project
- An App where user can upload their profiles and can also see other user's profile. 
- User can change his/her profile later on if requires. Profile include details like name,college,
courses etc. 
- App has following functionalities :
  - mobile number verification process for authentication. Use of Firebase OTP Auth.
  - Firebase RealTime Database to store user's data.
  - Firebase Storage to store user's picked image from gallery for profile.
  
## Preview
  

https://user-images.githubusercontent.com/69047076/141852016-b8654e73-d4ea-49e9-a865-d1c957e8671a.mov

  

## Flutter and Firebase Setup
1. Follow the installation instructions on www.flutter.io to install Flutter.
2. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
3. Once your Firebase instance is created, you'll need to enable phone authentication.
   - Go to the Firebase Console for your new instance.
   - Click "Authentication" in the left-hand menu
   - Click the "sign-in method" tab
   - Click "phone" and enable it
4. Next, click "Realtime Database" in the left-hand menu. Create a real-time database and start in test mode. Click "Enable".
5. Finally, click "Storage" in the left-hand menu. Enable it.

## Android Setup

1. Create an app within your Firebase instance for Android, with package name 
   com.example.profile_view_app
3. Follow instructions to download google-services.json, and place it into profile_view_app/android/app/
4. Run the following command to get your SHA-1 key:
      `keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android`
4. In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
5. This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

## 👍 Run the App
