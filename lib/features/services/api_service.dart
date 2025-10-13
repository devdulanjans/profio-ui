import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:profio/core/constants/app_strings.dart';
import 'package:profio/core/models/subscription.dart';
import 'package:profio/core/models/template.dart';
import 'package:profio/features/services/api_constants.dart';
import 'package:file_picker/file_picker.dart';


Future<User?> getCurrentUser() async{
  final user = FirebaseAuth.instance.currentUser;
  return user;
}



Future<Map<String, String>> getAuthHeaders() async {
  final user = await getCurrentUser();

  if (user == null) throw Exception('User not logged in');

  final idToken = await user.getIdToken(); // or getIdToken(true) to force refresh
  log("AccessToken:${idToken} - UserId-${user.uid}");
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $idToken',
  };
}




Future<String> userRegister(String email,String userId) async {
  final url = Uri.parse("$baseUrl$postSignUp");

  final Map<String, String> requestBody = {
    "email":email,
    "uid": userId,
  };

  try {
    final headers = await getAuthHeaders();
    log("CheckApiUrl:${url}");
    log("CheckHeaders:${headers}");
    log("CheckRequest:${requestBody}");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    log("CheckResponseCode:${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      var obj = jsonDecode(response.body);
      if(obj != null){
        var data = obj['data'] ?? {};
        if(data != null && data != {}){
          var userId = data['_id'] ?? "";
          print("✅ Signup Register Success: ${userId}");
          return userId;
        }
      }

      return "";
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return "";
    }
  } catch (e) {
    print("❌ Error: $e");
    return "";
  }
}


Future<List<Subscription>> getSubscriptionTypes() async {
  List<Subscription> subscriptions = [];
  final url = Uri.parse("$baseUrl$getAllSubscriptions");


  try {
    final headers = await getAuthHeaders();
    final response = await http.get(url, headers: headers,);

    log("CheckResponseCode:${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      var data = results['data'] as List;
      if(data.isNotEmpty){
        subscriptions = data.map((i) => Subscription.fromJson(i)).toList();
      }
      return subscriptions;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return subscriptions;
    }
  } catch (e) {
    print("❌ Error: $e");
    return subscriptions;
  }
}


Future<Map<String, String>?> getPreSignedUrl(String userId, String fileExt,{int type = 1,dynamic docRequest = ""}) async {

  final url = Uri.parse("$baseUrl$postGetPreSignedUrl");

  String profileBody = jsonEncode({
    "userId":userId,
    "fileExtension":"$fileExt",
    "type":"PROFILE" //DOCUMENT
  });
  String documentBody = jsonEncode(docRequest);

  try {
    final headers = await getAuthHeaders();
    log("CheckRequestBody:${type == 1 ? profileBody : documentBody}");
    final response = await http.post(url, headers: headers,
      body: type == 1 ? profileBody : documentBody
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final presignData = data['data'];
      if (presignData == null) {
        print('❌ No data field in response');
        return null;
      }
      return {
        'uploadUrl': presignData['uploadURL'],
        'fileURL': presignData['fileURL'],
      };
    } else {
      print('❌ Failed to get presigned URL');
      return null;
    }
  } catch (e) {
    print("❌ Error: $e");
    return null;
  }
}

Future<bool> uploadFileToPreSignedUrl(String uploadUrl, PlatformFile file) async {
  final headers = await getAuthHeaders();
  final response = await http.put(
    Uri.parse(uploadUrl),
    headers: headers,
    body: file.bytes,
  );

  return response.statusCode == 200 || response.statusCode == 204;
}

Future<bool> updateUserDetails(Map<String, dynamic> request,String userId) async {
  final url = Uri.parse("$baseUrl$putUpdateUserDetails/$userId");

  try {
    final headers = await getAuthHeaders();
    String apiRequest = jsonEncode(request);
    log("CheckApiUrl:${url}");
    log("CheckHeaders:${headers}");
    log("CheckRequest:${apiRequest}");
    final response = await http.put(
      url,
      headers: headers,
      body: apiRequest,
    );

    log("CheckResponseCode:${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Success: ${response.body}");
      return true;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("❌ Error: $e");
    return false;
  }
}


Future<Map<String, dynamic>> getUserByUUID() async {
  Map<String, dynamic> data = {};
  final user = await getCurrentUser();
  if(user == null) return {};

  final url = Uri.parse("$baseUrl$getUserByUID/${user.uid}");


  try {
    final headers = await getAuthHeaders();
    final response = await http.get(url, headers: headers,);

    log("CheckResponseCode:${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      data = results;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return data;
    }
  } catch (e) {
    print("❌ Error: $e");
    return data;
  }

  return data;
}

Future<List<Template>> getAllTemplates(int type) async { //type == 1 - All | 2- User templates
  List<Template> templates = [];
  String typeUrl = type == 1 ? "$baseUrl$getAllTemplatesDetails" :(type == 2 ? "$baseUrl$getUserTemplates/$appUserId" : "");
  final url = Uri.parse(typeUrl);


  try {
    final headers = await getAuthHeaders();
    final response = await http.get(url, headers: headers,);


    log("CheckTemplateUrl:${url}");
    log("CheckResponseCode:${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      if(type == 1){
      var data = results['data'] as List;
      if(data.isNotEmpty){
        templates = data.map((i) => Template.fromJson(i)).toList();
        }
      }
      else if(type ==2){
        var data = results['templates'] as List;
        if(data.isNotEmpty){
          templates = data.map((i) => Template.fromJson(i)).toList();
        }
      }
      return templates;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return templates;
    }
  } catch (e) {
    print("❌ Error: $e");
    return templates;
  }
}


Future<bool> createTemplateForUser(String userId,String templateId) async {
  final url = Uri.parse("$baseUrl${postCreateTemplateForUser(userId, templateId)}");


  try {
    final headers = await getAuthHeaders();
    final response = await http.post(url, headers: headers,);

    log("checkApiURl:$url\n CheckUserRequest-$userId \n ResponseCode:- ${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      return true;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("❌ Error: $e");
    return false;
  }
}



Future<bool> subScribeLanguage(String userId,String language) async {
  final url = Uri.parse("$baseUrl$putSubscribeLanguage");


  String request = jsonEncode(
      {
       "language":language,
        "userId":userId
      });


  try {
    final headers = await getAuthHeaders();
    final response = await http.put(url, headers: headers,
        body:request

    );

    log("checkApiURl:$url\n CheckUserRequest-$userId \n ResponseCode:- ${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      print("User Initial Language Subscribed - Success");
      return true;
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("❌ Error: $e");
    return false;
  }
}


Future<String> shareUserTemplate(String userId,String templateId) async {
  final url = Uri.parse("$baseUrl$postShareTemplate");


  String request = jsonEncode(
      {
        "userId":userId,
        "templateId":templateId,

      });

  print("CheckRequest:${request}");
  try {
    final headers = await getAuthHeaders();
    final response = await http.post(url, headers: headers, body:request);

    log("checkApiURl:$url\n CheckUserRequest-$userId \n ResponseCode:- ${response.statusCode}");
    if (response.statusCode == 200 ) {
      final results = json.decode(response.body);
      print("User Initial Language Subscribed - Success");
      return results['link'] ?? "";
    }
    else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
      return "";
    }
  } catch (e) {
    print("❌ Error: $e");
    return "";
  }
}






