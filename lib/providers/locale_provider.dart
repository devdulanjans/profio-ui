import 'package:flutter/material.dart';

enum AppLanguage { english, japanese }
enum AppLanguageSource { en, ja }
const targetLanguages = ['en','ja'];

class LocaleProvider with ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;


  AppLanguage get currentLanguage => _currentLanguage;

  void toggleLanguage() {
    if (_currentLanguage == AppLanguage.english) {
      _currentLanguage = AppLanguage.japanese;
    } else {
      _currentLanguage = AppLanguage.english;
    }
    notifyListeners();
  }

  String get currentLanguageCode {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.japanese:
        return 'ja';
    }
  }

  // Helper to get translated text
  String getText({required String key}) {
    final translations = {
      'appname':{
        AppLanguage.english: "Profio",
        AppLanguage.japanese: "プロフィオ",
      },
      'welcome': {
        AppLanguage.english: "Welcome",
        AppLanguage.japanese: "ようこそ",
      },
      'signin': {
        AppLanguage.english: "Sign in to continue",
        AppLanguage.japanese: "続行するにはサインインしてください",
      },
      'email': {
        AppLanguage.english: "Email",
        AppLanguage.japanese: "メールアドレス",
      },
      'password': {
        AppLanguage.english: "Password",
        AppLanguage.japanese: "パスワード",
      },
      'login': {
        AppLanguage.english: "Login",
        AppLanguage.japanese: "ログイン",
      },
      'signupmessage': {
        AppLanguage.english: "Don't have an account? Sign Up",
        AppLanguage.japanese: "アカウントをお持ちでない場合は、サインアップ",
      },
      'orsigninwith': {
        AppLanguage.english: "Or sign in with",
        AppLanguage.japanese: "または、次の方法でサインイン",
      },
      'googleauth': {
        AppLanguage.english: "Sign in with Google",
        AppLanguage.japanese: "Googleでサインイン",
      },

      // Home / BottomNavigationBar
      'home': {
        AppLanguage.english: "My Card",
        AppLanguage.japanese: "私のカード",
      },
      'scan': {
        AppLanguage.english: "Scan",
        AppLanguage.japanese: "スキャン",
      },
      'share': {
        AppLanguage.english: "Share",
        AppLanguage.japanese: "共有",
      },
      'contact': {
        AppLanguage.english: "Contact",
        AppLanguage.japanese: "連絡先",
      },
      'settings': {
        AppLanguage.english: "Settings",
        AppLanguage.japanese: "設定",
      },
      'create_contact': {
        AppLanguage.english: "Create a Contact",
        AppLanguage.japanese: "連絡先を作成",
      },

      // 👤 User Profile Page
      'business_profile': {
        AppLanguage.english: "Business profile",
        AppLanguage.japanese: "ビジネスプロフィール",
      },
      'connected': {
        AppLanguage.english: "Connected",
        AppLanguage.japanese: "接続済み",
      },
      'your_links': {
        AppLanguage.english: "Your Links",
        AppLanguage.japanese: "あなたのリンク",
      },
      'direct': {
        AppLanguage.english: "Direct",
        AppLanguage.japanese: "ダイレクト",
      },
      'add_new': {
        AppLanguage.english: "Add New",
        AppLanguage.japanese: "新しく追加",
      },
      'add_new_desc': {
        AppLanguage.english:
        "Add new link as a business or personal branding",
        AppLanguage.japanese: "ビジネスや個人ブランディングとして新しいリンクを追加",
      },
      'active_social': {
        AppLanguage.english: "Active social link",
        AppLanguage.japanese: "アクティブなソーシャルリンク",
      },
      'recent_connected': {
        AppLanguage.english: "Recent connected",
        AppLanguage.japanese: "最近の接続",
      },
      'upgrade': {
        AppLanguage.english: "Upgrade now",
        AppLanguage.japanese: "今すぐアップグレード",
      },
      'create_contact': {
        AppLanguage.english: "Create a Contact",
        AppLanguage.japanese: "連絡先を作成",
      },

      //Sign Up
      'signup': {
        AppLanguage.english: "Sign Up",
        AppLanguage.japanese: "サインアップ",
      },
      'reenter_password': {
        AppLanguage.english: "Re-enter Password",
        AppLanguage.japanese: "パスワードを再入力",
      },
      'accept_privacy': {
        AppLanguage.english: "I accept the Privacy Policy",
        AppLanguage.japanese: "プライバシーポリシーに同意します",
      },
      'create_account': {
        AppLanguage.english: "Create your own account",
        AppLanguage.japanese: "自分のアカウントを作成する",
      },

      //Sign Up
      'ocr_scanner_gallery': {
        AppLanguage.english: "Gallery",
        AppLanguage.japanese: "ギャラリー",
      },
      'ocr_scanner_camera': {
        AppLanguage.english: "Camera",
        AppLanguage.japanese: "カメラ",
      },

      //contact_save
      'save_contact': {
        AppLanguage.english: "Save Contact",
        AppLanguage.japanese: "連絡先の保存",
      },

      //Settings Page
      'account':{
        AppLanguage.english: "Account",
        AppLanguage.japanese: "アカウント",
      },
      'profile':{
        AppLanguage.english: "Profile",
        AppLanguage.japanese: "プロフィール",
      },
      'profile_subtitle': {
        AppLanguage.english: "Manage your personal information",
        AppLanguage.japanese: "個人情報を管理",
      },

      'subscription':{
        AppLanguage.english: "Subscription",
        AppLanguage.japanese: "サブスクリプション",
      },
      'subscription_subtitle': {
        AppLanguage.english: "Manage your subscription plan",
        AppLanguage.japanese: "サブスクリプションプランを管理",
      },

      'preference':{
        AppLanguage.english: "Preference",
        AppLanguage.japanese: "設定",
      },
      'language':{
        AppLanguage.english: "Language",
        AppLanguage.japanese: "言語",
      },
      'notification':{
        AppLanguage.english: "Notification",
        AppLanguage.japanese: "通知",
      },
      'privacy':{
        AppLanguage.english: "Privacy",
        AppLanguage.japanese: "プライバシー",
      },

      'support':{
        AppLanguage.english: "Support",
        AppLanguage.japanese: "サポート",
      },
      'help_support':{
        AppLanguage.english: "Help & Support",
        AppLanguage.japanese: "ヘルプとサポート",
      },

      'about':{
        AppLanguage.english: "About",
        AppLanguage.japanese: "約",
      },
      'about_us':{
        AppLanguage.english: "About Us",
        AppLanguage.japanese: "私たちに関しては",
      },

      'terms_of_service':{
        AppLanguage.english: "Terms of Service",
        AppLanguage.japanese: "利用規約",
      },

      'appearance':{
        AppLanguage.english: "Appearance",
        AppLanguage.japanese: "外観",
      },
      'logout':{
        AppLanguage.english: "Log out",
        AppLanguage.japanese: "ログアウト",
      },
      'logout_account':{
        AppLanguage.english: "Log out of your account",
        AppLanguage.japanese: "アカウントからログアウトする",
      },
      'mode':{
        AppLanguage.english: "Light Mode",
        AppLanguage.japanese: "ダークモード",
      },
      'language_toggle':{
        AppLanguage.english: "Language Toggle",
        AppLanguage.japanese: "言語切替",
      },

      'language': {
        AppLanguage.english: "Language",
        AppLanguage.japanese: "言語",
      },
      'language_subtitle': {
        AppLanguage.english: "Change the app's language",
        AppLanguage.japanese: "アプリの言語を変更",
      },
      'notification': {
        AppLanguage.english: "Notification",
        AppLanguage.japanese: "通知",
      },
      'notification_subtitle': {
        AppLanguage.english: "Manage notification settings",
        AppLanguage.japanese: "通知設定を管理",
      },
      'privacy': {
        AppLanguage.english: "Privacy",
        AppLanguage.japanese: "プライバシー",
      },
      'privacy_subtitle': {
        AppLanguage.english: "Adjust privacy preferences",
        AppLanguage.japanese: "プライバシー設定を調整",
      },
      'help_support': {
        AppLanguage.english: "Help & Support",
        AppLanguage.japanese: "ヘルプとサポート",
      },
      'help_support_subtitle': {
        AppLanguage.english: "Get assistance and support",
        AppLanguage.japanese: "サポートを受ける",
      },
      'about_us': {
        AppLanguage.english: "About Us",
        AppLanguage.japanese: "私たちに関しては",
      },
      'about_us_subtitle': {
        AppLanguage.english: "Learn more about our app",
        AppLanguage.japanese: "アプリについてもっと知る",
      },
      'terms_of_service': {
        AppLanguage.english: "Terms of Service",
        AppLanguage.japanese: "利用規約",
      },
      'terms_of_service_subtitle': {
        AppLanguage.english: "Read our terms and conditions",
        AppLanguage.japanese: "利用規約を読む",
      },
      'dark_mode': {
        AppLanguage.english: "Light Mode",
        AppLanguage.japanese: "ダークモード",
      },
      'dark_mode_subtitle': {
        AppLanguage.english: "Switch between light and dark themes",
        AppLanguage.japanese: "ライトとダークテーマを切り替える",
      },
      'language_toggle': {
        AppLanguage.english: "Language Toggle",
        AppLanguage.japanese: "言語切替",
      },
      'language_toggle_subtitle': {
        AppLanguage.english: "Switch app language dynamically",
        AppLanguage.japanese: "アプリの言語を動的に切り替える",
      },

    };

    return translations[key]?[currentLanguage] ?? '';
  }
}
