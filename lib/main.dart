import 'dart:io';
import 'package:chat_app/screen/auth_screen.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBNfc4T3W0zkCxzs688dI1-R7V4I0sKZXA',
              appId: '1:568668884475:android:e8ef1fbe3c2e50babf0f5e',
              messagingSenderId: '568668884475',
              projectId: 'newprojectchat-d4c46'))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: snapshot.connectionState != ConnectionState.done
            ? const SplashScreen()
            : StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (userSnapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            })
          );
        });
  }
}
