import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/language_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase already initialized or error: $e');
  }
  await NotificationService().initialize();

  // Load saved language
  final langService = LanguageService();
  await langService.loadSaved();

  runApp(ElevisionApp(langService: langService));
}

class ElevisionApp extends StatelessWidget {
  final LanguageService langService;
  const ElevisionApp({super.key, required this.langService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider.value(value: langService), // ← add this
      ],
      child: Consumer<LanguageService>(
        builder: (context, lang, _) {
          return MaterialApp(
            title: 'Elevision',
            debugShowCheckedModeBanner: false,
            locale: Locale(lang.language),
            supportedLocales: const [
              Locale('en'),
              Locale('si'),
            ],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1F2937),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: GoogleFonts.notoSansSinhala().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: const Color(0xFF1F2937),
                elevation: 0,
                titleTextStyle: GoogleFonts.notoSansSinhala(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansSinhala(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              textTheme: GoogleFonts.notoSansSinhalaTextTheme(
                ThemeData.light().textTheme,
              ).copyWith(
                titleLarge: GoogleFonts.notoSansSinhala(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
                bodyLarge: GoogleFonts.notoSansSinhala(
                  fontSize: 16,
                  color: const Color(0xFF4B5563),
                ),
                bodyMedium: GoogleFonts.notoSansSinhala(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
            home: Consumer<AuthService>(
              builder: (context, auth, _) {
                if (auth.isLoggedIn) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
