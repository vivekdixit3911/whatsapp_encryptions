import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/pages/chatscreen.dart';
import 'firebase_options.dart';
import 'pages/loginscreen.dart';
import 'pages/registerscreen.dart';
import 'pages/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 178, 193, 203),
      ),
      initialRoute: welcomeScreen.id,
      routes: {
        welcomeScreen.id: (context) => const welcomeScreen(),
        registerpage.id: (context) => const registerpage(),
        loginscreen.id: (context) => const loginscreen(),
        chatscreen.id: (context) => const chatscreen(),
      },
    );
  }
}
