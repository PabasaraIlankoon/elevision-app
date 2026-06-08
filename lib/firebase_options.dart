// Minimal stub for DefaultFirebaseOptions to allow local builds
// Replace these values with real Firebase project configuration

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
      );
}
