// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../../../providers/locale_provider.dart';
// import 'home_page.dart';
//
// class UserProfilePage extends StatelessWidget {
//   UserProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final locale = Provider.of<LocaleProvider>(context);
//
//     final List<Map<String, dynamic>> dynamicCardData = [
//       {
//         'business_profile': 'business_profile',
//         'connections': '120',
//         'imageUrl': 'https://randomuser.me/api/portraits/men/11.jpg',
//         'name': 'Robert Fox',
//         'designation': 'CEO at Orbix Design Studio',
//         'isDirect': true,
//       },
//       {
//         'business_profile': 'business_profile',
//         'connections': '98',
//         'imageUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
//         'name': 'Jane Doe',
//         'designation': 'Marketing Manager',
//         'isDirect': false,
//       },
//       {
//         'business_profile': 'business_profile',
//         'connections': '76',
//         'imageUrl': 'https://randomuser.me/api/portraits/men/33.jpg',
//         'name': 'John Smith',
//         'designation': 'Software Engineer',
//         'isDirect': true,
//       },
//     ];
//     final List<Map<String, dynamic>> dynamicCardDataNew = [
//
//     ];
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text("",style: TextStyle(color: Colors.black),),
//           SizedBox(
//             height: 400,
//             width: MediaQuery.of(context).size.width,
//             child: dynamicCardDataNew.isNotEmpty ? CardSwiper(
//               cardsCount: dynamicCardData.length,
//
//               cardBuilder: (context, index) {
//
//                 final cardData = dynamicCardData[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey.shade300, // Choose your border color
//                       width: 1.0, // Choose your border width
//                     ),
//                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))],
//                     borderRadius: BorderRadius.circular(16.0), // Optional: if you want rounded corners for the border
//                   ),
//                   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // 🔹 FIX: Full width row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             locale.getText(
//                                 key: cardData['business_profile']),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.share, color: Colors.black54),
//                             onPressed: () {
//                               final cardDetails = "Name: ${cardData['name']}\nDesignation: ${cardData['designation']}\nConnections: ${cardData['connections']}";
//                               SharePlus.instance.share(
//                                   ShareParams(
//                                     title: cardData['name'],
//                                     subject: "CALLME - Digital Business Card",
//                                     previewThumbnail: XFile(Uri.parse(cardData['imageUrl']).toString()),
//                                     text: cardDetails,
//                                   )
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 20),
//                                 CircleAvatar(
//                                   radius: 35,
//                                   backgroundImage: NetworkImage(cardData['imageUrl']),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   cardData['name'],
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                                 Text(
//                                   cardData['designation'],
//                                   style: const TextStyle(
//                                     color: Colors.black54,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 cardData['connections'],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Text(
//                                 locale.getText(key: 'connected'),
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             locale.getText(key: 'your_links'),
//                             style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 locale.getText(key: 'direct'),
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Switch(
//                                 value: cardData['isDirect'],
//                                 onChanged: (val) {
//                                   // TODO: update logic
//                                 },
//                                 activeColor: Colors.green,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ):Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.grey.shade300, // Choose your border color
//                   width: 1.0, // Choose your border width
//                 ),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))],
//                 borderRadius: BorderRadius.circular(16.0), // Optional: if you want rounded corners for the border
//               ),
//               margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: Image.asset('assets/no_cards.jpg',),
//               ),
//             ),
//           ),
//           // 🔹 Business Profile Cards
//           // SizedBox(
//           //   height: 320,
//           //   // width: MediaQuery.of(context).size.width,
//           //   child: ListView.builder(
//           //     shrinkWrap: true,
//           //     itemCount: dynamicCardData.length,
//           //     itemBuilder: (context, index) {
//           //       final cardData = dynamicCardData[index];
//           //       return Container(
//           //         decoration: BoxDecoration(
//           //           border: Border.all(
//           //             color: Colors.grey.shade300, // Choose your border color
//           //             width: 1.0, // Choose your border width
//           //           ),
//           //           borderRadius: BorderRadius.circular(8.0), // Optional: if you want rounded corners for the border
//           //         ),
//           //         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
//           //         padding: const EdgeInsets.all(16),
//           //         child: Column(
//           //           crossAxisAlignment: CrossAxisAlignment.start,
//           //           children: [
//           //             // 🔹 FIX: Full width row
//           //             SizedBox(
//           //               child: Row(
//           //                 children: [
//           //                   Text(
//           //                     locale.getText(
//           //                         key: cardData['business_profile']),
//           //                     style: const TextStyle(
//           //                       fontWeight: FontWeight.w500,
//           //                       fontSize: 14,
//           //                       color: Colors.black54,
//           //                     ),
//           //                   ),
//           //                   const Spacer(),
//           //                   Column(
//           //                     children: [
//           //                       Text(
//           //                         cardData['connections'],
//           //                         style: const TextStyle(
//           //                           fontWeight: FontWeight.bold,
//           //                           fontSize: 20,
//           //                           color: Colors.black54,
//           //                         ),
//           //                       ),
//           //                       Text(
//           //                         locale.getText(key: 'connected'),
//           //                         style: const TextStyle(
//           //                           fontSize: 12,
//           //                           color: Colors.black54,
//           //                         ),
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 ],
//           //               ),
//           //             ),
//           //
//           //             const SizedBox(height: 20),
//           //             CircleAvatar(
//           //               radius: 35,
//           //               backgroundImage: NetworkImage(cardData['imageUrl']),
//           //             ),
//           //             const SizedBox(height: 12),
//           //             Text(
//           //               cardData['name'],
//           //               style: const TextStyle(
//           //                 fontSize: 18,
//           //                 fontWeight: FontWeight.bold,
//           //                 color: Colors.black54,
//           //               ),
//           //             ),
//           //             Text(
//           //               cardData['designation'],
//           //               style: const TextStyle(
//           //                 color: Colors.black54,
//           //                 fontSize: 13,
//           //               ),
//           //             ),
//           //             const SizedBox(height: 20),
//           //             Row(
//           //               children: [
//           //                 Text(
//           //                   locale.getText(key: 'your_links'),
//           //                   style: const TextStyle(
//           //                     fontSize: 14,
//           //                     color: Colors.black54,
//           //                   ),
//           //                 ),
//           //                 const Spacer(),
//           //                 Row(
//           //                   children: [
//           //                     Text(
//           //                       locale.getText(key: 'direct'),
//           //                       style: const TextStyle(
//           //                         fontSize: 14,
//           //                         color: Colors.black,
//           //                       ),
//           //                     ),
//           //                     Switch(
//           //                       value: cardData['isDirect'],
//           //                       onChanged: (val) {
//           //                         // TODO: update logic
//           //                       },
//           //                       activeColor: Colors.green,
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ],
//           //             ),
//           //           ],
//           //         ),
//           //       );
//           //     },
//           //   ),
//           // ),
//
//           const SizedBox(height: 20),
//           // 🔹 Add New Section
//           GestureDetector(
//             onTap: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomePage(parentPageId: 120)),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(25), // Adjust the radius as needed
//               ),
//               padding: EdgeInsets.only(left: 10,right: 10),
//               height: 60,
//               child: Row(
//                 children: [
//                   Text(
//                     locale.getText(key: 'add_new'),
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Spacer(),
//                   CircleAvatar(
//                     radius: 22,
//                     backgroundColor: Colors.grey[200],
//                     child: const Icon(Icons.add, color: Colors.black87),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               locale.getText(key: 'addNewDesc'),
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // 🔹 Social Links & Recent Connected
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Active Social
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.access_time_filled_rounded,
//                                 color: Colors.red),
//                             SizedBox(width: 8),
//                             Icon(Icons.snapchat, color: Colors.yellow),
//                             SizedBox(width: 8),
//                             Icon(Icons.add_chart_sharp, color: Colors.blue),
//                             SizedBox(width: 8),
//                             Icon(Icons.access_time,
//                                 color: Colors.blueAccent),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           "05",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           locale.getText(key: 'active_social'),
//                           style: const TextStyle(
//                             fontSize: 13,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               // Recent Connected
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           locale.getText(key: 'recentConnected'),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         _buildRecentItem("Bessie", "Los Angeles, CA"),
//                         _buildRecentItem("Julie", "Los Angeles, CA"),
//                         _buildRecentItem("Regina", "Los Angeles, CA"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // 🔹 Upgrade Button
//           ElevatedButton.icon(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             icon: const Icon(Icons.upgrade, color: Colors.white),
//             label: Text(
//               locale.getText(key: 'upgrade'),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Container> cards = [
//     Container(
//       alignment: Alignment.center,
//       child: const Text('1'),
//       color: Colors.blue,
//     ),
//     Container(
//       alignment: Alignment.center,
//       child: const Text('2'),
//       color: Colors.red,
//     ),
//     Container(
//       alignment: Alignment.center,
//       child: const Text('3'),
//       color: Colors.purple,
//     )
//   ];
//
//   Widget _buildRecentItem(String name, String location) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 16,
//             backgroundImage: NetworkImage(
//               "https://randomuser.me/api/portraits/women/44.jpg",
//             ),
//           ),
//           const SizedBox(width: 5),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 location,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.black26,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.more_vert, size: 12),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:googleapis/connectors/v1.dart' hide Provider;
import 'package:path_provider/path_provider.dart';
import 'package:profio/core/helpers/global_helper.dart';
import 'package:profio/features/services/api_constants.dart';
import 'package:profio/features/services/api_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/template.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import '../../../../providers/locale_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


