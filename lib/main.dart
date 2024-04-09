import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'hub.dart';
import 'login.dart';
import 'register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UWUApp());
}

class UWUApp extends StatelessWidget {
  const UWUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UWU App',
      initialRoute: '/login',
      routes: {
        '/': (context) => const Hub(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(30, 170, 100, 100),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 170, 112, 89),
          selectedItemColor: Color.fromARGB(255, 94, 57, 46),
          unselectedItemColor: Color.fromARGB(255, 212, 162, 150),
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 94, 73)),
      ),
    );
  }
}
