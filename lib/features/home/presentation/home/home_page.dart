// import 'package:flutter/material.dart';
// import 'package:profio/features/home/presentation/home/user_profile_page.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text.dart';
// import '../../../../providers/locale_provider.dart';
// import '../contact/AllContactsPage.dart';
// import '../my_profile/MyCreatedProfilesScreen.dart';
// import '../scanner/ocr_scanner.dart';
// import '../settings/settings.dart';
// import '../settings/subcription_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key, required this.parentPageId});
//   final int parentPageId;
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (widget.parentPageId == 100) {
//       print("PAGE ID: ${widget.parentPageId}");
//       setState(() {
//         _currentIndex = 5;
//       });
//       // _currentIndex = 5; // Index of SettingsList in the _pages list
//     } else{
//       _currentIndex = 0;
//     }
//   }
//
//   final List<Widget> _pages = [
//     UserProfilePage(),
//     MyCreatedProfilesScreen(),
//     OCRScannerPage(),
//     AllContactsPage(),
//     SettingsList(),
//     // SubscriptionPage()
//   ];
//
//   List<BottomNavigationBarItem> _bottomNavItems(LocaleProvider localeProvider) {
//     return [
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.home),
//         label: localeProvider.getText(key: 'home'),
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.share),
//         label: localeProvider.getText(key: 'share'),
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.qr_code_scanner),
//         label: localeProvider.getText(key: 'scan'),
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.contact_mail),
//         label: localeProvider.getText(key: 'contact'),
//       ),
//       BottomNavigationBarItem(
//         icon: const Icon(Icons.settings),
//         label: localeProvider.getText(key: 'settings'),
//       ),
//     ];
//   }
//
//   String _getTitleKeyForCurrentPage() {
//     switch (_currentIndex) {
//       case 0:
//         return 'home';
//       case 1:
//         return 'share';
//       case 2:
//         return 'scan';
//       case 3:
//         return 'contact';
//       case 4:
//         return 'settings';
//       case 5:
//         return 'asdasdas';
//       default:
//         return 'home';
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final localeProvider = Provider.of<LocaleProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localeProvider.getText(key: _getTitleKeyForCurrentPage())),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () => localeProvider.toggleLanguage(),
//             icon: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: Text(
//                 localeProvider.currentLanguage == AppLanguage.english
//                     ? "日本"
//                     : "EN",
//                 key: ValueKey(localeProvider.currentLanguage),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // ✅ Conditionally set the body
//       body: (widget.parentPageId == 100)
//           ? const SubscriptionPage()
//           : _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         items: _bottomNavItems(localeProvider),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.primaryDarkGreen,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:profio/features/home/presentation/home/user_profile_page.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../providers/locale_provider.dart';
import '../contact/AllContactsPage.dart';
import '../my_profile/MyCreatedProfilesScreen.dart';
import '../my_profile/create_card.dart';
import '../scanner/ocr_scanner.dart';
import '../settings/about_us.dart';
import '../settings/help_and_support.dart';
import '../settings/notification.dart';
import '../settings/settings.dart';
import '../settings/subcription_page.dart';
import '../settings/terms_adn_condition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.parentPageId});
  final int parentPageId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget listOfInternalPages(){
    if(widget.parentPageId == 100){
      return const SubscriptionPage();
    } else if(widget.parentPageId == 102){
      return const NotificationPage();
    } else if(widget.parentPageId == 103){
      return const PrivacyPolicyPage();
    } else if(widget.parentPageId == 104){
      return const HelpSupportPage();
    } else if(widget.parentPageId == 120){
      return const ProfileSetupPage();
    }
    else if(widget.parentPageId == 105){
      return const AboutUsPage();
    }
    else {
      return _pages[_currentIndex];
    }
  }

  final List<Widget> _pages = [
    UserProfilePage(),           // 0
    MyCreatedProfilesScreen(),   // 1
    // ProfileSetupPage(),
    OCRScannerPage(),            // 2
    AllContactsPage(),           // 3
    SettingsList(),              // 4
  ];

  @override
  void initState() {
    super.initState();
    // Always start at index 0 for BottomNavigationBar
    _currentIndex = 0;
  }

  List<BottomNavigationBarItem> _bottomNavItems(LocaleProvider localeProvider) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: localeProvider.getText(key: 'home'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.share),
        label: localeProvider.getText(key: 'share'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.qr_code_scanner),
        label: localeProvider.getText(key: 'scan'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.contact_mail),
        label: localeProvider.getText(key: 'contact'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: localeProvider.getText(key: 'settings'),
      ),
    ];
  }

  String _getTitleKeyForCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return 'home';
      case 1:
        return 'share';
      case 2:
        return 'scan';
      case 3:
        return 'contact';
      case 4:
        return 'settings';
      default:
        return 'home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.getText(key: _getTitleKeyForCurrentPage())),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => localeProvider.toggleLanguage(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                localeProvider.currentLanguage == AppLanguage.english
                    ? "日本"
                    : "EN",
                key: ValueKey(localeProvider.currentLanguage),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      // ✅ Show SubscriptionPage if parentPageId == 100
      body: (widget.parentPageId != null)
          ? listOfInternalPages()
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // must stay 0–4
        items: _bottomNavItems(localeProvider),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // safe index
          });
        },
      ),
    );
  }
}