//
// class UserProfilePage extends StatefulWidget {
//   const UserProfilePage({super.key});
//
//   @override
//   State<UserProfilePage> createState() => _UserProfilePageState();
// }
//
// class _UserProfilePageState extends State<UserProfilePage> {
//   late Future<List<Template>> templatesFuture;
//   Map<String,dynamic> userDetails = {};
//   String appLanguage = "en";
//   late LocaleProvider localeProvider;
//   late VoidCallback listener;
//
//   @override
//   void initState() {
//     super.initState();
//     templatesFuture = getTemplates();
//
//     listener = () {
//       if (mounted) {
//         appLanguage = localeProvider.currentLanguageCode ?? "";
//         print("LanguageChanged:${appLanguage} -- ${localeProvider.currentLanguage}");
//       }
//     };
//
//     // ✅ Safe way to access Provider after the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       localeProvider = Provider.of<LocaleProvider>(context, listen: false);
//       localeProvider.addListener(listener);
//     });
//   }
//
//
//   Future<List<Template>> getTemplates() async {
//     List<Template> results = [];
//     userDetails = await getUserByUUID();
//     var allTemplates = await getAllTemplates(1);
//     if(allTemplates.isNotEmpty){
//       var userTemplates = await getAllTemplates(2);
//       if (userTemplates.isNotEmpty) {
//         results = allTemplates.where((allTemplate) {
//           // Find a matching user template based on id
//           var matchingUserTemplate = userTemplates.firstWhere(
//                 (userTemplate) => userTemplate.id == allTemplate.id,
//             orElse: () => Template(), // Empty template if no match
//           );
//
//           if ((matchingUserTemplate.id ?? "").isNotEmpty) {
//             // Found a match → mark selected
//             allTemplate.isAlreadySelected = true;
//             // Optionally assign userTemplateId
//             // allTemplate.userTemplateId = matchingUserTemplate.userTemplateId ?? "";
//             return true; // keep this template
//           }
//           return false; // skip if no match
//         }).toList();
//       }
//       else{
//         results = allTemplates;
//       }
//     }
//
//
//
//     return results;
//   }
//
//   void refreshTemplates() {
//     setState(() {
//       templatesFuture = getTemplates(); // Call the future again
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     int selectedTemplateCount = 0;
//     return FutureBuilder(
//         future: templatesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('❌ Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text(getText("no_templates_available")));
//           }
//
//           final allTemplates = snapshot.data ?? [];
//           int selectedTemplateCount = allTemplates.where((t) => t.isAlreadySelected ?? false).length;
//
//
//
//           return ListView.builder(
//             itemCount: allTemplates.length,
//             itemBuilder: (context, index) {
//               // Create Template instance from JSON
//               Template template = allTemplates[index];
//
//               return SlidableAutoCloseBehavior(
//                 key: Key(template.id ?? ''),
//                 closeWhenTapped: true,
//                 child: GestureDetector(
//                     onTap: (){
//                       _showFullImage(context,template.previewImage ?? "");
//                     },
//                     child: Card(
//                       margin: const EdgeInsets.all(12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                       elevation: 6,
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.5, // NEW HEIGHT
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           image: DecorationImage(
//                             image: NetworkImage(template.previewImage ?? ""),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.black.withOpacity(0.1),
//                                 Colors.black.withOpacity(0.4),
//                                 Colors.black.withOpacity(0.7),
//                               ],
//                             ),
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // ---------- TOP TITLE ----------
//                               Text(
//                                 template.name ?? "Template Name",
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 8),
//
//                               // ---------- DESCRIPTION ----------
//                               Text(
//                                 template.description ?? "Template Description",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white70,
//                                   height: 1.4,
//                                 ),
//                                 maxLines: 4,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//
//                               const Spacer(),
//
//                               // ---------- BOTTOM ACTION BUTTONS ----------
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   // Preview icon
//                                   Visibility(
//                                     visible: template.isAlreadySelected ?? false,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         showHtmlDialog(
//                                           context: context,
//                                           htmlTemplate: template.htmlContent ?? "",
//                                           data: userDetails ?? {},
//                                         );
//                                       },
//                                       child: CircleAvatar(
//                                         radius: 20,
//                                         backgroundColor: Colors.black.withOpacity(0.6),
//                                         child: const Icon(Icons.visibility, color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//
//                                   SizedBox(width: 12),
//
//                                   // Add / Selected icon
//                                   GestureDetector(
//                                     onTap: null,
//                                     child: CircleAvatar(
//                                       radius: 20,
//                                       backgroundColor: (template.isAlreadySelected ?? false)
//                                           ? Colors.green
//                                           : Colors.blueAccent,
//                                       child: Icon(
//                                         (template.isAlreadySelected ?? false)
//                                             ? Icons.check_circle
//                                             : Icons.add_circle_outline,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//
//                                   SizedBox(width: 12),
//
//                                   // Share icon
//                                   Visibility(
//                                     visible: template.isAlreadySelected ?? false,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         _showConfirmationDialog(context, template.id ?? "");
//                                       },
//                                       child: CircleAvatar(
//                                         radius: 20,
//                                         backgroundColor: Colors.orange,
//                                         child: const Icon(Icons.share_rounded,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                 ),
//               );
//             },
//           );
//         }
//     );
//   }
//
//
//   String getText(String title){
//     return localeProvider.getText(key: title);
//   }
//
//
//
//
//   // Function to show the full-size image
//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           Dialog(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop(); // Close the dialog when tapped
//               },
//               child: InteractiveViewer(
//                 child: Image.network(imageUrl),
//               ),
//             ),
//           ),
//     );
//   }
//
//   void showHtmlDialog({
//     required BuildContext context,
//     required String htmlTemplate,
//     required Map<String, dynamic> data,
//   }) {
//     final renderedHtml = renderHtmlContent(
//       html: htmlTemplate,
//       data: data,
//       selectedLang: appLanguage,
//     );
//
//     log("CheckHtml:${renderedHtml}");
//
//     bool isLoading = true;
//     final controller = WebViewController()
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (url) {
//             // When HTML is done rendering
//             isLoading = false;
//           },
//         ),
//       )
//       ..loadHtmlString(renderedHtml);
//
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         final height = MediaQuery.of(context).size.height * 0.9;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             // Update when loading finishes
//             controller.setNavigationDelegate(
//               NavigationDelegate(
//                 onPageFinished: (url) {
//                   setState(() => isLoading = false);
//                 },
//               ),
//             );
//
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               insetPadding: const EdgeInsets.all(16),
//               child: Container(
//                 padding: EdgeInsets.zero,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Stack(
//                   children: [
//                     // WebView
//                     SizedBox(
//                       width: double.maxFinite,
//                       height: height,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: WebViewWidget(controller: controller),
//                       ),
//                     ),
//
//                     // Loading overlay
//                     if (isLoading)
//                       Container(
//                         width: double.infinity,
//                         height: height,
//                         alignment: Alignment.center,
//                         color: Colors.white.withOpacity(0.7),
//                         child: const CircularProgressIndicator(),
//                       ),
//
//                     // Close button
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Material(
//                         color: Colors.white,
//                         shape: const CircleBorder(),
//                         elevation: 3,
//                         child: InkWell(
//                           customBorder: const CircleBorder(),
//                           onTap: () => Navigator.pop(context),
//                           child: const Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Icon(
//                               Icons.close,
//                               size: 20,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//
//
//
//
//
//
//
// }




class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isReady = false;
  late WebViewController controller;
  String appLanguage = "en";
  late LocaleProvider localeProvider;
  late VoidCallback listener;
  Map<String,dynamic> userDetails = {};
  List<Template> results = [];

  @override
  void initState() {
    super.initState();


    listener = () {
      if (mounted) {
        appLanguage = localeProvider.currentLanguageCode ?? "";
        print("LanguageChanged:${appLanguage} -- ${localeProvider.currentLanguage}");
      }
    };

    // ✅ Safe way to access Provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      localeProvider.addListener(listener);
    });

    getTemplates();

  }


  Future<void> getTemplates() async {
    userDetails = await getUserByUUID();
    var allTemplates = await getAllTemplates(1);
    if(allTemplates.isNotEmpty){
      var userTemplates = await getAllTemplates(2);
      if (userTemplates.isNotEmpty) {
        results = allTemplates.where((allTemplate) {
          // Find a matching user template based on id
          var matchingUserTemplate = userTemplates.firstWhere(
                (userTemplate) => userTemplate.id == allTemplate.id,
            orElse: () => Template(), // Empty template if no match
          );

          if ((matchingUserTemplate.id ?? "").isNotEmpty) {
            // Found a match → mark selected
            allTemplate.isAlreadySelected = true;
            // Optionally assign userTemplateId
            // allTemplate.userTemplateId = matchingUserTemplate.userTemplateId ?? "";
            return true; // keep this template
          }
          return false; // skip if no match
        }).toList();
      }
      else{
        results = allTemplates;
      }
    }
    if(results.isNotEmpty) {
      var htmlContent = renderHtmlContent(html: results[0].htmlContent ?? "",
          data: userDetails,
          selectedLang: appLanguage);


      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              setState(() {
                _isReady = true;
              });
            },
          ),
        )
        ..loadHtmlString(htmlContent);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- CARD CONTAINER ---
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, '/payment');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.green[600],
            //         shape: const StadiumBorder(),
            //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            //         minimumSize: const Size(0, 0), // allows small buttons
            //       ),
            //       child: const Text(
            //         "Upgrade",
            //         style: TextStyle(fontSize: 13),
            //       ),
            //     ),
            //
            //     const SizedBox(width: 8),
            //
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, '/all_template');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.black,
            //         shape: const StadiumBorder(),
            //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            //         minimumSize: const Size(0, 0),
            //       ),
            //       child: const Text(
            //         "Create +",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 13,
            //         ),
            //       ),
            //     ),
            //
            //     const SizedBox(width: 10),
            //
            //   ],
            // ),
            !_isReady ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A38),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: WebViewWidget(controller: controller),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // --- ICON ROW (Removed View Icon) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(Icons.edit, size: 28, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            const Text("Edit",style: TextStyle(color: Colors.black),)
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/payment');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(Icons.account_balance_wallet,
                                  size: 28, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            const Text("Wallet",style: TextStyle(color: Colors.black),)
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // --- SHARE BUTTON (smaller) ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(results.isNotEmpty){
                          _showConfirmationDialog(context,results[0].id ?? "");
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("❌ ${getText("template_link_generation_failed")}")),
                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 10), // smaller
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(0, 30), // smaller height
                      ),
                      child: const Text(
                        "Share Card",
                        style: TextStyle(
                          fontSize: 14,  // smaller text
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                                ],
                              ),
                ),


          ],
        ),
      ),
    );
  }
  String getText(String title){
    return localeProvider.getText(key: title);
  }

  void _showConfirmationDialog(BuildContext context,String templateId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(getText("share_template")),
        content: Text(getText("confirm_share_link"),style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
            },
            child: Text(getText("no")),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save the parent context before dismissing the dialog
              final scaffoldContext = context; // Use outer context, not ctx from dialog

              Navigator.of(ctx).pop(); // close dialog

              // Show a loading dialog or progress indicator
              GlobalHelper().progressDialog(scaffoldContext,getText("template_share"), getText("link_generating_wait"));

              // Generate the URL
              String url = await shareUserTemplate(appUserId, templateId);



              // Close the progress dialog
              Navigator.of(scaffoldContext).pop();

              if (url.isNotEmpty) {

                // Download profile picture

                final response = await getThumbnailUserImage(userDetails);

                // Save to temporary directory
                final tempDir = await getTemporaryDirectory();
                final file = File('${tempDir.path}/profile_thumbnail.jpg');
                await file.writeAsBytes(response.bodyBytes);


                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(file.path)],
                    text: url,
                    subject: getText("profio_user_template"), // subject can change what as user need

                    //uri: Uri.parse(url)
                  ),
                );
              } else {
                // Show the snackbar using scaffoldContext (not ctx)
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(content: Text("❌ ${getText("template_link_generation_failed")}")),
                );
              }
            },
            child: Text(getText("yes")),
          ),
        ],
      ),
    );
  }
}



String renderHtmlContent({
    required String html,
    required Map<String, dynamic> data,
    required String selectedLang,
  }) {
    final regex = RegExp(r'\{\{(\w+)\}\}');

    return html.replaceAllMapped(regex, (match) {
      final key = match.group(1)!;
      // log("CheckUSerData:${data}");
      log("CheckValue-Before:${key}");
      if (!data.containsKey(key)) return '';

      final value = data[key];
      log("CheckValue:${value} -- ${key}");
      if(key == "profileImageURL"){
        return fetchImage(data['_id'] ?? "","PROFILE", value);
      }
      if (value is String) {
        return value;
      } else if (value is Map<String, dynamic>) {
        // Handle localized values like {en: ..., ja: ...}
        return value[selectedLang]?.toString() ?? '';
      } else {
        return value?.toString() ?? '';
      }
    });
  }















