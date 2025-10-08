import 'package:flutter/material.dart';
import 'package:profio/core/helpers/global_helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../services/AuthService.dart';
import '../../../services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptPolicy = false;
  bool _isLoading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate() || !_acceptPolicy) {
      return;
    }

    try {
      // Simulate API call
      if(_emailController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Please enter email.")),
        );
      }
      else if(_passwordController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Please enter password.")),
        );
      }
      else{
        setState(() => _isLoading = true);

        // Show loader dialog
        GlobalHelper().progressDialog(context,"Signing In","Signing you in, please wait...");
        final user = await _authService.signUpWithEmailPassword(_emailController.text, _passwordController.text);
        if (user != null) {
         // String? idToken = await user.getIdToken(); //
         // print("checkToken:${idToken} --- ${user.uid}");
          var result = await userRegister(_emailController.text, user.uid);
          if(result){
            if (!mounted) return;
            Navigator.pop(context); // close loader
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ Signup successful!")),
            );
          }else{
            Navigator.pop(context); // close loader
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ Signup register failed")),
            );
          }

        } else {
          if (!mounted) return;
          Navigator.pop(context); // close loader
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Signup failed")),
          );
        }


      }



    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Signup failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    Navigator.pushReplacementNamed(context, '/login');
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset('assets/log.png',height: 100,),
              Text(
                  localeProvider.getText(key: 'appname'),
                  style: themeProvider.isDarkMode ? AppText.headlineLarge.copyWith(color: Colors.green): AppText.headlineLarge.copyWith(color: Colors.green)
              ),
              const SizedBox(height: 16),
              Text(
                  localeProvider.getText(key: 'create_account'),
                  style: themeProvider.isDarkMode ? AppText.bodyMedium.copyWith(color: Colors.green): AppText.bodyMedium.copyWith(color: Colors.green)
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: localeProvider.getText(key: 'full_name'),
                  prefixIcon: const Icon(Icons.account_circle_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localeProvider.getText(key: 'email'),
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value == null || !value.contains("@") ? "Invalid email" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localeProvider.getText(key: 'password'),
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value != null && value.length < 6 ? "Min 6 chars" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localeProvider.getText(key: 'reenter_password'),
                  prefixIcon: const Icon(Icons.password_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value != _passwordController.text ? "Passwords don’t match" : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _acceptPolicy,
                    onChanged: (val) {
                      setState(() => _acceptPolicy = val ?? false);
                    },
                  ),
                  Expanded(
                    child: Text(
                        localeProvider.getText(key: 'accept_privacy'),
                        style: themeProvider.isDarkMode ? AppText.bodyMedium.copyWith(color: Colors.green): AppText.bodyMedium.copyWith(color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isLoading ? null : _signup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(localeProvider.getText(key: 'signup')),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
