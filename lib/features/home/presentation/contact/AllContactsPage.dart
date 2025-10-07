import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:googleapis/translate/v3.dart' as translate;
import 'package:googleapis_auth/auth_io.dart';

class AllContactsPage extends StatefulWidget {
  const AllContactsPage({Key? key}) : super(key: key);

  @override
  State<AllContactsPage> createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  final _translatedNames = <String>[];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      if (!mounted) return; // ✅ Check before updating UI
      setState(() {
        _contacts = contacts;
      });
      await _translateContactNames();
    } else {
      if (!mounted) return; // ✅ Check before updating UI
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _translateContactNames() async {
    const serviceAccountJson = '''{
  "type": "service_account",
  "project_id": "profio-473307",
  "private_key_id": "e18ad86c683718079c77a5cef355267faa22bed1",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC7aJIk0B7SQx68\\nctOQNyIN423tDStYTDKIQBvZZlHcNsoI6/Dh6gNTCjX4ugDPhmeA1VyNGVm3WxaB\\nWWTlkFXsB/AauEhC6wmuQpxoQ7rBtL0qlTa4usxLRfLBVxa7xQIOqPdEqLCRRggR\\naMOQyNJf1+nFtJMLiK5+4D5g+4a1N/Zuftcc5/eHxhL356w+16UURgT57cmsImmC\\n6o7wmdiw8ry7xQv/ux9fO00bZVrIVhbQOP5dB7yMBJ4aest0Hin2UUCpCV4L/zNh\\nWXWPkmPkNI3FtEJvLnnKSrzkyNHT3vF1Iv2leQqBX4/QmPUEZ5TkPgHfFbB8MssC\\nmJy6QVeBAgMBAAECggEADZSFSo+ePCRK/OLhO8kS+aiqVYwnwO08mCz1F6rXcbqy\\npzTZrrUzangJ8y0fU+psY6SSYVMd8jBykAr3Sb9Myp7EolsKOXcoq2z+Qnvt841y\\nS7ymS3qVxTqbXbE+33pmLMPHrzz+FnjZqtFJops6y2Es+nucUDCmXGFJg+OWHlmB\\nDO7huX21NhwRGv+7m3SXcyEngO9mCU799e5nTw5C7l+sRm0nHev6RgsfYJhvRnJu\\n/kGP5n9WIpMOWM4cOm6PvX8VInFT19YVNh48TlItaXdgtoXwg/7XTrTuPX5V3Nly\\nzurQG2mYNnnQFLMIQ9NtQRRmwoiq6jw9np6fImgiNQKBgQDfSSziVoTBqY9lkYse\\n9oO2xh0Mw6Myi7twStwTMP3LR+2BGu1xdxg6VEHzPMNTLXmUMQfwHnkirGcfqZi2\\nmcwHyWN6v7rG0MM9stkZiedjDBuYIQ9MWkS1fEvW/4lh75lowOVPhpJBvMkTRufu\\nqSWsn8da8a0dOyels6qGn348DwKBgQDW3byMA+zLd52EwEkc7p4OjmIvB50tDiBl\\nW9ShFKSEL1y9zl6puzHzb0WbAN+Y8S5DFVLmdV3jyJZGVQr+j3TkxfpMmCdHHjya\\nn5lnJpQbi/5R/VawAd11u+W6DAd2nrdLVteUqjX+E8ZFaxEWX81bpy8gmM6KlJbu\\nmeZ/tHzjbwKBgCOGZfDA6TBSxPDY/jR37i7XSGnuenmhR7ou/uLCya5dDEmdOify\\nVdV58GA9y6nhM1XDk0q93nII0gN0nUp4H8EhZoVyGcpmDpozaV0p1rmohH9oyyFP\\nv1zMoNhdIcOGNnc3MYS8mWqCGc/KWT5chRT4+uPaTbu33K/9bOUsXQ47AoGAFNT2\\nvNR8ltWIDiDeddGkvWCMoGaqlH20Il+e4+cudCprYXOqteYSV7nIE9kn1Jo9k/9z\\nRCjI65a9CyCfqkKaYLvZIqf11u1VjuA+bUPOREV0aNqZFwN3RzzqbvlPl+6XctR+\\nnklKZtHf/Ub+Jx8ut94jsZNfIwx4/bUqJeOH4D0CgYAZhWgPiH8hdvZPGJ/i+C+S\\nG4oWrt8r/cUF44rLQb8Wq1RqFoWCa89UCpAtJZXUU2GbRjz5EAk2jLCCCIBRNDzI\\nzO+bKIkpFIOQt5SBOpI/gOsuD7fvNSgQhlFn8J8MUOaqI1mk6BH3FPfYgrc0OMXA\\n+MYQcGBy3LBnJ61I19+mJw==\\n-----END PRIVATE KEY-----\\n",
  "client_email": "profio-app@profio-473307.iam.gserviceaccount.com",
  "client_id": "112541061398794337206",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/profio-app%40profio-473307.iam.gserviceaccount.co…,
  "universe_domain": "googleapis.com"
}
  ''';

    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

    final client = await clientViaServiceAccount(
      serviceAccountCredentials,
      [translate.TranslateApi.cloudTranslationScope],
    );

    final translateApi = translate.TranslateApi(client);

    for (var contact in _contacts) {
      final name = contact.displayName;
      if (name.isNotEmpty) {
        final response = await translateApi.projects.translateText(
          translate.TranslateTextRequest(
            contents: [name],
            targetLanguageCode: 'ja', // Replace with your target language code
          ),
          'projects/profio-473307/locations/global', // Replace with your Google Cloud project ID
        );
        _translatedNames.add(response.translations?.first.translatedText ?? name);
      } else {
        _translatedNames.add('?');
      }
    }

    client.close();

    if (!mounted) return; // ✅ Prevent memory leak
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _contacts.clear(); // optional cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final translatedName = _translatedNames.isNotEmpty
            ? _translatedNames[index]
            : contact.displayName;
        return ListTile(
          leading: CircleAvatar(
            child: Text(translatedName.isNotEmpty
                ? translatedName[0]
                : '?'),
          ),
          title: Text(translatedName),
          subtitle: Text(contact.phones.isNotEmpty
              ? contact.phones.first.number
              : 'No phone number'),
        );
      },
    );
  }
}