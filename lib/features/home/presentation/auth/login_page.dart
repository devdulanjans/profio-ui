import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_text.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../services/AuthService.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AuthService _authService = AuthService();
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    _email.text = "profio1@gmail.com";
    _password.text = "abcd1234!";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode? Colors.black:Colors.white,
        // title: Text(localeProvider.getText(key: 'login'),style: themeProvider.isDarkMode ? AppText.headlineLarge: AppText.headlineLarge.copyWith(color: Colors.blue)),
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Container(
              padding: const EdgeInsets.all(8.0), // Optional padding
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black, // Adjust border color as needed
                  width: 1.0, // Adjust border width as needed
                ),
                borderRadius: BorderRadius.circular(10.0), // Optional: for rounded corners
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    RotationTransition(turns: animation, child: child),
                child: themeProvider.isDarkMode
                    ? const Icon(Icons.dark_mode, key: ValueKey("dark"))
                    : Icon(Icons.light_mode, key: ValueKey("light"), color: themeProvider.isDarkMode ? Colors.white:Colors.black),
              ),
            ),
          ),
          // Language toggle
          IconButton(
            onPressed: () => localeProvider.toggleLanguage(),
            icon: Container(
              padding: const EdgeInsets.all(8.0), // Optional padding
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black, // Adjust border color as needed
                  width: 1.0, // Adjust border width as needed
                ),
                borderRadius: BorderRadius.circular(10.0), // Optional: for rounded corners
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  localeProvider.currentLanguage == AppLanguage.english
                      ? "EN"
                      : "JP",
                  key: ValueKey(localeProvider.currentLanguage),
                  style: themeProvider.isDarkMode ? AppText.bodyMedium.copyWith(color: Colors.green): AppText.bodyMedium.copyWith(color: Colors.green),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/log.png',width: 100,),
                  Text(
                    localeProvider.getText(key: 'appname'),
                    style: themeProvider.isDarkMode ? AppText.headlineLarge.copyWith(color: Colors.green): AppText.headlineLarge.copyWith(color: Colors.green)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localeProvider.getText(key: 'signin'),
                    style: themeProvider.isDarkMode ? AppText.bodyMedium:AppText.bodyMedium.copyWith(color: Colors.green),
                  ),
                  const SizedBox(height: 32),

                  // Email TextField
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: localeProvider.getText(key: 'email'),
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: localeProvider.getText(key: 'password'),
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        if(_email.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("⚠️ Please enter email.")),
                          );
                        }else if(_password.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("⚠️ Please enter password.")),
                          );
                        }else{
                          final user = await _authService.signInWithEmailPassword(_email.text, _password.text);
                          if (user != null) {
                            print("CheckUserObject:${user}");
                            Navigator.pushReplacementNamed(context, '/home');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ Login failed")),
                            );
                          }

                        }

                      },
                      child: Text(localeProvider.getText(key: 'login')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: Text(localeProvider.getText(key: 'orsigninwith')),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            themeProvider.isDarkMode?Colors.white:Colors.black), // Set background color to black

                      ),
                      onPressed: () {

                      },
                      child: Text(localeProvider.getText(key: 'googleauth'),style: themeProvider.isDarkMode ? AppText.bodyMedium.copyWith(color: Colors.green):AppText.bodyMedium.copyWith(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      print('clicked');
                      Navigator.pushReplacementNamed(context, '/SignUp');
                    },
                    child: Text(localeProvider.getText(key: 'signupmessage')),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
