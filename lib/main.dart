import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'hub.dart';
import 'search.dart';
import 'login.dart';
import 'register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Hub(),
        '/search': (context) => Search(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(30, 170, 100, 100),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 94, 73)),
      ),
    );
  }
}
