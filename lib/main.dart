
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/auth/login_page.dart';
import 'features/home/presentation/auth/sign_up.dart';
import 'features/home/presentation/home/home_page.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(parentPageId: 0,),
        '/SignUp':(context) => const SignupPage(),
      },
    );
  }
}
