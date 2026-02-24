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
    // _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) {
      _showPermissionDialog();
      return;
    }

    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium,enableAudio: false);

    await _cameraController!.initialize();

    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
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

  Future<void> _openCameraDialog() async {
    // 1. Request camera permission
    final status = await Permission.camera.status;

    // 1️⃣ If permanently denied → show settings dialog
    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      return;
    }

    // 2️⃣ If not granted → request permission (shows iOS popup)
    if (!status.isGranted) {
      final result = await Permission.camera.request();

      if (!result.isGranted) {
        // Just return silently or show simple explanation
        return;
      }
    }

    // 3️⃣ Continue with camera
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No camera available")),
      );
      return;
    }

    final controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();

    File? capturedImage;

    // 3. Show camera preview in dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  // Camera preview
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    child: Stack(
                      children: [
                        CameraPreview(controller),
                        if (capturedImage != null)
                          Image.file(capturedImage!, fit: BoxFit.cover),
                      ],
                    ),
                  ),

                  // Close button (always visible)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: FloatingActionButton(
                      heroTag: "close_camera",
                      mini: true,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.close),
                      onPressed: () {
                        controller.dispose();
                        Navigator.pop(context); // Close dialog
                      },
                    ),
                  ),

                  // Capture / Confirm / Retake buttons
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (capturedImage != null)
                          FloatingActionButton(
                            heroTag: "retake",
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.close),
                            onPressed: () {
                              setState(() => capturedImage = null);
                            },
                          ),
                        FloatingActionButton(
                          heroTag: "capture_confirm",
                          backgroundColor: Colors.white,
                          child: Icon(
                            capturedImage == null ? Icons.camera_alt : Icons.check,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            if (capturedImage == null) {
                              // Take photo
                              final picture = await controller.takePicture();
                              setState(() => capturedImage = File(picture.path));
                            } else {
                              // Confirm photo
                              Navigator.pop(context);
                              await _processImage(capturedImage!);
                              controller.dispose();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text(
          "Camera access is required to take photos. "
              "Please enable it in Settings.",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              openAppSettings();
            },
          ),
        ],
      ),
    );
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

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            // Top bar with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _scannedText = ""; // Hide the sheet
                        _image = null;     // Optional: clear image
                      });
                    },
                  ),
                ),
              ],
            ),

            Expanded(
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
          ],
        ),
      ),
    );
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
    return Scaffold(
      backgroundColor: Colors.white, // Changed from black to white
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "OCR Scanner",
                  style: TextStyle(
                    color: Colors.black, // Black text on white
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),

                // Scan icon / instruction
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.2),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          onEnd: () {
                            setState(() {}); // Repeat animation
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            size: 120,
                            color: Colors.grey, // visible on white
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Tap Camera or Gallery to scan",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.black)
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: "gallery",
                          onPressed: _pickFromGallery,
                          backgroundColor: Colors.black,
                          child: const Icon(Icons.photo, color: Colors.white),
                        ),
                        FloatingActionButton(
                          heroTag: "camera",
                          onPressed: _openCameraDialog,
                          backgroundColor: Colors.black,
                          child: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Draggable sheet with scanned data
            if (_scannedText.isNotEmpty && !_isLoading)
              _buildDraggableSheet(),
          ],
        ),
      ),
    );
  }





}

