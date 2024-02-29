import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'hub.dart';
import 'search.dart';
import 'login.dart';
import 'register.dart';
import 'organizationDetails.dart';

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
        '/search': (context) => Search(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/organization': (context) => AdoptionCentreDetailsPage(
            animalName: 'Doggo Demo',
            imageUrl:
                'https://images.unsplash.com/photo-1561566828-2035bacf3d86?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            species: 'Demo Species',
            breed: 'German Sheperd',
            age: '8',
            description: 'lorem ipsum',
            adoptionCentreName: 'Pet Adoption 2',
            phone: '081234567',
            email: 'adoption@gmail.com',
            website: 'www.adoption.com'),
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
