

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profio/features/services/api_constants.dart';
import 'package:profio/features/services/api_service.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/helpers/global_helper.dart';
import '../../../../core/helpers/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:googleapis/translate/v3.dart' as translate;
import 'package:provider/provider.dart';
import '../../../../providers/locale_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../services/google_service.dart';


/// Step-state classes (must mixin WizardStep)
class PersonalStepState with WizardStep {}
class CompanyStepState with WizardStep {}
class SocialStepState with WizardStep {}
class DocumentStepState with WizardStep {}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Step state instances
  final PersonalStepState _personalState = PersonalStepState();
  final CompanyStepState _companyState = CompanyStepState();
  final SocialStepState _socialState = SocialStepState();
  final DocumentStepState _documentState = DocumentStepState();

  // WizardStepControllers (must pass `step:`)
  late final List<WizardStepController> _stepControllers;

  // --- form controllers (example) ---
  final TextEditingController uNameController = TextEditingController();
  final TextEditingController uEmailController = TextEditingController();
  final TextEditingController uPhoneController = TextEditingController();
  final TextEditingController uAddressController = TextEditingController();
  final TextEditingController uWebSiteController = TextEditingController(); //web site

  final TextEditingController cNameController = TextEditingController();
  final TextEditingController cJobTitleEmailController = TextEditingController();
  final TextEditingController cEmailController = TextEditingController();
  final TextEditingController cPhoneController = TextEditingController();
  final TextEditingController cAddressController = TextEditingController();
  final TextEditingController cWebsiteController = TextEditingController();

  final TextEditingController sWhatsappController = TextEditingController();
  final TextEditingController sFacebookController = TextEditingController();
  final TextEditingController sInstagramController = TextEditingController();
  final TextEditingController sLinkedinController = TextEditingController();
  final TextEditingController sTiktokController = TextEditingController();
  final TextEditingController sYoutubeController = TextEditingController();

  final TextEditingController sOtherLinkTitleController = TextEditingController();
  final TextEditingController sOtherLinkController = TextEditingController();

  final TextEditingController documentController = TextEditingController();
  PlatformFile? _pickedFile;
  FilePickerResult? _pickedDocumentFile;
  List<Map<String,dynamic>> otherLinks = [];
  List<Map<String, dynamic>> uploadedDocs = [];
  Map<String,dynamic> userDetails = {};
  bool isLoading = true;
  String appLanguage = "en";
  late final WizardController _wizardController;
  int _currentStep = 0;
  final int _totalSteps = 4; // number of your steps
  late LocaleProvider localeProvider;
  late VoidCallback listener;

  @override
  void initState() {
    super.initState();

    _stepControllers = [
      WizardStepController(step: _personalState),
      WizardStepController(step: _companyState),
      WizardStepController(step: _socialState),
      WizardStepController(step: _documentState),
    ];
    _wizardController = WizardController(stepControllers: _stepControllers);
    _loadUserDetails();
    listener = () {
      if (mounted) {
        appLanguage = localeProvider.currentLanguageCode ?? "";
        print("LanguageChanged:${appLanguage} -- ${localeProvider.currentLanguage}");
        _refreshUserDetails();
      }
    };

    // ✅ Safe way to access Provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      localeProvider.addListener(listener);
    });
  }



  Future<void> _loadUserDetails() async {
    setState(() {
      isLoading = true;
    });

    userDetails = await getUserByUUID();
    await setUserDetails(userDetails);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshUserDetails() async {
    setState(() {
      isLoading = true;
    });
    await setUserDetails(userDetails);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // dispose wizard controllers
    for (final c in _stepControllers) {
      c.dispose();
    }

    // dispose text controllers
    uNameController.dispose();
    uEmailController.dispose();
    uPhoneController.dispose();
    uAddressController.dispose();
    uWebSiteController.dispose();

    cNameController.dispose();
    cJobTitleEmailController.dispose();
    cEmailController.dispose();
    cAddressController.dispose();
    cPhoneController.dispose();
    cWebsiteController.dispose();

    sWhatsappController.dispose();
    sFacebookController.dispose();
    sInstagramController.dispose();
    sLinkedinController.dispose();
    sTiktokController.dispose();
    sYoutubeController.dispose();

    documentController.dispose();
    _pickedFile = null;
    _pickedDocumentFile = null;

    super.dispose();
    localeProvider.removeListener(listener);
  }


  @override
  Widget build(BuildContext context) {
    print("CheckCurrentAppLanguage:$appLanguage");
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onPanStart: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: !isLoading ? Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: (_currentStep + 1) / _totalSteps,
            ),
          ),

          // Step content
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildPersonalDetails(),
                _buildCompanyDetails(),
                _buildSocialMediaDetails(),
                _buildDocumentDetails(), // includes image picker
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (_currentStep == 0) {
                        Navigator.of(context).pop(); // go back to previous screen
                      } else {
                        setState(() {
                          _currentStep -= 1; // go back one step in wizard
                        });
                      }
                    },
                    child: Text(localeProvider.getText(key: 'back'),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep == _totalSteps - 1
                        ? updateProfile
                        : () {
                      if (_validateCurrentStep(_currentStep)) {
                        setState(() => _currentStep += 1);
                      }
                    },
                    child: Text(_currentStep == _totalSteps - 1 ? localeProvider.getText(key: 'save') : localeProvider.getText(key: 'next')),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          :Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator())),
    );
  }



  Future<void> pickImageCrossPlatform(BuildContext context) async {
    PlatformFile? pickedPlatformFile;

    if (Platform.isIOS) {
      // iOS: use image_picker for Photos
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${getText("permission_denied")}")),
        );
        return;
      }

      final file = File(pickedImage.path);
      final fileSizeInMB = await file.length() / (1024 * 1024);

      if (fileSizeInMB > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${getText("file_size_exceeded")}")),
        );
        return;
      }

      // Convert File/XFile to PlatformFile
      pickedPlatformFile = PlatformFile(
        name: pickedImage.name,       // file name
        path: pickedImage.path,       // file path
        size: await file.length(),    // file size in bytes
        bytes: await file.readAsBytes(), // optional, if you need bytes
      );

    } else {
      // ANDROID: use FilePicker
      final hasPermission = await PermissionHandler.requestPermissionBrowseFile(context);
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${getText("permission_denied")}")),
        );
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileSizeInMB = file.size / (1024 * 1024);

      if (fileSizeInMB > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${getText("file_size_exceeded")}")),
        );
        return;
      }

      pickedPlatformFile = file;
    }

    // Update state
    if (pickedPlatformFile != null) {
      setState(() {
        _pickedFile = pickedPlatformFile;
      });
    }
  }




  void _removeLink(int index) {
    setState(() {
      otherLinks.removeAt(index);
    });
  }
  // ============================
  // STEP 1: PERSONAL DETAILS
  // ============================
  Widget _buildPersonalDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(localeProvider.getText(key: 'personal_details'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(getText("profile_photo"),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                pickImageCrossPlatform(context);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5),
                ),
                child: _buildProfileImage(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        _textField(getText("full_name"),uNameController ),
        _textField(getText("personal_email"), uEmailController,type: TextInputType.emailAddress),
        _textField(getText("phone_number"), uPhoneController,type: TextInputType.phone),
        _textField(getText("personal_address"), uAddressController,type: TextInputType.streetAddress),
        _textField(getText("personal_website"), uWebSiteController,type: TextInputType.twitter,isLastField: true),
      ]),
    );
  }


  Widget _buildProfileImage() {
    if (_pickedFile != null && _isImageFile(_pickedFile!.name)) {
      return ClipOval(
        child: Image.memory(
          _pickedFile!.bytes!,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
        ),
      );
    } else if (userDetails['profileImageURL'] != null && (userDetails['profileImageURL'] ?? "") != "") {
      return ClipOval(
        child: Image.network(
          fetchImage(userDetails['_id'] ?? "","PROFILE", userDetails['profileImageURL']),
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(),
        ),
      );
    } else {
      return _buildDefaultIcon();
    }
  }

  Widget _buildDefaultIcon() {
    print("CheckProfileImage:${fetchImage(userDetails['_id'] ?? "","PROFILE", userDetails['profileImageURL'])}");
    return const Center(
      child: Icon(
        Icons.person_outline,
        size: 28,
        color: Colors.black54,
      ),
    );
  }

  // ============================
  // STEP 2: COMPANY DETAILS
  // ============================
  Widget _buildCompanyDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Text(getText("company_details"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        _textField(getText("company_name"), cNameController),
        _textField(getText("job_title"), cJobTitleEmailController),
        _textField(getText("company_email"), cEmailController,type: TextInputType.emailAddress),
        _textField(getText("company_phone"), cPhoneController,type: TextInputType.phone),
        _textField(getText("company_address"), cAddressController,type: TextInputType.streetAddress),
        _textField(getText("company_website"), cWebsiteController,type: TextInputType.twitter,isLastField: true),
      ]),
    );
  }

  // ============================
  // STEP 3: SOCIAL MEDIA DETAILS
  // ============================
  Widget _buildSocialMediaDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Text(getText("social_media"), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        _textField(getText("whatsapp"), sWhatsappController),
        _textField(getText("facebook"), sFacebookController,type: TextInputType.twitter),
        _textField(getText("instagram"), sInstagramController,type: TextInputType.twitter),
        _textField(getText("linkedin"), sLinkedinController,type: TextInputType.twitter),
        _textField(getText("youtube"), sYoutubeController,type: TextInputType.twitter,isLastField: true),
         Text(getText("other_links"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.black)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                if(sOtherLinkTitleController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('⚠️ ${getText("enter_other_link_title")}')),
                  );
                }
                else if(sOtherLinkController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('⚠️  ${getText("enter_other_link")}')),
                  );
                }
                else{
                  var tempOtherLink = {
                    "title": sOtherLinkTitleController.text,
                    "url": sOtherLinkController.text
                  };

                  setState(() {
                    otherLinks.add(tempOtherLink);
                  });

                  sOtherLinkTitleController.clear();
                  sOtherLinkController.clear();

                }
              },
              icon: const Icon(Icons.add,color: Colors.green,),

            ),
          ],
        ),
        _textField(getText("enter_other_link_title"), sOtherLinkTitleController,type: TextInputType.text),
        _textField(getText("enter_other_link"), sOtherLinkController,type: TextInputType.twitter,isLastField: true),
        SizedBox(height: 20,),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: otherLinks.length,
          itemBuilder: (context, index) {
            final link = otherLinks[index];
            return Card(
              child: ListTile(
                title: Text(link["title"] ?? ''),
                subtitle: Text(link["url"] ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeLink(index),
                ),
              ),
            );
          },
        ),

      ]),
    );


  }

  // ============================
  // STEP 4: DOCUMENT DETAILS
  // ============================
  Widget _buildDocumentDetails() {
    int? _activeSlideIndex;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Text(getText("enter_other_link_title"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        Visibility(
          visible: isDocumentShouldVisible(uploadedDocs.length),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Expanded Text Field
              Expanded(
                child: _textField(getText("document_title"), documentController, isLastField: true),
              ),

              const SizedBox(width: 12),

              /// Upload Icon (larger size)
              IconButton(
                iconSize: 32, // Increase icon size
                tooltip: getText("select_file"),
                icon: const Icon(Icons.upload_file, color: Colors.green),
                onPressed: () async {
                  if(uploadedDocs.length == documentUploadLimit()){
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text("⚠️ ${getText("document_upload_limit")}")),
                    );
                  }else{
                    final hasPermission = await PermissionHandler.requestPermissionBrowseFile(context);

                    if (!hasPermission) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("⚠️${getText("permission_denied")}")),
                      );
                      return;
                    }

                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                      withData: true,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;
                      final fileSizeInMB = file.size / (1024 * 1024);

                      if (fileSizeInMB > 20) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text("⚠️ ${getText("file_size_exceeded")}")),
                        );
                        return;
                      }

                      setState(() {
                        _pickedDocumentFile = result;
                      });
                    }
                  }

                },
              ),

              /// Add Icon (larger size)
              IconButton(
                iconSize: 32, // Increase icon size
                tooltip: getText("add_document"),
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {
                   if (documentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('⚠️ ${getText("enter_document_title")}')),
                  );
                  }
                  else if ((_pickedDocumentFile?.files ?? []).isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('⚠️ ${getText("select_document")}')),
                    );
                  }
                  else {
                    setState(() {
                      uploadedDocs.add({
                        "title": documentController.text,
                        "file": _pickedDocumentFile?.files.first,
                        "isUploaded": false
                      });
                      documentController.clear();
                      _pickedDocumentFile = null;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        ListView.builder(
          itemCount: uploadedDocs.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final doc = uploadedDocs[index];
            final PlatformFile file = doc["file"] ?? PlatformFile(name: "", size: 1);
            final String title = doc["title"];
            final String url = doc["url"] ?? "";
            final documentImage =  fetchImage(userDetails['_id'] ?? "","DOCUMENT",url);
            final bool isUploaded = doc["isUploaded"] ?? false;
            final String documentId = doc['id'] ?? "";

            print("CheckDocumentImage:${documentImage}");

            return Card(
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: true,
                child: Slidable(
                  dragStartBehavior: DragStartBehavior.start,
                  closeOnScroll: true,
                  useTextDirection: true,
                  direction: Axis.horizontal,
                  key: ValueKey(index),
                  // Slide actions (right side)
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(), // smooth motion effect
                    children: [
                      Visibility(
                        visible:isUploaded,
                        child: SlidableAction(
                          onPressed: (c) async{
                            var dContext = c;
                           String newTitle = await _showEditDialog(dContext,title);
                           if(newTitle != ""){
                             print("DocumentNewTitle : ${newTitle}");
                             Map<String, dynamic> apiRequest = {
                               "userId":"${userDetails['_id'] ?? ""}",
                               "documentId":documentId,
                               "title": {
                                 appLanguage:newTitle
                               }
                             };
                             GlobalHelper().progressDialog(context,getText("document_update"),getText("document_updating"));
                             bool result = await updateDocumentTitle(apiRequest);
                             Navigator.of(context).pop();
                             if(result){
                               ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${getText("document_updated_success")} $successIcon')),
                               );
                               setState(() {
                                 uploadedDocs[index]["title"] = newTitle;
                               });
                             }else{
                               ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${getText("document_updated_failed")} $failedIcon')),
                               );
                             }
                           }

                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          if (isUploaded) {
                            var dContext = context;
                            GlobalHelper().showDeleteConfirmationDialog(
                              dContext,
                              "document",
                                  () async {
                                GlobalHelper().progressDialog(context,getText("document_delete"),getText("document_deleting") );
                                var deleteResult = await deleteUploadedDocument(userDetails['_id'] ?? "", documentId);
                                Navigator.of(context).pop();
                                if (deleteResult) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${getText("document_deleted_success")} $successIcon")),
                                  );
                                  setState(() {
                                    uploadedDocs.removeAt(index);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${getText("document_deleted_failed")} $failedIcon")),
                                  );
                                }
                              },
                            );
                          } else {
                            setState(() {
                              uploadedDocs.removeAt(index);
                            });
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: getText("delete"),
                      ),
                    ],
                  ),
                
                  // Main tile content
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(title),
                    subtitle: isUploaded
                        ? Text(url)
                        : Text("${file.name} • ${(file.size / 1024).toStringAsFixed(2)} KB"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUploaded ? Icons.check_circle : Icons.error,
                          color: isUploaded ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isUploaded ? getText("uploaded") : getText("not_uploaded"),
                          style: TextStyle(
                            color: isUploaded ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isUploaded) ...[
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              _showFullImage(context, documentImage);
                            },
                            child: const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );

          },
        ),
      ]),
    );
  }

  // ============================
  // TEXT FIELD HELPER
  // ============================
  Widget _textField(String label, TextEditingController controller,{bool isLastField = false,TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextField(
        controller: controller,
        textInputAction:isLastField ? TextInputAction.done : TextInputAction.next,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
            borderSide: const BorderSide(
              color: Colors.green, // Border color
              width: 1.5,          // Border thickness
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.green, // Normal state color
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // ACTION BAR (Back / Next / Save)
  // ============================
  Widget _buildActionBar(BuildContext ctx) {
    final wizard = ctx.wizardController;
    return StreamBuilder<int>(
      stream: wizard.indexStream,
      initialData: wizard.index,
      builder: (context, snapshot) {
        final idx = snapshot.data ?? 0;
        final isLast = idx == wizard.stepCount - 1;

        // Back button enabled stream
        final backButton = StreamBuilder<bool>(
          stream: wizard.getIsGoBackEnabledStream(),
          initialData: wizard.getIsGoBackEnabled(),
          builder: (c, s) {
            final enabled = s.data ?? false;
            final isFirstPage = wizard.index == 0;
            return OutlinedButton(
              onPressed: enabled
                  ? () {
                if (isFirstPage) {
                  // If it's the first page, navigate back to the previous screen
                  Navigator.pop(c);
                } else {
                  // Otherwise, go to the previous step in the wizard
                  wizard.previous();
                }
              }
                  : null,
              child: Text(getText("back")),
            );
          },
        );

        // Next or Save
        final nextOrSave = isLast
            ? ElevatedButton(
          onPressed: () {
            // Final save
            updateProfile();

          },
          child: Text(getText("save")),
        )
            : StreamBuilder<bool>(
          stream: wizard.getIsGoNextEnabledStream(),
          initialData: wizard.getIsGoNextEnabled(),
          builder: (c, s) {
            final enabled = s.data ?? false;
            return ElevatedButton(
              onPressed: enabled
                  ? () {
                final valid = _validateCurrentStep(idx);
                if (valid) {
                  wizard.next();
                }
              }
                  : null,
              child: Text(getText("next")),
            );
          },
        );


        return Row(
          children: [
            Expanded(child: backButton),
            const SizedBox(width: 12),
            Expanded(child: nextOrSave),
          ],
        );
      },
    );
  }

  bool _validateCurrentStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _validatePersonalDetails();
      case 1:
        return _validateCompanyDetails();
      case 2:
        return _validateSocialMediaDetails();
      case 3:
        return _validateDocuments();
      default:
        return true;
    }
  }

  bool _validatePersonalDetails() {
    // return true;
    if (uNameController.text.trim().isEmpty ||
        uEmailController.text.trim().isEmpty ||
        uPhoneController.text.trim().isEmpty || uAddressController.text.trim().isEmpty || uWebSiteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ ${getText("fill_personal_details")}')),
      );
      return false;
    }
    return true;
  }

  bool _validateCompanyDetails() {
   // return true;
    if (cNameController.text.trim().isEmpty ||
        cJobTitleEmailController.text.trim().isEmpty ||
        cEmailController.text.trim().isEmpty || cPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('⚠️ ${getText("fill_company_details")}')),
      );
      return false;
    }
    return true;
  }

  bool _validateSocialMediaDetails() {
    // return true;
    if (sWhatsappController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('⚠️ ${getText("fill_social_details")}')),
      );
      return false;
    }
    return true;
  }

  bool _validateDocuments() {
    return true;
  }



  void updateProfile() async{
    String userId = "";
    String userImageUrl = "";
    var ln = appLanguage;
    //upload profile picture
    GlobalHelper().progressDialog(context,getText("profile_update"),getText("profile_updating"));
    if(userDetails != {}){
      userId = userDetails['_id'] ?? "";
      print('UserId:${userId}');
    }
    if((_pickedFile?.path ?? "") != ""){
      var preSignedUrl = await getPreSignedUrl(userId,_pickedFile?.extension ?? "",);
      if((preSignedUrl ?? {}) != {}){
        userImageUrl = preSignedUrl?['fileURL'] ?? "";
        var result = await uploadFileToPreSignedUrl(preSignedUrl?['uploadUrl'] ?? "",_pickedFile ?? PlatformFile(name: "", size: 1));
        print("ProfileImageUploaded: ${result}");
      }else{
        updateResult(1); // profile image upload error
        return;
      }

    }

    //upload selected documents
    if(uploadedDocs.isNotEmpty){
      for(int i=0; i< uploadedDocs.length; i++){
          var uploadDoc = uploadedDocs[i];
          bool isUploaded = uploadDoc['isUploaded'] ?? false;
          if(!isUploaded){
            PlatformFile tempDocument = uploadDoc['file'];
            String title = uploadDoc['title'];
            dynamic docRequest = {
              "userId":userId,
              "fileExtension":tempDocument.extension ?? "",
              "title": {
                ln: title,
              },
              "type":"DOCUMENT"
            };
            final documentRequest = await translateAndBuildRequest(docRequest, ln, targetLanguages,"document");

            if(tempDocument.path != ""){
              var preSignedUrl = await getPreSignedUrl(userId,tempDocument.extension ?? "",type: 2,docRequest: documentRequest);
              if((preSignedUrl ?? {}) != {}){
                var result = await uploadFileToPreSignedUrl(preSignedUrl?['uploadUrl'] ?? "",tempDocument);
                print("DocumentImageUploaded: ${result}");
              }
              else{
                updateResult(2); // document image upload error
                return;
              }
            }
          }
      }
    }

    //update the profile with details

    Map<String, dynamic> apiRequest = {
      "id": userId,

      "name": {
        ln: uNameController.text.toString().trim(),
      },
      "personalAddress": {
        ln: uAddressController.text.toString().trim(),
      },
      "companyName": {
        ln: cNameController.text.toString().trim(),
      },
      "jobTitle": {
        ln: cJobTitleEmailController.text.toString().trim(),
      },
      "companyAddress": {
        ln: cAddressController.text.toString().trim(),
      },

      // ✅ Static (non-translatable) fields as-is
      "phoneNumber": uPhoneController.text.toString().trim(),
      "personalWebsite": uWebSiteController.text.toString().trim(),
      "companyEmail": cEmailController.text.toString().trim(),
      "companyPhoneNumber": cPhoneController.text.toString().trim(),
      "companyWebsite": cWebsiteController.text.toString().trim(),
      "whatsappNumber": sWhatsappController.text.toString().trim(),
      "facebookUrl": sFacebookController.text.toString().trim(),
      "instagramUrl": sInstagramController.text.toString().trim(),
      "linkedInUrl": sLinkedinController.text.toString().trim(),
      "tikTokUrl": sTiktokController.text.toString().trim(),
      "youtubeUrl": sYoutubeController.text.toString().trim(),

      // ✅ otherLinks with translatable 'title'
      "otherLinks": otherLinks.map((link) => {
        "title": {
          ln: link["title"].toString().trim(),
        },
        "url": link["url"].toString().trim(),
      }).toList(),
    };

    final profileRequest = await translateAndBuildRequest(apiRequest, ln, targetLanguages,"profile");

    //update the api
    var profileUpdateResult = await updateUserDetails(profileRequest,userId);

    if(profileUpdateResult){
      updateResult(4); // document image upload error
      return;
    }
    else{
      updateResult(3); // document image upload error
      return;
    }
  }

  void updateResult(int type){
    String message = "";

    switch (type) {
      case 1:
        message = '${getText("profile_image_failed")} ❌';
        break;
      case 2:
        message = '${getText("documents_upload_failed")} ❌';
        break;
      case 3:
        message = '${getText("profile_update_failed")} ❌';
        break;
      case 4:
        message = '${getText("profile_update_success")} ✅';
        break;
      default:
        message = getText("something_wrong");
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)),);
    Navigator.of(context)..pop()..pop();
  }



  Future<Map<String, dynamic>> translateAndBuildRequest(
      Map<String, dynamic> originalData,
      String inputLang,
      List<String> targetLanguages,String translateFieldType) async {

    // const serviceAccountJson = {};
    // Step 1: Authenticate with Google Cloud using service account

    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(GoogleService.serviceAccountJson);
    final parent = 'projects/profio-473307/locations/global';

    final client = await clientViaServiceAccount(serviceAccountCredentials, [translate.TranslateApi.cloudTranslationScope],);
    final api = translate.TranslateApi(client);


    Map<String, dynamic> translatedData = Map.from(originalData);

    final translatableFields = _getTranslatableFieldsForType(translateFieldType);


    for (var field in translatableFields) {
      if (originalData[field] is Map) {
        String originalText = originalData[field][inputLang];

        for (var lang in targetLanguages) {
          if (lang != inputLang) {
            final translatedText = await _googleTranslateText(api, parent, originalText, inputLang, lang);
            translatedData[field][lang] = translatedText;
          }
        }
      }

      // For list of objects like otherLinks
      if (field == 'otherLinks' && originalData[field] is List) {
        List<dynamic> links = originalData[field];
        for (int i = 0; i < links.length; i++) {
          var link = links[i];
          if (link['title'] is Map) {
            String originalText = link['title'][inputLang];
            for (var lang in targetLanguages) {
              if (lang != inputLang) {
                final translatedText = await _googleTranslateText(api, parent, originalText, inputLang, lang);
                link['title'][lang] = translatedText;
              }
            }
          }
        }
      }
    }

    client.close();
    return translatedData;
  }


  Future<String> _googleTranslateText(
      translate.TranslateApi api,
      String parent,
      String text,
      String sourceLang,
      String targetLang) async {

    final request = translate.TranslateTextRequest(
      contents: [text],
      sourceLanguageCode: sourceLang,
      targetLanguageCode: targetLang,
      mimeType: 'text/plain',
    );

    final response = await api.projects.locations.translateText(request, parent);

    return response.translations?.first.translatedText ?? '[Translation failed]';
  }

  List<String> _getTranslatableFieldsForType(String type) {
    switch (type) {
      case 'profile':
        return [
          "name",
          "jobTitle",
          "personalAddress",
          "companyName",
          "companyAddress",
          "otherLinks",
        ];
      case 'document':
        return ["title"];
      case 'other': //what ever we need
        return ["title", "description"];
      default:
        return []; // Fallback for unknown types
    }
  }


  Map<String, dynamic> getLocalizedData(Map<String, dynamic> userData, String languageCode) {
    Map<String, dynamic> localizedData = {};

    // Localize fields that have translations for 'en' and 'ja'
    localizedData['name'] = userData['name'][languageCode] ?? userData['name']['en'];  // Default to 'en' if the specified language doesn't exist
    localizedData['personalAddress'] = userData['personalAddress'][languageCode] ?? userData['personalAddress']['en'];
    localizedData['companyName'] = userData['companyName'][languageCode] ?? userData['companyName']['en'];
    localizedData['jobTitle'] = userData['jobTitle'][languageCode] ?? userData['jobTitle']['en'];
    localizedData['otherLinks'] = userData['otherLinks']
        .map((link) => {
      'title': link['title'][languageCode] ?? link['title']['en'],
      'url': link['url'],
    })
        .toList();

    localizedData['documents'] = userData['documents']
        .map((link) => {
      'title': link['title'][languageCode] ?? link['title']['en'],
      'url': link['url'],
      'id': link['_id'] ?? "",
      'isUploaded': true
    }).toList();

    // Extract other non-translatable fields directly
    localizedData['email'] = userData['email'];
    localizedData['phoneNumber'] = userData['phoneNumber'];
    localizedData['personalWebsite'] = userData['personalWebsite'];
    localizedData['companyEmail'] = userData['companyEmail'];
    localizedData['companyPhoneNumber'] = userData['companyPhoneNumber'];
    localizedData['companyAddress'] = userData['companyAddress'][languageCode] ?? userData['companyAddress']['en'];
    localizedData['companyWebsite'] = userData['companyWebsite'];
    localizedData['profileImageURL'] = userData['profileImageURL'];

    localizedData['whatsappNumber'] = userData['whatsappNumber'];
    localizedData['facebookUrl'] = userData['facebookUrl'];
    localizedData['instagramUrl'] = userData['instagramUrl'];
    localizedData['tikTokUrl'] = userData['tikTokUrl'];
    localizedData['youtubeUrl'] = userData['youtubeUrl'];
    localizedData['linkedInUrl'] = userData['linkedInUrl'];

    return localizedData;
  }




  ///test method

  void testTranslate() async {
    final inputLang = 'ja'; // You entered in Japanese
    final targetLangs = ['en'];

    final inputData = {
      "name": {
        "ja": "ジョン・ドウ"
      },
      "jobTitle": {
        "ja": "ソフトウェアエンジニア"
      },
      "instagramUrl": "https://instagram.com/johndoe",
      "otherLinks": [
        {
          "title": {
            "ja": "ポートフォリオ"
          },
          "url": "https://portfolio.johndoe.com"
        }
      ]
    };

    // final output = await translateAndBuildRequest(inputData, inputLang, targetLangs);


    // print("CheckCurrentAppLanguage:$language");
  }

  Future<void> setUserDetails(Map<String, dynamic> userDetails) async {
    var data =  getLocalizedData(userDetails,appLanguage);
    if(data != {} ) {
      uNameController.text = data['name'] ?? "";
      uEmailController.text = data['email'] ?? "";
      uAddressController.text = data['personalAddress'] ?? "";
      uPhoneController.text = (data['phoneNumber'] ?? "").toString();
      uWebSiteController.text = data['personalWebsite'] ?? "";

      cNameController.text = data['companyName'] ?? "";
      cJobTitleEmailController.text = data['jobTitle'] ?? "";
      cEmailController.text = data['companyEmail'] ?? "";
      cPhoneController.text = (data['companyPhoneNumber'] ?? "").toString();
      cAddressController.text = data['companyAddress'] ?? "";
      cWebsiteController.text = data['companyWebsite'] ?? "";

      sWhatsappController.text = (data['whatsappNumber'] ?? "").toString();
      sFacebookController.text = data['facebookUrl'] ?? "";
      sInstagramController.text = data['instagramUrl'] ?? "";
      sLinkedinController.text = (data['linkedInUrl'] ?? "").toString();
      sTiktokController.text = data['tikTokUrl'] ?? "";
      sYoutubeController.text = data['youtubeUrl'] ?? "";

      otherLinks = List<Map<String, dynamic>>.from(data['otherLinks'] ?? []);
      uploadedDocs = List<Map<String, dynamic>>.from(data['documents'] ?? []);



      print("CheckUserData:${data}");
    }
  }

  String getText(String title){
    return localeProvider.getText(key: title);
  }


  // Function to show the edit dialog
  Future<String> _showEditDialog(BuildContext context,String currentFileName) async{
    final TextEditingController controller = TextEditingController();
    controller.text = currentFileName.toString();
    String newTitle = "";

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getText("edit_doc_title"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                tooltip: getText("close"),
              ),
            ],
          ),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              hintText: getText("enter_new_text"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            TextButton(
              onPressed: () {
                final newText = controller.text.trim();

                if (newText.isNotEmpty && newText.length > 3) {
                  // Handle saving the new text here
                  Navigator.pop(context);
                  newTitle = newText;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(getText("valid_text"))),
                  );
                }
              },
              child:  Text(getText("save")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(getText("cancel")),
            ),
          ],
        );
      },
    );

    return newTitle;
  }

}


bool _isImageFile(String fileName) {
  final extension = fileName.toLowerCase();
  return extension.endsWith('.jpg') ||
      extension.endsWith('.jpeg') ||
      extension.endsWith('.png');
}

void _showFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) =>
        Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog when tapped
            },
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        ),
  );
}

bool isDocumentShouldVisible(int documentCount){
  bool result = true;
  int userDocumentUploadLimit =  (userSubscribedPlan.id ?? "NONE") != "NONE" ? (userSubscribedPlan.documentUploadLimit ?? 2) : 2; // assume for default its 2
  result = documentCount < userDocumentUploadLimit;
  return result;
}

int documentUploadLimit(){
  return (userSubscribedPlan.id ?? "NONE") != "NONE" ? (userSubscribedPlan.documentUploadLimit ?? 2) : 2; // assume for default its 2
}












