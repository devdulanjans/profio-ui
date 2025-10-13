import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/helpers/global_helper.dart';
import '../../../../providers/locale_provider.dart';
import '../../../services/AuthService.dart';
import '../home/home_page.dart';

class SettingsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    void pageNavigatorEngine(String selectedPage) {
      switch (selectedPage) {
        case 'Profile':
        // Navigate to Profile page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 101)),
          );
          break;
        case 'Subscription':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 100)),
          );
          break;
        case 'Language':
        // Navigate to Language settings
          break;
        case 'Notification':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 102)),
          );
          break;
        case 'Privacy':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 103)),
          );
          break;
        case 'Help & Support':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 104)),
          );
          break;
        case 'About Us':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 105)),
          );
          break;
        case 'Terms of Service':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(parentPageId: 103)),
          );
          break;
        case 'Light Mode':
        // Handle Light Mode toggle
          break;
        case 'Language Toggle':
        // Handle Language Toggle
          break;
        default:
        // Handle unknown cases
          break;
      }
    }

    final localeProvider = Provider.of<LocaleProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    print("localeProvider: $localeProvider");
    final List<Map<String, dynamic>> settings = [
      {
        'titleKey': localeProvider.getText(key: 'account'),
        'subtopics': [
          {
            'title': localeProvider.getText(key: 'profile'),
            'subTitle': localeProvider.getText(key: 'profile_subtitle'),
          },
          {
            'title': localeProvider.getText(key: 'subscription'),
            'subTitle': localeProvider.getText(key: 'subscription_subtitle'),
          },
        ],
      },
      {
        'titleKey': localeProvider.getText(key: 'preference'),
        'subtopics': [
          {
            'title': localeProvider.getText(key: 'language'),
            'subTitle': localeProvider.getText(key: 'language_subtitle'),
          },
          {
            'title': localeProvider.getText(key: 'notification'),
            'subTitle': localeProvider.getText(key: 'notification_subtitle'),
          },
          {
            'title': localeProvider.getText(key: 'privacy'),
            'subTitle': localeProvider.getText(key: 'privacy_subtitle'),
          },
        ],
      },
      {
        'titleKey': localeProvider.getText(key: 'support'),
        'subtopics': [
          {
            'title': localeProvider.getText(key: 'help_support'),
            'subTitle': localeProvider.getText(key: 'help_support_subtitle'),
          },
        ],
      },
      {
        'titleKey': localeProvider.getText(key: 'about'),
        'subtopics': [
          {
            'title': localeProvider.getText(key: 'about_us'),
            'subTitle': localeProvider.getText(key: 'about_us_subtitle'),
          },
          {
            'title': localeProvider.getText(key: 'terms_of_service'),
            'subTitle': localeProvider.getText(key: 'terms_of_service_subtitle'),
          },
        ],
      },
      {
        'titleKey': localeProvider.getText(key: 'appearance'),
        'subtopics': [
          {
            'title': localeProvider.getText(key: 'dark_mode'),
            'subTitle': localeProvider.getText(key: 'dark_mode_subtitle'),
          },
          {
            'title': localeProvider.getText(key: 'language_toggle'),
            'subTitle': localeProvider.getText(key: 'language_toggle_subtitle'),
          },
        ],
      },
      {
        'titleKey': localeProvider.getText(key: 'logout'),
        'subtopics': [
          {
            'key': 'logout_account',
            'title': localeProvider.getText(key: 'logout_account'),
            'subTitle': localeProvider.getText(key: ''),
          },
        ],
      },
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          final setting = settings[index];
          print("SETTINGS KEY ${setting["titleKey"]}");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                child: Text(
                // setting['titleKey'],
                  setting['titleKey'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              ...setting['subtopics'].map<Widget>((subtopic) {
                return GestureDetector(
                  onTap: () async{
                    if((subtopic['key'] ?? "") == 'logout_account'){
                      GlobalHelper().progressDialog(context,"Signing out","Signing out, please wait...");
                      final user = await _authService.signOut();
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                    }else{
                      pageNavigatorEngine(subtopic['title']);
                    }

                  },
                  child: ListTile(
                    leading: Icon(Icons.arrow_right, color: colorScheme.primary),
                    title: Text(
                      subtopic['title'],
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    subtitle: Text(
                      subtopic['subTitle'],
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: subtopic['title'] == 'Light Mode'
                        ? Switch(
                      value: true, // Replace with a variable to manage state
                      onChanged: (bool value) {
                        // Handle toggle logic here
                      },
                    )
                        : null,
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
