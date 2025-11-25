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

      // profile Edit Screen
      'profile_photo': {
        AppLanguage.english: "Profile Photo*",
        AppLanguage.japanese: "プロフィール写真*",
      },
      'personal_details': {
        AppLanguage.english: "Personal Details",
        AppLanguage.japanese: "個人情報",
      },
      'permission_denied': {
        AppLanguage.english: "Permission denied. Please enable it from settings.",
        AppLanguage.japanese: "許可が拒否されました。設定から有効にしてください。",
      },
      'file_size_exceeded': {
        AppLanguage.english: "File Size exceeded.",
        AppLanguage.japanese: "ファイルサイズが超過しました。",
      },
      'full_name': {
        AppLanguage.english: "Full Name*",
        AppLanguage.japanese: "氏名*",
      },
      'personal_email': {
        AppLanguage.english: "Personal Email Address*",
        AppLanguage.japanese: "個人メールアドレス*",
      },
      'phone_number': {
        AppLanguage.english: "Phone Number*",
        AppLanguage.japanese: "電話番号*",
      },
      'personal_address': {
        AppLanguage.english: "Personal Address*",
        AppLanguage.japanese: "住所*",
      },
      'personal_website': {
        AppLanguage.english: "Personal Website URL*",
        AppLanguage.japanese: "個人ウェブサイトURL*",
      },
      'company_details': {
        AppLanguage.english: "Company Details",
        AppLanguage.japanese: "会社情報",
      },
      'company_name': {
        AppLanguage.english: "Company Name*",
        AppLanguage.japanese: "会社名*",
      },
      'job_title': {
        AppLanguage.english: "Job Title*",
        AppLanguage.japanese: "役職*",
      },
      'company_email': {
        AppLanguage.english: "Company Email Address*",
        AppLanguage.japanese: "会社メールアドレス*",
      },
      'company_phone': {
        AppLanguage.english: "Company Phone Number*",
        AppLanguage.japanese: "会社電話番号*",
      },
      'company_address': {
        AppLanguage.english: "Company Address",
        AppLanguage.japanese: "会社住所",
      },
      'company_website': {
        AppLanguage.english: "Company Website URL",
        AppLanguage.japanese: "会社ウェブサイトURL",
      },
      'social_media': {
        AppLanguage.english: "Social Media",
        AppLanguage.japanese: "ソーシャルメディア",
      },
      'whatsapp': {
        AppLanguage.english: "WhatsApp*",
        AppLanguage.japanese: "ワッツアップ*",
      },
      'facebook': {
        AppLanguage.english: "Facebook",
        AppLanguage.japanese: "フェイスブック",
      },
      'instagram': {
        AppLanguage.english: "Instagram",
        AppLanguage.japanese: "インスタグラム",
      },
      'linkedin': {
        AppLanguage.english: "Linkedin",
        AppLanguage.japanese: "リンクトイン",
      },
      'youtube': {
        AppLanguage.english: "Youtube",
        AppLanguage.japanese: "ユーチューブ",
      },
      'other_links': {
        AppLanguage.english: "Other links",
        AppLanguage.japanese: "その他のリンク",
      },
      'enter_other_link_title': {
        AppLanguage.english: "Enter other link title",
        AppLanguage.japanese: "他のリンクのタイトルを入力",
      },
      'enter_other_link': {
        AppLanguage.english: "Enter other link",
        AppLanguage.japanese: "他のリンクを入力",
      },
      'document_upload': {
        AppLanguage.english: "Document Upload",
        AppLanguage.japanese: "ドキュメントアップロード",
      },
      'document_update': {
        AppLanguage.english: "Document Update",
        AppLanguage.japanese: "ドキュメント更新",
      },
      'document_updating': {
        AppLanguage.english: "Document title updating, please wait...",
        AppLanguage.japanese: "ドキュメントタイトルを更新中、しばらくお待ちください…",
      },
      'document_updated_success': {
        AppLanguage.english: "Document title updated successfully",
        AppLanguage.japanese: "ドキュメントタイトルが正常に更新されました",
      },
      'document_updated_failed': {
        AppLanguage.english: "Document title updated failed.",
        AppLanguage.japanese: "ドキュメントタイトルの更新に失敗しました。",
      },
      'document_delete': {
        AppLanguage.english: "Document Delete",
        AppLanguage.japanese: "ドキュメント削除",
      },
      'document_deleting': {
        AppLanguage.english: "Document deleting, please wait...",
        AppLanguage.japanese: "ドキュメントを削除中、しばらくお待ちください…",
      },
      'document_deleted_success': {
        AppLanguage.english: "Document deleted successfully.",
        AppLanguage.japanese: "ドキュメントが正常に削除されました。",
      },
      'document_deleted_failed': {
        AppLanguage.english: "Document deleting failed.",
        AppLanguage.japanese: "ドキュメントの削除に失敗しました。",
      },
      'uploaded': {
        AppLanguage.english: "Uploaded",
        AppLanguage.japanese: "アップロード済み",
      },
      'not_uploaded': {
        AppLanguage.english: "Not Uploaded",
        AppLanguage.japanese: "未アップロード",
      },
      'back': {
        AppLanguage.english: "Back",
        AppLanguage.japanese: "戻る",
      },
      'save': {
        AppLanguage.english: "Save",
        AppLanguage.japanese: "保存",
      },
      'next': {
        AppLanguage.english: "Next",
        AppLanguage.japanese: "次へ",
      },
      'fill_personal_details': {
        AppLanguage.english: "Please fill in all required personal details.",
        AppLanguage.japanese: "必要な個人情報をすべて入力してください。",
      },
      'fill_company_details': {
        AppLanguage.english: "Please fill in all required company details.",
        AppLanguage.japanese: "必要な会社情報をすべて入力してください。",
      },
      'fill_social_details': {
        AppLanguage.english: "Please fill in all required social media details.",
        AppLanguage.japanese: "必要なソーシャルメディア情報をすべて入力してください。",
      },
      'profile_update': {
        AppLanguage.english: "Profile update",
        AppLanguage.japanese: "プロフィール更新",
      },
      'profile_updating': {
        AppLanguage.english: "Profile updating, please wait...",
        AppLanguage.japanese: "プロフィールを更新中、しばらくお待ちください…",
      },
      'profile_image_failed': {
        AppLanguage.english: "Profile image upload failed ❌",
        AppLanguage.japanese: "プロフィール画像のアップロードに失敗しました ❌",
      },
      'documents_upload_failed': {
        AppLanguage.english: "Documents Upload Failed ❌",
        AppLanguage.japanese: "ドキュメントのアップロードに失敗しました ❌",
      },
      'profile_update_failed': {
        AppLanguage.english: "Profile Update Failed ❌",
        AppLanguage.japanese: "プロフィール更新に失敗しました ❌",
      },
      'profile_update_success': {
        AppLanguage.english: "Profile Update Successfully ",
        AppLanguage.japanese: "プロフィールが正常に更新されました ",
      },
      'something_wrong': {
        AppLanguage.english: "Something went wrong, Please try again.",
        AppLanguage.japanese: "問題が発生しました。もう一度お試しください。",
      },
      'cancel': {
        AppLanguage.english: "Cancel",
        AppLanguage.japanese: "キャンセル",
      },
      'valid_text': {
        AppLanguage.english: "Please enter a valid text.",
        AppLanguage.japanese: "有効なテキストを入力してください。",
      },
      'enter_new_text': {
        AppLanguage.english: "Enter new text",
        AppLanguage.japanese: "新しいテキストを入力",
      },
      'edit_doc_title': {
        AppLanguage.english: "Edit Document Title",
        AppLanguage.japanese: "ドキュメントタイトルを編集",
      },
      'close': {
        AppLanguage.english: "Close",
        AppLanguage.japanese: "閉じる",
      },
      'document_title': {
        AppLanguage.english: "Document Title",
        AppLanguage.japanese: "ドキュメントのタイトル",
      },
      'select_file': {
        AppLanguage.english: "Select File",
        AppLanguage.japanese: "ファイルを選択",
      },
      'document_upload_limit': {
        AppLanguage.english: "Document upload limit exceeded.",
        AppLanguage.japanese: "ドキュメントのアップロード制限を超えました",
      },
      'add_document': {
        AppLanguage.english: "Add Document",
        AppLanguage.japanese: "ドキュメントを追加",
      },
      'enter_document_title': {
        AppLanguage.english: "Please enter the document title.",
        AppLanguage.japanese: "ドキュメントのタイトルを入力してください。",
      },
      'select_document': {
        AppLanguage.english: "Please select the document.",
        AppLanguage.japanese: "ドキュメントを選択してください。",
      },
      'delete': {
        AppLanguage.english: "Delete",
        AppLanguage.japanese: "削除",
      },
      'profile_edit': {
        AppLanguage.english: "Profile",
        AppLanguage.japanese: "プロフィール",
      },
      'notifications': {
        AppLanguage.english: "Notifications",
        AppLanguage.japanese: "通知",
      },
      'privacy_policy': {
        AppLanguage.english: "Privacy",
        AppLanguage.japanese: "プライバシー",
      },
      'all_templates': {
        AppLanguage.english: "All Templates",
        AppLanguage.japanese: "すべてのテンプレート",
      },

      //template related
      'no_templates_available': {
        AppLanguage.english: "No templates available.",
        AppLanguage.japanese: "利用可能なテンプレートがありません。",
      },
      'deselect': {
        AppLanguage.english: "Deselect",
        AppLanguage.japanese: "選択を解除",
      },
      'template_limit_reached': {
        AppLanguage.english: "Template limit reached — please deselect one to add another.",
        AppLanguage.japanese: "テンプレートの上限に達しました。追加するには、いずれかの選択を解除してください。",
      },
      'selecting_template': {
        AppLanguage.english: "Selecting a template.",
        AppLanguage.japanese: "テンプレートを選択しています。",
      },
      'processing_selection': {
        AppLanguage.english: "Please wait while we process your selection and load the template.",
        AppLanguage.japanese: "選択を処理してテンプレートを読み込んでいます。しばらくお待ちください。",
      },
      'template_selected_success': {
        AppLanguage.english: "Template selected successfully.",
        AppLanguage.japanese: "テンプレートが正常に選択されました。",
      },
      'template_selected_failed': {
        AppLanguage.english: "Template selection failed.",
        AppLanguage.japanese: "テンプレートの選択に失敗しました。",
      },
      'deselect_template': {
        AppLanguage.english: "Deselect Template",
        AppLanguage.japanese: "テンプレートの選択を解除",
      },
      'confirm_deselect_template': {
        AppLanguage.english: "Do you want to deselect this template?",
        AppLanguage.japanese: "このテンプレートの選択を解除しますか？",
      },
      'no': {
        AppLanguage.english: "No",
        AppLanguage.japanese: "いいえ",
      },
      'template_deselect': {
        AppLanguage.english: "Template Deselect",
        AppLanguage.japanese: "テンプレートの選択解除",
      },
      'template_deselecting_wait': {
        AppLanguage.english: "Template deselecting, please wait...",
        AppLanguage.japanese: "テンプレートの選択を解除しています。しばらくお待ちください...",
      },
      'template_deselect_success': {
        AppLanguage.english: "Template deselecting success",
        AppLanguage.japanese: "テンプレートの選択解除が完了しました。",
      },
      'template_deselect_failed': {
        AppLanguage.english: "Template deselecting failed",
        AppLanguage.japanese: "テンプレートの選択解除に失敗しました。",
      },
      'yes': {
        AppLanguage.english: "Yes",
        AppLanguage.japanese: "はい",
      },
      'share_template': {
        AppLanguage.english: "Share Template",
        AppLanguage.japanese: "テンプレートを共有",
      },
      'confirm_share_link': {
        AppLanguage.english: "Do you want to share this link?",
        AppLanguage.japanese: "このリンクを共有しますか？",
      },
      'template_share': {
        AppLanguage.english: "Template Share",
        AppLanguage.japanese: "テンプレートの共有",
      },
      'link_generating_wait': {
        AppLanguage.english: "Link generating, please wait...",
        AppLanguage.japanese: "リンクを生成しています。しばらくお待ちください...",
      },
      'profio_user_template': {
        AppLanguage.english: "Profio user template",
        AppLanguage.japanese: "Profioユーザーテンプレート",
      },
      'template_link_generation_failed': {
        AppLanguage.english: "Template link generation failed",
        AppLanguage.japanese: "テンプレートのリンク生成に失敗しました。",
      },




    };

    return translations[key]?[currentLanguage] ?? '';
  }
}
