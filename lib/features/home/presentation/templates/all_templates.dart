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
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/template.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import '../../../../providers/locale_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../home/home_page.dart';


class AllTemplatesPage extends StatefulWidget {
  const AllTemplatesPage({super.key});

  @override
  State<AllTemplatesPage> createState() => _AllTemplatesPageState();
}

class _AllTemplatesPageState extends State<AllTemplatesPage> {
  late Future<List<Template>> templatesFuture;
  Map<String, dynamic> userDetails = {};
  String appLanguage = "en";
  late LocaleProvider localeProvider;
  late VoidCallback listener;
  List<WebViewController> webControllers = [];

  @override
  void initState() {
    super.initState();
    templatesFuture = getTemplates();

    listener = () {
      if (mounted) {
        appLanguage = localeProvider.currentLanguageCode ?? "";
        print(
          "LanguageChanged:${appLanguage} -- ${localeProvider.currentLanguage}",
        );
      }
    };

    // ✅ Safe way to access Provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      localeProvider.addListener(listener);
    });
  }

  Future<List<Template>> getTemplates() async {
    List<Template> results = [];
    userDetails = await getUserByUUID();
    var allTemplates = await getAllTemplates(1);
    if (allTemplates.isNotEmpty) {
      var userTemplates = await getAllTemplates(2);
      if (userTemplates.isNotEmpty) {
        results =
            allTemplates.map((allTemplate) {
              // Find a matching user template based on the id
              var matchingUserTemplate = userTemplates.firstWhere(
                (userTemplate) => userTemplate.id == allTemplate.id,
                orElse: () => Template(), // Return null if no match is found
              );

              // If a match is found, set 'selected' to true
              if ((matchingUserTemplate.id ?? "") != "") {
                print("CheckMatchingTempalte: ${matchingUserTemplate.name}");
                allTemplate.isAlreadySelected = true;
                // allTemplate.userTemplateId = matchingUserTemplate.userTemplateId ?? "";
              }

              // Return the modified or unchanged allTemplate
              return allTemplate;
            }).toList();
        initWebControllers(results);
      } else {
        results = allTemplates;
        initWebControllers(results);
      }
    }

    return results;
  }

  void refreshTemplates() {
    setState(() {
      templatesFuture = getTemplates(); // Call the future again
    });
  }

  void initWebControllers(List<Template> templates) {
    webControllers = List.generate(templates.length, (index) {
      final controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadHtmlString(templates[index].htmlContent ?? "");
      return controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedTemplateCount = 0;
    int selectedCardIndex = 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    PageController _pageController = PageController(viewportFraction: 0.7);
    final ScrollController _scrollController = ScrollController();
    double _scrollOffset = 0;
    int _currentPage = 0;
    return FutureBuilder(
      future: templatesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('❌ Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(getText("no_templates_available")));
        }

        final allTemplates = snapshot.data ?? [];
        int selectedTemplateCount =
            allTemplates.where((t) => t.isAlreadySelected ?? false).length;
        // Fixed sizes for cards
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = screenWidth * 0.8;
        final cardHeight = screenHeight * 0.55;


        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: allTemplates.length,
              options: CarouselOptions(
                height: screenHeight * 0.75, // extra for title
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final template = allTemplates[index];
                final controller = webControllers[index];

                return GestureDetector(
                  onTap: (){
                    _showFullImage(context,template.previewImage ?? "");
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // ---------------------------
                      // TITLE
                      // ---------------------------
                      Text(
                        template.name ?? "Template Name",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // ---------------------------
                      // CARD WITH STACK
                      // ---------------------------
                      SizedBox(
                        height: cardHeight,
                        child: Stack(
                          children: [
                            // Card
                            Card(
                              elevation: (template.isAlreadySelected ?? false) ? 12 : 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    // ---------------------------
                                    // WEBVIEW
                                    // ---------------------------
                                    WebViewWidget(
                                      controller: webControllers[index],
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                        Factory<VerticalDragGestureRecognizer>(
                                              () => VerticalDragGestureRecognizer(),
                                        ),
                                      },
                                    ),

                                    // ---------------------------
                                    // GRADIENT
                                    // ---------------------------
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.black.withOpacity(0.45),
                                              Colors.black.withOpacity(0.75),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ---------------------------
                                    // BUTTONS AT BOTTOM
                                    // ---------------------------
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // Preview
                                          GestureDetector(
                                            onTap: () {
                                              showHtmlDialog(
                                                context: context,
                                                htmlTemplate: template.htmlContent ?? "",
                                                data: userDetails ?? {},
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.black.withOpacity(0.6),
                                              child: const Icon(Icons.visibility,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Add / Selected
                                          GestureDetector(
                                            onTap: !(template.isAlreadySelected ?? false)
                                                ? () {
                                              if ((userSubscribedPlan.cardTemplateLimit ??
                                                  1) >
                                                  selectedTemplateCount) {
                                                selectTemplate(
                                                    context, template.id ?? "");
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "${getText("template_limit_reached")} $warmingIcon"),
                                                  ),
                                                );
                                              }
                                            }:(){
                                              _showConfirmationDialogDeselectTemplate( context, template.id ?? "", userDetails["_id"] ?? "", );
                                            },
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                              (template.isAlreadySelected ?? false)
                                                  ? Colors.green
                                                  : Colors.blueAccent,
                                              child: Icon(
                                                (template.isAlreadySelected ?? false)
                                                    ? Icons.check_circle
                                                    : Icons.add_circle_outline,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Share only when selected
                                          if (template.isAlreadySelected ?? false)
                                            GestureDetector(
                                              onTap: () {
                                                _showConfirmationDialog(
                                                    context, template.id ?? "");
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.orange,
                                                child: const Icon(Icons.share_rounded,
                                                    color: Colors.white),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ---------------------------
                            // UPGRADE RIBBON
                            // ---------------------------
                            Visibility(
                              visible:!(template.isAlreadySelected ?? false),
                              child: Positioned(
                                top: -2,
                                right: -2,
                                child: GestureDetector(
                                  onTap:(){
                                    _showConfirmationDialogUpgradePackage(context);
                                  },
                                  child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.20),
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      "UPGRADE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

              },
            ),
          ],
        );




      },
    );
  }

  String getText(String title) {
    return localeProvider.getText(key: title);
  }

  void selectTemplate(BuildContext context, String templateId) async {
    GlobalHelper().progressDialog(
      context,
      getText("selecting_template"),
      getText("processing_selection"),
    );

    var result = await createTemplateForUser(appUserId, templateId);
    Navigator.of(context).pop();
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${getText("template_selected_success")} $successIcon"),
        ),
      );
      refreshTemplates();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${getText("template_selected_failed")} $failedIcon"),
        ),
      );
    }
  }

  void _showConfirmationDialogDeselectTemplate(
    BuildContext context,
    String templateId,
    String userId,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(getText("deselect_template")),
            content: Text(
              getText("confirm_deselect_template"),
              style: TextStyle(color: Colors.black),
            ),
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
                  final scaffoldContext =
                      context; // Use outer context, not ctx from dialog

                  Navigator.of(ctx).pop(); // close dialog

                  // Show a loading dialog or progress indicator
                  GlobalHelper().progressDialog(
                    scaffoldContext,
                    getText("template_deselect"),
                    getText("template_deselecting_wait"),
                  );

                  // Generate the URL
                  bool result = await deleteSelectedTemplate(
                    userId,
                    templateId,
                  );

                  // Close the progress dialog
                  Navigator.of(scaffoldContext).pop();

                  if (result) {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${getText("template_deselect_success")} ${successIcon}",
                        ),
                      ),
                    );
                    refreshTemplates();
                  } else {
                    // Show the snackbar using scaffoldContext (not ctx)
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${getText("template_deselect_failed")} ${failedIcon}",
                        ),
                      ),
                    );
                  }
                },
                child: Text(getText("yes")),
              ),
            ],
          ),
    );
  }

  void _showConfirmationDialogUpgradePackage(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
        title: Text(getText("upgrade_package")),
        content: Text(
          getText("upgrade_package_confirmation"),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
            },
            child: Text(getText("no")),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(parentPageId: 100)),
              );
            },
            child: Text(getText("yes")),
          ),
        ],
      ),
    );
  }


  // Function to show the full-size image
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog when tapped
              },
              child: InteractiveViewer(child: Image.network(imageUrl)),
            ),
          ),
    );
  }

  void showHtmlDialog({
    required BuildContext context,
    required String htmlTemplate,
    required Map<String, dynamic> data,
    bool isShouldRender = true
  }) {
    String renderedHtml = "";
    if(isShouldRender){
       renderedHtml = renderHtmlContent(
        html: htmlTemplate,
        data: data,
        selectedLang: appLanguage,
      );

    }else{
      renderedHtml = htmlTemplate;
    }

    log("CheckHtml:${renderedHtml}");

    bool isLoading = true;
    final controller =
        WebViewController()
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) {
                // When HTML is done rendering
                isLoading = false;
              },
            ),
          )
          ..loadHtmlString(renderedHtml);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final height = MediaQuery.of(context).size.height * 0.9;

        return StatefulBuilder(
          builder: (context, setState) {
            // Update when loading finishes
            controller.setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (url) {
                  setState(() => isLoading = false);
                },
              ),
            );

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // WebView
                    SizedBox(
                      width: double.maxFinite,
                      height: height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: WebViewWidget(controller: controller),
                      ),
                    ),

                    // Loading overlay
                    if (isLoading)
                      Container(
                        width: double.infinity,
                        height: height,
                        alignment: Alignment.center,
                        color: Colors.white.withOpacity(0.7),
                        child: const CircularProgressIndicator(),
                      ),

                    // Close button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String templateId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(getText("share_template")),
            content: Text(
              getText("confirm_share_link"),
              style: TextStyle(color: Colors.black),
            ),
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
                  final scaffoldContext =
                      context; // Use outer context, not ctx from dialog

                  Navigator.of(ctx).pop(); // close dialog

                  // Show a loading dialog or progress indicator
                  GlobalHelper().progressDialog(
                    scaffoldContext,
                    getText("template_share"),
                    getText("link_generating_wait"),
                  );

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
                        subject: getText(
                          "profio_user_template",
                        ), // subject can change what as user need
                        //uri: Uri.parse(url)
                      ),
                    );
                  } else {
                    // Show the snackbar using scaffoldContext (not ctx)
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          "❌ ${getText("template_link_generation_failed")}",
                        ),
                      ),
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
    if (key == "profileImageURL") {
      return fetchImage(data['_id'] ?? "", "PROFILE", value);
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
