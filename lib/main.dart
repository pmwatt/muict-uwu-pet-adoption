import 'package:flutter/material.dart';
import 'hub.dart';

void main() => runApp(const UWUApp());

class UWUApp extends StatelessWidget {
  const UWUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UWU App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Hub(),
        // '/search': (context) => const Search(),
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
