import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';
import 'package:profio/features/services/api_service.dart';

import '../../../../core/helpers/global_helper.dart';
import '../../../../core/helpers/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _stepControllers = [
      WizardStepController(step: _personalState),
      WizardStepController(step: _companyState),
      WizardStepController(step: _socialState),
      WizardStepController(step: _documentState),
    ];
    _loadUserDetails();

  }

  Future<void> _loadUserDetails() async {
    setState(() {
      isLoading = true;
    });

    userDetails = await getUserByUUID();
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
  }

  @override
  Widget build(BuildContext context) {
    // Wrap everything in DefaultWizardController so context.wizardController is available
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onPanStart: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: !isLoading ? DefaultWizardController(
        stepControllers: _stepControllers,
        child: Builder(builder: (context) {
          final wizard = context.wizardController; // extension from the package

          return Column(
            children: [
              const SizedBox(height: 12),
              // Small progress indicator (optional)
              StreamBuilder<int>(
                stream: wizard.indexStream,
                initialData: wizard.index,
                builder: (ctx, snap) {
                  final idx = snap.data ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LinearProgressIndicator(
                      value:
                      (idx + 1) / (wizard.stepCount == 0 ? 1 : wizard.stepCount),
                      minHeight: 6,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // The wizard content
              Expanded(
                child: Wizard(
                  stepBuilder: (ctx, state) {
                    // state is the object you passed into WizardStepController(step: ...)
                    if (state is PersonalStepState) {
                      return _buildPersonalDetails();
                    } else if (state is CompanyStepState) {
                      return _buildCompanyDetails();
                    } else if (state is SocialStepState) {
                      return _buildSocialMediaDetails();
                    } else if (state is DocumentStepState) {
                      return _buildDocumentDetails();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Action bar (Back / Next / Save)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildActionBar(context),
              ),
            ],
          );
        }),
      )
          :Center(
          child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator())),
    );
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
        const Text("Personal Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Photo*",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async{
                final hasPermission = await PermissionHandler.requestPermissionBrowseFile(context);

                if (!hasPermission) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("⚠️ Permission denied. Please enable it from settings.")),
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
                      SnackBar(content: Text("⚠️  File Size exceeded.")),
                    );
                    return;
                  }

                  setState(() {
                    _pickedFile = file;
                  });


                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5),
                ),
                child: _pickedFile != null && _isImageFile(_pickedFile!.name)
                    ? ClipOval(
                  child: Image.memory(
                    _pickedFile!.bytes!,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ) : const Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 28,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        _textField("Full Name*",uNameController ),
        _textField("Personal Email Address*", uEmailController,type: TextInputType.emailAddress),
        _textField("Phone Number*", uPhoneController,type: TextInputType.phone),
        _textField("Personal Address*", uAddressController,type: TextInputType.streetAddress),
        _textField("Personal Website URL*", uWebSiteController,type: TextInputType.twitter,isLastField: true),
      ]),
    );
  }

  // ============================
  // STEP 2: COMPANY DETAILS
  // ============================
  Widget _buildCompanyDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Company Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        _textField("Company Name*", cNameController),
        _textField("Job Title*", cJobTitleEmailController),
        _textField("Company Email Address*", cEmailController,type: TextInputType.emailAddress),
        _textField("Company Phone Number*", cPhoneController,type: TextInputType.phone),
        _textField("Company Address", cAddressController,type: TextInputType.streetAddress),
        _textField("Company Website URL", cWebsiteController,type: TextInputType.twitter,isLastField: true),
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
        const Text("Social Media", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        _textField("WhatsApp*", sWhatsappController),
        _textField("Facebook", sFacebookController,type: TextInputType.twitter),
        _textField("Instagram", sInstagramController,type: TextInputType.twitter),
        _textField("Linkedin", sLinkedinController,type: TextInputType.twitter),
        _textField("Youtube", sYoutubeController,type: TextInputType.twitter,isLastField: true),
        const Text("Other links", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.black)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                if(sOtherLinkTitleController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Please enter the other link title.')),
                  );
                }
                else if(sOtherLinkController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Please enter the other link.')),
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
        _textField("Enter other link title", sOtherLinkTitleController,type: TextInputType.text),
        _textField("Enter other link url", sOtherLinkController,type: TextInputType.twitter,isLastField: true),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Document Upload",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Expanded Text Field
            Expanded(
              child: _textField("Document Title", documentController, isLastField: true),
            ),

            const SizedBox(width: 12),

            /// Upload Icon (larger size)
            IconButton(
              iconSize: 32, // Increase icon size
              tooltip: 'Select File',
              icon: const Icon(Icons.upload_file, color: Colors.green),
              onPressed: () async {
                final hasPermission = await PermissionHandler.requestPermissionBrowseFile(context);

                if (!hasPermission) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("⚠️ Permission denied. Please enable it from settings.")),
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
                      const SnackBar(content: Text("⚠️ File Size exceeded.")),
                    );
                    return;
                  }

                  setState(() {
                    _pickedDocumentFile = result;
                  });
                }
              },
            ),

            /// Add Icon (larger size)
            IconButton(
              iconSize: 32, // Increase icon size
              tooltip: 'Add Document',
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                 if (documentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚠️ Please enter the document title.')),
                );
                }
                else if ((_pickedDocumentFile?.files ?? []).isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Please select the document.')),
                  );
                }
                else {
                  setState(() {
                    uploadedDocs.add({
                      "title": documentController.text,
                      "file": _pickedDocumentFile?.files.first,
                    });
                    documentController.clear();
                    _pickedDocumentFile = null;
                  });
                }
              },
            ),
          ],
        ),

        ListView.builder(
          itemCount: uploadedDocs.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final doc = uploadedDocs[index];
            final PlatformFile file = doc["file"];
            final String title = doc["title"];

            return Card(
              child: ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text(title),
                subtitle: Text("${file.name} • ${(file.size / 1024).toStringAsFixed(2)} KB"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      uploadedDocs.removeAt(index);
                    });
                  },
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
              child: const Text('Back'),
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
          child: const Text('Save'),
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
              child: const Text('Next'),
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
        const SnackBar(content: Text('⚠️ Please fill in all required personal details.')),
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
        const SnackBar(content: Text('⚠️ Please fill in all required company details.')),
      );
      return false;
    }
    return true;
  }

  bool _validateSocialMediaDetails() {
    //return true;
    if (sWhatsappController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill in all required social media details.')),
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
    List<Map<String,dynamic>> documents = [];
    //upload profile picture
    GlobalHelper().progressDialog(context,"Profile update","Profile updating, please wait...");
    if((_pickedFile?.path ?? "") != ""){
      if(userDetails != {}){
        userId = userDetails['_id'] ?? "";
      }
      var preSignedUrl = await getPreSignedUrl(userId,_pickedFile?.extension ?? "",);
      if(preSignedUrl != {}){
        userImageUrl = preSignedUrl?['fileURL'] ?? "";
        var result = await uploadFileToPreSignedUrl(preSignedUrl?['uploadUrl'] ?? "",_pickedFile ?? PlatformFile(name: "", size: 1));
        print("ProfileImageUploaded: ${result}");
      }

    }

    //upload selected documents
    if(uploadedDocs.isNotEmpty){
      for(int i=0; i< uploadedDocs.length; i++){
          var uploadDoc = uploadedDocs[i];
          PlatformFile tempDocument = uploadDoc['file'];
          String title = uploadDoc['title'];
          if(tempDocument.path != ""){
            var preSignedUrl = await getPreSignedUrl(userId,tempDocument.extension ?? "",title: title,language: "en");
            if(preSignedUrl != {}){
              var tempDocumentUrl = preSignedUrl?['fileURL'] ?? "";
              var result = await uploadFileToPreSignedUrl(preSignedUrl?['uploadUrl'] ?? "",_pickedFile ?? PlatformFile(name: "", size: 1));
              print("DocumentImageUploaded: ${result}");
              if(result){
                documents.add({
                  "title": title,
                  "file": tempDocumentUrl,
                });
              }
            }
          }



      }
    }

    //update the profile with details
    // Function to build the API data
    Map<String, dynamic> apiRequest = {
        "id": userId,
        "name": uNameController.text.toString().trim(),
        "phoneNumber": uNameController.text.toString().trim(),
        "personalAddress": uNameController.text.toString().trim(),
        "personalWebsite": uNameController.text.toString().trim(),
        "companyName": uNameController.text.toString().trim(),
        "jobTitle": uNameController.text.toString().trim(),
        "companyEmail": uNameController.text.toString().trim(),
        "companyPhoneNumber": uNameController.text.toString().trim(),
        "companyAddress": uNameController.text.toString().trim(),
        "companyWebsite": uNameController.text.toString().trim(),
        "whatsappNumber": uNameController.text.toString().trim(),
        "facebookUrl": uNameController.text.toString().trim(),
        "instagramUrl": uNameController.text.toString().trim(),
        "linkedInUrl": uNameController.text.toString().trim(),
        "tikTokUrl": uNameController.text.toString().trim(),
        "youtubeUrl": uNameController.text.toString().trim(),
        "otherLinks": otherLinks.map((link) => {
          "title": link["title"].text,
          "url": link["url"].text,
        }).toList(),
        "documents": documents.map((doc) => {
          "title": doc["title"].text,
          "url": doc["url"].text,
        }).toList(),
        "language": "en",
      };


    //update the api
    var profileUpdateResult = await updateUserDetails(apiRequest,userId);
    if(profileUpdateResult){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Update Successfully ✅')),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Update Failed ❌')),);
    }
    Navigator.of(context)..pop()..pop();
  }


}

bool _isImageFile(String fileName) {
  final extension = fileName.toLowerCase();
  return extension.endsWith('.jpg') ||
      extension.endsWith('.jpeg') ||
      extension.endsWith('.png');
}







