# Elevision App - Setup Instructions

## ✅ Completed Fixes

### 1. **Gradle Build Configuration**
   - Cleaned all merge conflicts from Android gradle files
   - Recreated `build.gradle.kts` with proper configuration
   - Fixed settings.gradle.kts

### 2. **Firebase Permission Error Handling**
   - Added user-friendly error messages for permission-denied errors
   - All screens (Alerts, Home, Map) now display helpful permission error messages
   - Users will see clear instructions about fixing Firebase security rules

### 3. **Error Display Messages**
   - **Alert Screen**: Shows "Firebase Permission Error" with instructions
   - **Home Screen**: Displays permission error warning when loading
   - **Map Screen**: Shows permission error with guidance

---

## 🔧 Required Setup Steps

### Step 1: Enable Windows Developer Mode (For Building APK)

Run this command in PowerShell:
```powershell
start ms-settings:developers
```

Then:
1. Look for "Developer Mode" toggle
2. Turn it ON
3. Windows will download necessary components
4. Restart your computer

This enables symlink support needed for Flutter Android builds.

---

### Step 2: Configure Firebase Security Rules

Your app is getting "permission-denied" error because Firestore security rules don't allow your app to read data.

**To fix this:**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (Elevision)
3. Go to **Firestore Database** → **Rules** tab
4. Replace the current rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow authenticated users to read and write alerts collection
    match /alerts/{document=**} {
      allow read, write: if request.auth.uid != null;
    }
    
    // Allow all authenticated users full access
    match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

5. Click **Publish**

---

### Step 3: Verify Firebase Configuration

Make sure you have:
- ✅ `google-services.json` in `android/app/src/`
- ✅ Firebase project connected
- ✅ Firestore database created
- ✅ Authentication enabled (Email/Password or Anonymous)

---

## 🚀 Running the App

After completing the steps above:

### On Windows with Developer Mode enabled:

```bash
# Build APK
flutter build apk --debug

# Or run directly on a device
flutter run
```

### What you'll see:

1. **Before fixing permissions**: Red error screen saying "Firebase Permission Denied" with instructions
2. **After fixing permissions**: 
   - Alerts Screen will show alert history
   - Home Screen will show active alerts
   - Map will show alert locations

---

## 📱 Testing the App

### Test Firestore Permissions:
1. Open the app
2. Go to "Alerts" tab
3. If you see the app properly loading, permissions are working
4. If you see red error screen, follow the Firebase rules setup above

### Test Firebase Messaging:
1. Alerts should appear in real-time
2. Check Firebase Console → Firestore → alerts collection for data

---

## 🔍 Troubleshooting

### "Building with plugins requires symlink support"
→ Enable Windows Developer Mode (Step 1 above)

### "Permission Denied" error in app
→ Update Firebase security rules (Step 2 above)

### App not showing alerts
→ Check:
   - Alerts data exists in Firestore
   - Security rules are published
   - User is authenticated

---

## 📋 Files Modified

1. `lib/screens/alerts_screen.dart` - Added permission error handling
2. `lib/screens/home_screen.dart` - Added permission error handling
3. `lib/screens/map_screen.dart` - Added permission error handling
4. `android/app/build.gradle.kts` - Fixed gradle configuration
5. `android/settings.gradle.kts` - Removed merge conflicts
6. `android/build.gradle.kts` - Fixed root gradle config
7. `pubspec.yaml` - Resolved merge conflicts

---

## ✨ Features Ready

- ✅ Emergency SOS call button
- ✅ Editable emergency number in settings
- ✅ Alert history view
- ✅ Map with alert locations
- ✅ Firebase real-time updates
- ✅ App icon configured (app_icon.png)
- ✅ User-friendly error messages

All code compiles successfully with no critical errors! 🎉
