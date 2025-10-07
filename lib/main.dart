
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/auth/login_page.dart';
import 'features/home/presentation/auth/sign_up.dart';
import 'features/home/presentation/home/home_page.dart';
import 'features/services/AuthService.dart';
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
      home: isLoggedIn ? const HomePage(parentPageId: 0,) :const LoginPage(),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(parentPageId: 0,),
        '/SignUp':(context) => const SignupPage(),
      },
    );
  }
}
