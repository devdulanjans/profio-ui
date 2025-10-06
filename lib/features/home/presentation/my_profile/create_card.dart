import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

/// Step-state classes (must mixin WizardStep)
class PersonalStepState with WizardStep {}
class CompanyStepState with WizardStep {}
class SocialStepState with WizardStep {}
class DocumentStepState with WizardStep {}

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // Step state instances
  final PersonalStepState _personalState = PersonalStepState();
  final CompanyStepState _companyState = CompanyStepState();
  final SocialStepState _socialState = SocialStepState();
  final DocumentStepState _documentState = DocumentStepState();

  // WizardStepControllers (must pass `step:`)
  late final List<WizardStepController> _stepControllers;

  // --- form controllers (example) ---
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();

  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();

  final TextEditingController documentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stepControllers = [
      WizardStepController(step: _personalState),
      WizardStepController(step: _companyState),
      WizardStepController(step: _socialState),
      WizardStepController(step: _documentState),
    ];
  }

  @override
  void dispose() {
    // dispose wizard controllers
    for (final c in _stepControllers) {
      c.dispose();
    }

    // dispose text controllers
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap everything in DefaultWizardController so context.wizardController is available
    return DefaultWizardController(
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
    );
  }

  // ============================
  // STEP 1: PERSONAL DETAILS
  // ============================
  Widget _buildPersonalDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Personal Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _textField("Full Name*", fullNameController),
        _textField("Email*", emailController),
        _textField("Phone*", phoneController),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _textField("Company Name*", companyNameController),
        _textField("Company Email*", companyEmailController),
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
        const Text("Social Media",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _textField("WhatsApp", whatsappController),
        _textField("Facebook", facebookController),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _textField("Document Title", documentController),
      ]),
    );
  }

  // ============================
  // TEXT FIELD HELPER
  // ============================
  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
            return OutlinedButton(
              onPressed: enabled ? () => wizard.previous() : null, // ✅ fixed
              child: const Text('Back'),
            );
          },
        );

        // Next or Save
        final nextOrSave = isLast
            ? ElevatedButton(
          onPressed: () {
            // final save action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved profile ✅')),
            );
          },
          child: const Text('Save'),
        )
            : StreamBuilder<bool>(
          stream: wizard.getIsGoNextEnabledStream(),
          initialData: wizard.getIsGoNextEnabled(),
          builder: (c, s) {
            final enabled = s.data ?? false;
            return ElevatedButton(
              onPressed: enabled ? () => wizard.next() : null, // ✅ fixed
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
}

