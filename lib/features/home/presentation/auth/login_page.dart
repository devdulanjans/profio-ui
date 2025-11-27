import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/helpers/global_helper.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../services/AuthService.dart';
import '../../../services/api_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../services/service_helper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final GoogleAuthService _googleAuth = GoogleAuthService();
    final AuthService _authService = AuthService();
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    _email.text = "profiotest@gmail.com";
    _password.text = "abcd1234";

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
                          GlobalHelper().progressDialog(context,"Signing In","Signing you in, please wait...");
                          final user = await _authService.signInWithEmailPassword(_email.text, _password.text);
                          if (user != null) {
                            await getUserDetails();
                            print("CheckUserObject:${user} - ${ServiceHelper.isProfileCompleted }");
                            Navigator.pop(context); // close loader
                            Navigator.pushReplacementNamed(context, '/home');
                          }else{
                            Navigator.pop(context); // close loader
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ Login failed")),
                            );
                          }

                        }

                      },
                      child: Text(localeProvider.getText(key: 'login')),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print('clicked');
                          Navigator.pushNamed(context, '/forget_password');
                        },
                        child: Text(localeProvider.getText(key: 'forget_password')),
                      ),
                    ],
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
                        backgroundColor: WidgetStateProperty.all<Color>(
                            themeProvider.isDarkMode?Colors.white:Colors.black), // Set background color to black

                      ),
                      onPressed: () async{
                        final UserCredential? user = await _googleAuth.signInWithGoogle();
                        if (user != null) {
                          GlobalHelper().progressDialog(context,"Google signing in","Signing you in, please wait...");
                          Map<String,dynamic> apiUser = await getUserByUUIDFromDb(user.user?.uid ?? "") ?? {};

                          //new user not registered yet
                          if(apiUser.toString() == "{}"){
                            var result = await userRegister(user.user?.email ?? "", user.user?.uid ?? "");
                            if(result != ""){
                              var subScribeLng = await subScribeLanguage(result,"ja"); // assume default setup en and manually adding ja this need to be change based on requirement
                              await getUserDetails();
                              Navigator.pop(context); // close loader
                              Navigator.pushReplacementNamed(context, '/home');
                            }else{
                              Navigator.pop(context); // close loader
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("❌ Google sign in register failed")),
                              );
                            }
                          }else{
                            // already registered
                            await getUserDetails();
                            Navigator.pop(context); // close loader
                            Navigator.pushReplacementNamed(context, '/home');
                          }


                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("❌ Google sign in failed")),
                          );
                        }


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

Future<void> getUserDetails() async{
  Map<String,dynamic> user = await getUserByUUID() ?? {};
  var userName = (user['name'] ?? {}).toString();
  var phoneNumber = user['phoneNumber'] ?? "";
  if(userName == "{}" || phoneNumber == ""){
    await storeProfileCompleteStatus(false);

  }else{
    await storeProfileCompleteStatus(true);
  }
  await ServiceHelper.init();
  print("CheckProfileStatus:${ServiceHelper.isProfileCompleted}");
}
