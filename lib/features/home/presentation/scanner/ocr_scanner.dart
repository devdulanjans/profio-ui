// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_contacts/contact.dart';
// // import 'package:flutter_contacts/flutter_contacts.dart';
// // import 'package:flutter_contacts/properties/address.dart';
// // import 'package:flutter_contacts/properties/email.dart';
// // import 'package:flutter_contacts/properties/phone.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../../../providers/locale_provider.dart';
// //
// // class OCRScannerPage extends StatefulWidget {
// //   const OCRScannerPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<OCRScannerPage> createState() => _OCRScannerPageState();
// // }
// //
// // class _OCRScannerPageState extends State<OCRScannerPage> {
// //   File? _image;
// //   String _scannedText = "";
// //   bool _isLoading = false;
// //   bool _isSaving = false;
// //
// //   final ImagePicker _picker = ImagePicker();
// //   final textRecognizer = TextRecognizer();
// //
// //   // Form controllers
// //   final TextEditingController _nameController = TextEditingController();
// //   final List<TextEditingController> _contactControllers = [TextEditingController()];
// //   final TextEditingController _contactNumberController = TextEditingController();
// //   final TextEditingController _addressController = TextEditingController();
// //   final List<TextEditingController> _socialControllers = [TextEditingController()];
// //
// //   Future<void> _getImage(ImageSource source) async {
// //     final pickedFile = await _picker.pickImage(source: source);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _image = File(pickedFile.path);
// //         _scannedText = "";
// //       });
// //       _processImage(File(pickedFile.path));
// //     }
// //   }
// //
// //   Future<void> _processImage(File imageFile) async {
// //     setState(() => _isLoading = true);
// //
// //     final inputImage = InputImage.fromFile(imageFile);
// //
// //     try {
// //       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
// //
// //       String extracted = recognizedText.text;
// //       setState(() {
// //         _scannedText = extracted.isEmpty ? "No text found" : extracted;
// //       });
// //
// //       _extractName(extracted); // Try auto-detect name
// //       _extractAddress(extracted); // Try auto-detect address
// //       _extractContactNumber(_scannedText); // Extract contact number
// //       _extractContactNumber(extracted); // Try auto-detect contact number
// //     } catch (e) {
// //       setState(() {
// //         _scannedText = "Error: $e";
// //       });
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
// //
// //   void _extractName(String text) {
// //     // Very simple name detection → assume first line with 2 words is a name
// //     final lines = text.split("\n");
// //     for (var line in lines) {
// //       if (line.trim().split(" ").length >= 2 && line.length < 40) {
// //         _nameController.text = line.trim();
// //         break;
// //       }
// //     }
// //   }
// //
// //   void _extractAddress(String text) {
// //     // Basic address detection logic
// //     // This is a very simplistic approach and might need refinement
// //     final lines = text.split("\n");
// //     String potentialAddress = "";
// //     for (var line in lines) {
// //       // Example: Look for lines with numbers and common address keywords
// //       if (line.contains(RegExp(r'\d')) && (line.toLowerCase().contains('street') || line.toLowerCase().contains('road') || line.toLowerCase().contains('ave') || line.toLowerCase().contains('ln') || line.toLowerCase().contains('purok') || line.toLowerCase().contains('brgy'))) {
// //         potentialAddress = line.trim();
// //         break; // Take the first likely candidate
// //       }
// //     }
// //     _addressController.text = potentialAddress;
// //   }
// //
// //   void _extractContactNumber(String text) {
// //     // Basic contact number detection (supports various formats)
// //     // This is a simplistic approach
// //     final RegExp phoneRegex = RegExp(
// //       r'(?:\+?63|0)?\s?(?:9\d{2})\s?\d{3}\s?\d{4}|\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}',
// //     );
// //     final matches = phoneRegex.allMatches(text);
// //     if (matches.isNotEmpty) {
// //       // Take the first found number
// //       final foundNumber = matches.first.group(0)?.replaceAll(RegExp(r'[\s\(\)\-\.]'), ''); // Clean up the number
// //       _contactNumberController.text = foundNumber ?? '';
// //     }
// //   }
// //   void _addContactField() {
// //     setState(() {
// //       _contactControllers.add(TextEditingController());
// //     });
// //   }
// //
// //   void _addSocialField() {
// //     setState(() {
// //       _socialControllers.add(TextEditingController());
// //     });
// //   }
// //
// //   Future<void> _saveContact() async {
// //     setState(() => _isSaving = true);
// //
// //     // Request permission first
// //     if (!await FlutterContacts.requestPermission()) {
// //       setState(() => _isSaving = false);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Permission denied: Cannot save contact")),
// //       );
// //       return;
// //     }
// //
// //
// //
// //     try {
// //       // Create a new contact object
// //       final newContact = Contact()
// //         ..name.first = _nameController.text.trim()
// //         ..addresses = [
// //           Address(
// //             _addressController.text.trim(),
// //             label: AddressLabel.home,
// //           ),
// //         ]
// //         ..phones = _contactControllers
// //             .map((c) => Phone(c.text.trim(), label: PhoneLabel.mobile))
// //             .where((p) => p.number.isNotEmpty)
// //             .toList()
// //         ..emails = _socialControllers
// //             .map((c) => Email(c.text.trim(), label: EmailLabel.work))
// //             .where((e) => e.address.isNotEmpty)
// //             .toList();
// //
// //       // Insert into device contacts
// //       await newContact.insert();
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("✅ Contact saved to phonebook!")),
// //       );
// //     } catch (e) {
// //       debugPrint("❌ Error saving contact: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error saving contact: $e")),
// //       );
// //     } finally {
// //       setState(() => _isSaving = false);
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     textRecognizer.close();
// //     _nameController.dispose();
// //     _contactNumberController.dispose();
// //     _addressController.dispose();
// //     for (var c in _contactControllers) {
// //       c.dispose();
// //     }
// //     for (var c in _socialControllers) {
// //       c.dispose();
// //     }
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final locale = Provider.of<LocaleProvider>(context);
// //
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           // OCR Buttons
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               ElevatedButton.icon(
// //                 icon: const Icon(Icons.photo),
// //                 label: Text(locale.getText(key: 'ocr_scanner_gallery')),
// //                 onPressed: () => _getImage(ImageSource.gallery),
// //               ),
// //               ElevatedButton.icon(
// //                 icon: const Icon(Icons.camera_alt),
// //                 label: Text(locale.getText(key: 'ocr_scanner_camera')),
// //                 onPressed: () => _getImage(ImageSource.camera),
// //               ),
// //             ],
// //           ),
// //
// //           const SizedBox(height: 15),
// //
// //           if (_image != null)
// //             Container(
// //               height: 180,
// //               width: double.infinity,
// //               margin: const EdgeInsets.symmetric(vertical: 10),
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.grey),
// //                 borderRadius: BorderRadius.circular(10),
// //                 image: DecorationImage(
// //                   image: FileImage(_image!),
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ),
// //
// //           if (_isLoading) const CircularProgressIndicator(),
// //
// //           const SizedBox(height: 20),
// //
// //           // ===== FORM =====
// //           TextField(
// //             controller: _nameController,
// //             decoration: InputDecoration(
// //               labelText: locale.getText(key: 'full_name'),
// //               border: const OutlineInputBorder(),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 12),
// //
// //           TextField(
// //             controller: _contactNumberController,
// //             keyboardType: TextInputType.phone,
// //             decoration: InputDecoration(
// //               labelText: locale.getText(key: 'contact_number'),
// //               border: const OutlineInputBorder(),
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //
// //           Column(
// //             children: List.generate(_contactControllers.length, (index) {
// //               return Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 6),
// //                 child: TextField(
// //                   controller: _contactControllers[index],
// //                   keyboardType: TextInputType.phone,
// //                   decoration: InputDecoration(
// //                     labelText: "${locale.getText(key: 'contact_number')} ${index + 1}",
// //                     border: const OutlineInputBorder(),
// //                   ),
// //                 ),
// //               );
// //             }),
// //           ),
// //           Align(
// //             alignment: Alignment.centerLeft,
// //             child: TextButton.icon(
// //               onPressed: _addContactField,
// //               icon: const Icon(Icons.add),
// //               label: Text(locale.getText(key: 'add_contact')),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 12),
// //
// //           TextField(
// //             controller: _addressController,
// //             maxLines: 2,
// //             decoration: InputDecoration(
// //               labelText: locale.getText(key: 'address'),
// //               border: const OutlineInputBorder(),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 12),
// //
// //           Column(
// //             children: List.generate(_socialControllers.length, (index) {
// //               return Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 6),
// //                 child: TextField(
// //                   controller: _socialControllers[index],
// //                   decoration: InputDecoration(
// //                     labelText: "${locale.getText(key: 'social_link')} ${index + 1}",
// //                     border: const OutlineInputBorder(),
// //                   ),
// //                 ),
// //               );
// //             }),
// //           ),
// //           Align(
// //             alignment: Alignment.centerLeft,
// //             child: TextButton.icon(
// //               onPressed: _addSocialField,
// //               icon: const Icon(Icons.add_link),
// //               label: Text(locale.getText(key: 'add_social')),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 20),
// //
// //           // Save Button
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               onPressed: _isSaving ? null : _saveContact,
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(vertical: 14),
// //                 textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //               ),
// //               child: _isSaving
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : Text(locale.getText(key: 'save_contact')),
// //             ),
// //           ),
// //
// //           const SizedBox(height: 20),
// //
// //           // OCR Extracted Text Preview
// //           if (_scannedText.isNotEmpty)
// //             Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey.shade200,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Text(_scannedText, style: const TextStyle(fontSize: 14, color: Colors.black)),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_contacts/properties/address.dart';
// import 'package:flutter_contacts/properties/email.dart';
// import 'package:flutter_contacts/properties/phone.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../providers/locale_provider.dart';
//
// class OCRScannerPage extends StatefulWidget {
//   const OCRScannerPage({Key? key}) : super(key: key);
//
//   @override
//   State<OCRScannerPage> createState() => _OCRScannerPageState();
// }
//
// class _OCRScannerPageState extends State<OCRScannerPage> {
//   File? _image;
//   String _scannedText = "";
//   bool _isLoading = false;
//   bool _isSaving = false;
//
//   final ImagePicker _picker = ImagePicker();
//   final textRecognizer = TextRecognizer();
//
//   // Form controllers
//   final TextEditingController _nameController = TextEditingController();
//   final List<TextEditingController> _contactControllers = [TextEditingController()];
//   final TextEditingController _contactNumberController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final List<TextEditingController> _socialControllers = [TextEditingController()];
//
//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _scannedText = "";
//       });
//       _processImage(File(pickedFile.path));
//     }
//   }
//
//   Future<void> _processImage(File imageFile) async {
//     setState(() => _isLoading = true);
//
//     final inputImage = InputImage.fromFile(imageFile);
//
//     try {
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       String extracted = recognizedText.text;
//       setState(() {
//         _scannedText = extracted.isEmpty ? "No text found" : extracted;
//       });
//
//       _extractName(extracted); // auto-detect name
//       _extractAddress(extracted); // auto-detect address
//       _extractContactNumber(extracted); // auto-detect contact number
//     } catch (e) {
//       setState(() {
//         _scannedText = "Error: $e";
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _extractName(String text) {
//     final lines = text.split("\n");
//     for (var line in lines) {
//       if (line.trim().split(" ").length >= 2 && line.length < 40) {
//         _nameController.text = line.trim();
//         break;
//       }
//     }
//   }
//
//   void _extractAddress(String text) {
//     final lines = text.split("\n");
//     String potentialAddress = "";
//     for (var line in lines) {
//       if (line.contains(RegExp(r'\d')) &&
//           (line.toLowerCase().contains('street') ||
//               line.toLowerCase().contains('road') ||
//               line.toLowerCase().contains('ave') ||
//               line.toLowerCase().contains('ln') ||
//               line.toLowerCase().contains('purok') ||
//               line.toLowerCase().contains('brgy'))) {
//         potentialAddress = line.trim();
//         break;
//       }
//     }
//     _addressController.text = potentialAddress;
//   }
//
//   void _extractContactNumber(String text) {
//     final RegExp phoneRegex = RegExp(
//       r'(\+?\d{1,3}[\s-]?)?(\d{2,4}[\s-]?)?\d{6,10}',
//     );
//
//     final matches = phoneRegex.allMatches(text);
//     if (matches.isNotEmpty) {
//       final rawNumber = matches.first.group(0) ?? '';
//       final cleanedNumber = rawNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
//
//       setState(() {
//         _contactNumberController.text = cleanedNumber;
//       });
//     }
//   }
//
//   void _addContactField() {
//     setState(() {
//       _contactControllers.add(TextEditingController());
//     });
//   }
//
//   void _addSocialField() {
//     setState(() {
//       _socialControllers.add(TextEditingController());
//     });
//   }
//
//   Future<void> _saveContact() async {
//     setState(() => _isSaving = true);
//
//     if (!await FlutterContacts.requestPermission()) {
//       setState(() => _isSaving = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Permission denied: Cannot save contact")),
//       );
//       return;
//     }
//
//     try {
//       final newContact = Contact()
//         ..name.first = _nameController.text.trim()
//         ..addresses = [
//           Address(
//             _addressController.text.trim(),
//             label: AddressLabel.home,
//           ),
//         ]
//         ..phones = [
//           if (_contactNumberController.text.isNotEmpty)
//             Phone(_contactNumberController.text.trim(), label: PhoneLabel.mobile),
//           ..._contactControllers
//               .map((c) => Phone(c.text.trim(), label: PhoneLabel.mobile))
//               .where((p) => p.number.isNotEmpty),
//         ]
//         ..emails = _socialControllers
//             .map((c) => Email(c.text.trim(), label: EmailLabel.work))
//             .where((e) => e.address.isNotEmpty)
//             .toList();
//
//       await newContact.insert();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Contact saved to phonebook!")),
//       );
//     } catch (e) {
//       debugPrint("❌ Error saving contact: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving contact: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     textRecognizer.close();
//     _nameController.dispose();
//     _contactNumberController.dispose();
//     _addressController.dispose();
//     for (var c in _contactControllers) {
//       c.dispose();
//     }
//     for (var c in _socialControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final locale = Provider.of<LocaleProvider>(context);
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.photo),
//                 label: Text(locale.getText(key: 'ocr_scanner_gallery')),
//                 onPressed: () => _getImage(ImageSource.gallery),
//               ),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.camera_alt),
//                 label: Text(locale.getText(key: 'ocr_scanner_camera')),
//                 onPressed: () => _getImage(ImageSource.camera),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           if (_image != null)
//             Container(
//               height: 180,
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: FileImage(_image!),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           if (_isLoading) const CircularProgressIndicator(),
//           const SizedBox(height: 20),
//
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: locale.getText(key: 'full_name'),
//               border: const OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _contactNumberController,
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(
//               labelText: locale.getText(key: 'contact_number'),
//               border: const OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           Column(
//             children: List.generate(_contactControllers.length, (index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6),
//                 child: TextField(
//                   controller: _contactControllers[index],
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "${locale.getText(key: 'contact_number')} ${index + 1}",
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: TextButton.icon(
//               onPressed: _addContactField,
//               icon: const Icon(Icons.add),
//               label: Text(locale.getText(key: 'add_contact')),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           TextField(
//             controller: _addressController,
//             maxLines: 2,
//             decoration: InputDecoration(
//               labelText: locale.getText(key: 'address'),
//               border: const OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           Column(
//             children: List.generate(_socialControllers.length, (index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6),
//                 child: TextField(
//                   controller: _socialControllers[index],
//                   decoration: InputDecoration(
//                     labelText: "${locale.getText(key: 'social_link')} ${index + 1}",
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: TextButton.icon(
//               onPressed: _addSocialField,
//               icon: const Icon(Icons.add_link),
//               label: Text(locale.getText(key: 'add_social')),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isSaving ? null : _saveContact,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               child: _isSaving
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : Text(locale.getText(key: 'save_contact')),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           if (_scannedText.isNotEmpty)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(_scannedText,
//                   style: const TextStyle(fontSize: 14, color: Colors.black)),
//             ),
//         ],
//       ),
//     );
//   }
// }
//

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/address.dart';
import 'package:flutter_contacts/properties/email.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../providers/locale_provider.dart';

class OCRScannerPage extends StatefulWidget {
  const OCRScannerPage({Key? key}) : super(key: key);

  @override
  State<OCRScannerPage> createState() => _OCRScannerPageState();
}

class _OCRScannerPageState extends State<OCRScannerPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String _scannedText = "";

  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final List<TextEditingController> _contactControllers = [TextEditingController()];
  final List<TextEditingController> _socialControllers = [TextEditingController()];

  File? _image;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) {
      _showPermissionDialog();
      return;
    }

    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);

    await _cameraController!.initialize();

    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text("Please grant camera access to use the OCR scanner."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _cameraController == null) return;

    try {
      final picture = await _cameraController!.takePicture();
      _image = File(picture.path);

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = false; // Hide camera after taking a picture
      });

      await _processImage(_image!);
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _processImage(_image!);
    }
  }

  Future<void> _processImage(File imageFile) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      final extracted = recognizedText.text;

      if (!mounted) return;
      setState(() {
        _scannedText = extracted.isEmpty ? "No text found" : extracted;
      });

      _extractName(extracted);
      _extractAddress(extracted);
      _extractContactNumber(extracted);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _scannedText = "Error: $e";
      });
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _extractName(String text) {
    final lines = text.split("\n");
    for (var line in lines) {
      if (line.trim().split(" ").length >= 2 && line.length < 40) {
        _nameController.text = line.trim();
        break;
      }
    }
  }

  void _extractAddress(String text) {
    final lines = text.split("\n");
    for (var line in lines) {
      if (line.contains(RegExp(r'\d')) &&
          (line.toLowerCase().contains('street') ||
              line.toLowerCase().contains('road') ||
              line.toLowerCase().contains('ave') ||
              line.toLowerCase().contains('ln') ||
              line.toLowerCase().contains('purok') ||
              line.toLowerCase().contains('brgy'))) {
        _addressController.text = line.trim();
        break;
      }
    }
  }

  void _extractContactNumber(String text) {
    final RegExp phoneRegex = RegExp(
      r'(\+?\d{1,3}[\s-]?)?(\d{2,4}[\s-]?)?\d{6,10}',
    );
    final matches = phoneRegex.allMatches(text);
    if (matches.isNotEmpty) {
      final rawNumber = matches.first.group(0) ?? '';
      final cleanedNumber = rawNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      _contactNumberController.text = cleanedNumber;
    }
  }

  Future<void> _saveContact() async {
    setState(() => _isSaving = true);

    if (!await FlutterContacts.requestPermission()) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied: Cannot save contact")),
      );
      return;
    }

    try {
      final newContact = Contact()
        ..name.first = _nameController.text.trim()
        ..addresses = [
          Address(_addressController.text.trim(), label: AddressLabel.home),
        ]
        ..phones = [
          if (_contactNumberController.text.isNotEmpty)
            Phone(_contactNumberController.text.trim(), label: PhoneLabel.mobile),
        ]
        ..emails = _socialControllers
            .map((c) => Email(c.text.trim(), label: EmailLabel.work))
            .where((e) => e.address.isNotEmpty)
            .toList();

      await newContact.insert();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Contact saved to phonebook!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving contact: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    textRecognizer.close();
    _nameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    for (var c in _contactControllers) {
      c.dispose();
    }
    for (var c in _socialControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized && _cameraController != null)
            CameraPreview(_cameraController!),

          // Black overlay
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // UI overlay
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "OCR Scanner",
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(),

                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.white)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: "gallery",
                        onPressed: _pickFromGallery,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.photo, color: Colors.black),
                      ),
                      FloatingActionButton(
                        heroTag: "camera",
                        onPressed: _takePicture,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ],
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          if (_scannedText.isNotEmpty && !_isLoading)
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (context, scrollController) => Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Full Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contactNumberController,
                      decoration: const InputDecoration(labelText: "Contact Number"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: "Address"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveContact,
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Contact"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

