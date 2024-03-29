import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/screens/SplashScreen.dart';
import 'package:flutterfire/screens/auth.dart';
import 'package:flutterfire/screens/home.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/auth': (context) => AuthPage(),
      },
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? Home() : SplashScreen(),
    );
  }
}
