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
    const serviceAccountJson = '''
  "PAST WHAT I HAVE SENT THROUGH TEH TEAMS"
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