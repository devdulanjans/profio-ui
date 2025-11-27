

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../services/AuthService.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  Future<void> resetPassword(String email,LocaleProvider local) async {
    setState(() {
      isLoading = true;
    });
    final result = await _authService.resetPassword(email);
    setState(() {
      isLoading = false;
    });
    if(result){
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(getText('password_reset_success',local)),
          backgroundColor: Colors.green,
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(getText('password_reset_failed',local)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String getText(String title,LocaleProvider local){
    return local.getText(key: title);
  }


  @override
  Widget build(BuildContext context) {


    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);



    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode? Colors.black:Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: Icon(
              Icons.arrow_back_ios,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black
          ),
        ),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_reset,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
               Text(localeProvider.getText(key: 'reset_password'),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: themeProvider.isDarkMode ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 10),
              Text(localeProvider.getText(key: 'enter_receive_email'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: localeProvider.getText(key: 'email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    final email = emailController.text.trim();
                    if (email.isNotEmpty) {
                      resetPassword(email,localeProvider);
                      emailController.text = "";

                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localeProvider.getText(key: 'please_email')),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(localeProvider.getText(key: 'send_reset_link'),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }



}