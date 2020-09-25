import 'package:auction_handler/game_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'ranking.dart';
import 'account.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            routes: {
              '/login': (context) => LoginPage(title: 'Ready'),
              '/game': (context) => MyHomePage(title: 'Game'),
              '/ranking': (context) => Ranking(),
              '/account': (context) => Account(),
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: LoginPage(title: 'Something Went Wrong'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            routes: {
              '/login': (context) => LoginPage(title: 'Ready'),
              '/game': (context) => MyHomePage(title: 'Game'),
              '/ranking': (context) => Ranking(),
              '/account': (context) => Account(),
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: LoginPage(title: 'Ready'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          routes: {
            '/login': (context) => LoginPage(title: 'Ready'),
            '/game': (context) => MyHomePage(title: 'Game'),
            '/ranking': (context) => Ranking(),
            '/account': (context) => Account(),
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(title: 'Loading'),
        );
      },
    );
  }
}
