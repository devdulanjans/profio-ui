
import 'package:shared_preferences/shared_preferences.dart';

class ServiceHelper {
  static bool isProfileCompleted = false;


  static Future<void> init() async {
    isProfileCompleted = await retrieveProfileCompleteStatus() ?? false;

  }


  static bool isProfileCompletedStatus() {
    return isProfileCompleted;
  }

}


Future<void> clearSharedPreference() async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}


Future<bool> storeProfileCompleteStatus(bool isCompleted) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool('isProfileCompleted', isCompleted);
}

Future<bool?> retrieveProfileCompleteStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool? status = prefs.getBool('isProfileCompleted');

  if (status != null) {
    return status;
  } else {
    return false;
  }
}