import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class InspectorRegistrationScreen extends StatefulWidget {
  const InspectorRegistrationScreen({super.key});

  @override
  State<InspectorRegistrationScreen> createState() => _InspectorRegistrationScreenState();
}

class _InspectorRegistrationScreenState extends State<InspectorRegistrationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Personal info
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _location = TextEditingController();
  final _experience = TextEditingController();

  // Professional info
  String _inspectionType = '';
  String _specialization = '';
  final _certifications = TextEditingController();

  // Document uploads (mock)
  bool _uploadedId = false;
  bool _uploadedCert = false;
  bool _uploadedResume = false;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _location.dispose();
    _experience.dispose();
    _certifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become an Inspector'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.w(context,20)),
              child: _currentStep == 0
                  ? _buildPersonalInfoForm()
                  : _currentStep == 1
                      ? _buildProfessionalInfoForm()
                      : _buildDocumentsUpload(),
            ),
          ),
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context,20)),
      color: Colors.white,
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.symmetric(horizontal: Responsive.w(context,4)),
              decoration: BoxDecoration(
                color: index <= _currentStep ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: Responsive.h(context,4)),
          Text(
            'Provide your basic information for verification',
            style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary),
          ),
          SizedBox(height: Responsive.h(context,24)),
          _buildTextField('Full Name', Icons.person_outline, _fullName),
          SizedBox(height: Responsive.h(context,16)),
          _buildTextField('Phone Number', Icons.phone_outlined, _phone, keyboardType: TextInputType.phone),
          SizedBox(height: Responsive.h(context,16)),
          _buildTextField('Email Address', Icons.email_outlined, _email, keyboardType: TextInputType.emailAddress),
          SizedBox(height: Responsive.h(context,16)),
          _buildTextField('Location / City', Icons.location_on_outlined, _location),
          SizedBox(height: Responsive.h(context,16)),
          _buildTextField('Years of Experience', Icons.work_outline, _experience, keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Details',
          style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: Responsive.h(context,4)),
        Text(
          'Tell us about your inspection expertise',
          style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary),
        ),
        SizedBox(height: Responsive.h(context,24)),
        Text('Primary Inspection Type', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,12)),
        _buildInspectionTypeGrid(),
        SizedBox(height: Responsive.h(context,20)),
        Text('Specialization Area', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,12)),
        _buildSpecializationGrid(),
        SizedBox(height: Responsive.h(context,20)),
        _buildTextField('Professional Certifications', Icons.verified_outlined, _certifications),
        SizedBox(height: Responsive.h(context,8)),
        Text(
          'e.g. ISO 9001, TÜV, Bureau Veritas, SGS',
          style: TextStyle(fontSize: Responsive.sp(context,12), color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildDocumentsUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Documents',
          style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: Responsive.h(context,4)),
        Text(
          'Upload your documents for verification by our admin team',
          style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary),
        ),
        SizedBox(height: Responsive.h(context,24)),
        _buildDocumentCard('National ID / Passport', 'Upload a clear photo of your ID', Icons.badge_outlined, _uploadedId, () {
          setState(() => _uploadedId = !_uploadedId);
        }),
        SizedBox(height: Responsive.h(context,16)),
        _buildDocumentCard('Professional Certificate', 'Your inspection certification document', Icons.school_outlined, _uploadedCert, () {
          setState(() => _uploadedCert = !_uploadedCert);
        }),
        SizedBox(height: Responsive.h(context,16)),
        _buildDocumentCard('CV / Resume', 'Your professional CV or resume', Icons.description_outlined, _uploadedResume, () {
          setState(() => _uploadedResume = !_uploadedResume);
        }),
        SizedBox(height: Responsive.h(context,24)),
        Container(
          padding: EdgeInsets.all(Responsive.w(context,16)),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Responsive.w(context,12)),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.accent, size: Responsive.w(context,22)),
              SizedBox(width: Responsive.w(context,12)),
              Expanded(
                child: Text(
                  'After submission, our admin team will review your documents within 24-48 hours. You will be notified once your inspector status is approved.',
                  style: TextStyle(fontSize: Responsive.sp(context,12), color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(context,13), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,8)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(Responsive.w(context,12)),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textLight, size: Responsive.w(context,20)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(context,16), vertical: Responsive.h(context,14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInspectionTypeGrid() {
    final types = [
      {'name': 'Vehicle', 'icon': Icons.directions_car},
      {'name': 'Electronics', 'icon': Icons.devices},
      {'name': 'Cargo', 'icon': Icons.inventory_2},
      {'name': 'Agricultural', 'icon': Icons.agriculture},
      {'name': 'Industrial', 'icon': Icons.build},
    ];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: types.map((type) {
        final isSelected = _inspectionType == type['name'];
        return GestureDetector(
          onTap: () => setState(() => _inspectionType = type['name'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,14), vertical: Responsive.h(context,10)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,12)),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(type['icon'] as IconData, size: Responsive.w(context,18), color: isSelected ? AppColors.accent : AppColors.textLight),
                SizedBox(width: Responsive.w(context,6)),
                Text(
                  type['name'] as String,
                  style: TextStyle(
                    fontSize: Responsive.sp(context,13),
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.accent : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecializationGrid() {
    final specs = ['Vehicle Inspection', 'Electronics Testing', 'Cargo Verification', 'Quality Audit', 'Customs Compliance', 'Safety Assessment'];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: specs.map((spec) {
        final isSelected = _specialization == spec;
        return GestureDetector(
          onTap: () => setState(() => _specialization = spec),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,12), vertical: Responsive.h(context,8)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,20)),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.border,
              ),
            ),
            child: Text(
              spec,
              style: TextStyle(
                fontSize: Responsive.sp(context,12),
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentCard(String title, String description, IconData icon, bool uploaded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(Responsive.w(context,16)),
        decoration: BoxDecoration(
          color: uploaded ? AppColors.success.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.w(context,14)),
          border: Border.all(
            color: uploaded ? AppColors.success : AppColors.border,
            width: uploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.w(context,48),
              height: Responsive.w(context,48),
              decoration: BoxDecoration(
                color: uploaded ? AppColors.success.withValues(alpha: 0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(Responsive.w(context,12)),
              ),
              child: Icon(uploaded ? Icons.check_circle : icon, color: uploaded ? AppColors.success : AppColors.textLight, size: Responsive.w(context,24)),
            ),
            SizedBox(width: Responsive.w(context,14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  SizedBox(height: Responsive.h(context,2)),
                  Text(uploaded ? 'Uploaded ✓' : description, style: TextStyle(fontSize: Responsive.sp(context,12), color: uploaded ? AppColors.success : AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,12), vertical: Responsive.h(context,6)),
              decoration: BoxDecoration(
                color: uploaded ? AppColors.success.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(Responsive.w(context,8)),
              ),
              child: Text(
                uploaded ? 'Done' : 'Upload',
                style: TextStyle(fontSize: Responsive.sp(context,12), fontWeight: FontWeight.w600, color: uploaded ? AppColors.success : AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context,20)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0,-4))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(context,14)),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12))),
                ),
                child: Text('Back', style: TextStyle(color: AppColors.textSecondary, fontSize: Responsive.sp(context,14))),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: Responsive.w(context,12)),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep++);
                } else {
                  _showSuccessDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: EdgeInsets.symmetric(vertical: Responsive.h(context,14)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12))),
              ),
              child: Text(
                _currentStep == 2 ? 'Submit Application' : 'Continue',
                style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,20))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Responsive.w(context,72),
              height: Responsive.w(context,72),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.check_circle, color: AppColors.success, size: Responsive.w(context,40)),
            ),
            SizedBox(height: Responsive.h(context,20)),
            Text('Application Submitted!', style: TextStyle(fontSize: Responsive.sp(context,18), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: Responsive.h(context,8)),
            Text(
              'Your inspector application has been submitted for review. Our admin team will verify your documents within 24-48 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary),
            ),
            SizedBox(height: Responsive.h(context,24)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: Size(double.infinity, Responsive.h(context,48)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12))),
              ),
              child: Text('Back to Account', style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context,14))),
            ),
          ],
        ),
      ),
    );
  }
}