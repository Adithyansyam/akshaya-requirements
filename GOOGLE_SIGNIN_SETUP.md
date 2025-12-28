# Google Sign-In Setup Guide

## Implementation Complete ?

Google Sign-In authentication has been added to your signup screen. Here's what was implemented:

### Files Modified:
1. **pubspec.yaml** - Added `google_sign_in: ^6.2.1` dependency
2. **lib/services/user_service.dart** - Added `signInWithGoogle()` method
3. **lib/screens/signup_screen.dart** - Added Google sign-up UI button and handler

### Key Features:
- Users can sign up with their Google account
- Automatic Firestore profile creation for Google sign-in users
- Error handling and user feedback
- Loading state indicators

---

## Android Configuration

For Google Sign-In to work on Android, you need to configure your Firebase project:

### Step 1: Get Your Android SHA-1 Certificate Fingerprint

Run the following command in your project directory:

```bash
cd android
./gradlew signingReport
```

Or if you're on Windows:

```bash
cd android
gradlew.bat signingReport
```

Look for the output showing SHA1 fingerprint for your app's signing key. Example:
```
Variant: release
Config: release
Store: /Users/example/.android/keystore
Alias: androiddebugkey
MD5: ...
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
SHA256: ...
```

### Step 2: Add SHA-1 Fingerprint to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project "akshayahub-f7a31"
3. Go to **Project Settings** (gear icon)
4. Select the **Android** app
5. Scroll down to "SHA certificate fingerprints"
6. Click **Add fingerprint**
7. Paste the SHA1 hash you obtained from step 1

### Step 3: Verify Android Manifest

Your `android/app/src/main/AndroidManifest.xml` should already have the necessary permissions. If not, ensure it includes:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Step 4: Download Updated Configuration

After adding the SHA-1 fingerprint:

1. In Firebase Console, download the updated `google-services.json`
2. Replace the file at `android/app/google-services.json`

### Step 5: Sync Gradle

After making changes, run:

```bash
flutter pub get
flutter clean
flutter pub get
```

---

## iOS Configuration (if applicable)

If you plan to support iOS, ensure:

1. Your iOS app is registered in Firebase Console
2. Configure URL schemes in Xcode:
   - Open `ios/Runner.xcworkspace`
   - Select Runner ? Info ? URL Types
   - Add a new URL scheme matching your Firebase Reversed Client ID (found in `GoogleService-Info.plist`)

---

## Testing Google Sign-In

1. Run your app: `flutter run`
2. Navigate to the Sign Up screen
3. Click "Sign Up with Google"
4. Select your Google account
5. Verify that:
   - You're successfully authenticated
   - Your user profile appears in Firestore under `/users/{uid}`
   - Fields include: uid, name, email, phoneNumber, createdAt, updatedAt

---

## Troubleshooting

### Error: "12500 - DEVELOPER_ERROR"
- **Cause**: SHA-1 fingerprint not added to Firebase Console
- **Solution**: Follow Step 1-2 above

### Error: "CANCELLED" or user cancels login
- This is expected behavior when user cancels. The app shows a SnackBar message.

### Google Sign-In button does nothing
- Ensure you ran `flutter pub get` after updating pubspec.yaml
- Verify internet connectivity
- Check that Firebase is properly initialized in main.dart

### User created in Auth but not in Firestore
- Check Firestore rules are correctly deployed (should match firestore.rules file)
- Verify Firestore has write permissions for authenticated users

---

## Code Structure

### UserService Methods:

**signInWithGoogle()** - Handles the complete Google sign-in flow:
1. Prompts user to select Google account
2. Exchanges credentials with Firebase
3. Creates Firestore profile if new user
4. Returns UserCredential

### SignUpScreen Methods:

**_signUpWithGoogle()** - UI handler that:
1. Shows loading indicator
2. Calls UserService.signInWithGoogle()
3. Navigates to HomeScreen on success
4. Shows error SnackBar on failure

---

## Security Notes

? Firestore rules validate all required fields
? User authentication is required for all operations
? Data is stored securely in Firestore
? Phone number is optional for Google sign-in users (empty string if not provided)

---

For more information, visit:
- [Google Sign-In Documentation](https://pub.dev/packages/google_sign_in)
- [Firebase Authentication Docs](https://firebase.flutter.dev/docs/auth/overview)
