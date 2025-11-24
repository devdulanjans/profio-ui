
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'features/home/presentation/auth/login_page.dart';
import 'features/home/presentation/auth/sign_up.dart';
import 'features/home/presentation/home/home_page.dart';
import 'features/services/AuthService.dart';
import 'features/services/api_service.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AuthService _authService = AuthService();
    bool isLoggedIn = _authService.isAlreadyLoggedIn();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: isLoggedIn && isProfileCompleted ? const HomePage(parentPageId: 0,) :(isLoggedIn && !isProfileCompleted ? const HomePage(parentPageId: 101,) :const LoginPage()),
      initialRoute: isLoggedIn ? '/home' : '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/SignUp':
            return MaterialPageRoute(builder: (_) => const SignupPage());
          case '/home':
          // Evaluate condition at runtime
            log("CheckRoute:${isLoggedIn} -- ${isProfileCompleted}");
            if (isProfileCompleted) {
              return MaterialPageRoute(
                builder: (_) => const HomePage(parentPageId: 0),
              );
            }
            else if(!isProfileCompleted) {
              return MaterialPageRoute(
                builder: (_) => const HomePage(parentPageId: 101),
              );
            }
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
      // routes: {
      //   '/login': (context) => const LoginPage(),
      //   '/home': (context) => isLoggedIn && isProfileCompleted ? const HomePage(parentPageId: 0,) : (const HomePage(parentPageId: 101,)),
      //   '/SignUp':(context) => const SignupPage(),
      // },
    );
  }
}



