import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class WingaRegistrationScreen extends StatefulWidget {
  const WingaRegistrationScreen({super.key});

  @override
  State<WingaRegistrationScreen> createState() => _WingaRegistrationScreenState();
}

class _WingaRegistrationScreenState extends State<WingaRegistrationScreen> {
  int _currentStep = 0;
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _location = TextEditingController();
  final _socialHandle = TextEditingController();

  String _primaryPlatform = '';
  List<String> _sellingCategories = [];
  bool _agreeTerms = false;
  bool _uploadedId = false;
  bool _uploadedProfile = false;
  bool _uploadedProof = false;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _location.dispose();
    _socialHandle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Winga'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.w(context,20)),
              child: _currentStep == 0
                  ? _buildPersonalInfoForm()
                  : _currentStep == 1
                      ? _buildBusinessInfoForm()
                      : _buildDocumentsUpload(),
            ),
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personal Information', style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,4)),
        Text('Tell us about yourself', style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
        SizedBox(height: Responsive.h(context,24)),
        _buildTextField('Full Name', Icons.person_outline, _fullName),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Phone Number', Icons.phone_outlined, _phone, keyboardType: TextInputType.phone),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Email Address', Icons.email_outlined, _email, keyboardType: TextInputType.emailAddress),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Location / City', Icons.location_on_outlined, _location),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Social Media Handle', Icons.share_outlined, _socialHandle),
        SizedBox(height: Responsive.h(context,8)),
        Text('e.g. @amina_winga on Instagram / WhatsApp', style: TextStyle(fontSize: Responsive.sp(context,12), color: AppColors.textLight)),
      ],
    );
  }

  Widget _buildBusinessInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Details', style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,4)),
        Text('What do you plan to sell?', style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
        SizedBox(height: Responsive.h(context,24)),
        Text('Primary Social Platform', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,12)),
        _buildPlatformGrid(),
        SizedBox(height: Responsive.h(context,20)),
        Text('Product Categories', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,8)),
        Text('Select all that apply', style: TextStyle(fontSize: Responsive.sp(context,12), color: AppColors.textLight)),
        SizedBox(height: Responsive.h(context,12)),
        _buildCategoryGrid(),
        SizedBox(height: Responsive.h(context,20)),
        Row(
          children: [
            Checkbox(
              value: _agreeTerms,
              onChanged: (v) => setState(() => _agreeTerms = v ?? false),
              activeColor: AppColors.accent,
            ),
            Expanded(
              child: Text(
                'I agree to the Winga Terms & Conditions',
                style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentsUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Required Documents', style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,4)),
        Text('Upload your documents for verification', style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
        SizedBox(height: Responsive.h(context,24)),
        _buildDocumentCard('National ID / Passport', 'Upload a clear photo of your ID', Icons.badge_outlined, _uploadedId, () {
          setState(() => _uploadedId = !_uploadedId);
        }),
        SizedBox(height: Responsive.h(context,16)),
        _buildDocumentCard('Social Media Profile Screenshot', 'Show your active selling profile', Icons.phone_android, _uploadedProfile, () {
          setState(() => _uploadedProfile = !_uploadedProfile);
        }),
        SizedBox(height: Responsive.h(context,16)),
        _buildDocumentCard('Proof of Previous Sales', 'Examples of past product sales', Icons.receipt_long, _uploadedProof, () {
          setState(() => _uploadedProof = !_uploadedProof);
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
                  'After submission, our team will review your profile. Once approved, you can start selling via social media immediately!',
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

  Widget _buildPlatformGrid() {
    final platforms = [
      {'name': 'WhatsApp', 'icon': Icons.chat, 'color': const Color(0xFF25D366)},
      {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': const Color(0xFFE4405F)},
      {'name': 'TikTok', 'icon': Icons.music_note, 'color': const Color(0xFF000000)},
      {'name': 'Facebook', 'icon': Icons.facebook, 'color': const Color(0xFF1877F2)},
      {'name': 'Twitter/X', 'icon': Icons.chat_bubble_outline, 'color': const Color(0xFF1DA1F2)},
    ];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: platforms.map((p) {
        final isSelected = _primaryPlatform == p['name'];
        final pColor = p['color'] as Color;
        return GestureDetector(
          onTap: () => setState(() => _primaryPlatform = p['name'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,14), vertical: Responsive.h(context,10)),
            decoration: BoxDecoration(
              color: isSelected ? pColor.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,12)),
              border: Border.all(color: isSelected ? pColor : AppColors.border, width: isSelected ? 2 : 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(p['icon'] as IconData, size: Responsive.w(context,18), color: isSelected ? pColor : AppColors.textLight),
                SizedBox(width: Responsive.w(context,6)),
                Text(p['name'] as String, style: TextStyle(fontSize: Responsive.sp(context,13), fontWeight: FontWeight.w600, color: isSelected ? pColor : AppColors.textPrimary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      'Electronics', 'Phones', 'Clothing', 'Shoes', 'Accessories',
      'Cosmetics', 'Food', 'Furniture', 'Kitchen', 'Other',
    ];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: categories.map((cat) {
        final isSelected = _sellingCategories.contains(cat);
        return GestureDetector(
          onTap: () => setState(() {
            if (isSelected) _sellingCategories.remove(cat);
            else _sellingCategories.add(cat);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,12), vertical: Responsive.h(context,8)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,20)),
              border: Border.all(color: isSelected ? AppColors.accent : AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) Icon(Icons.check_circle, size: Responsive.w(context,14), color: AppColors.accent),
                if (isSelected) SizedBox(width: Responsive.w(context,4)),
                Text(cat, style: TextStyle(fontSize: Responsive.sp(context,12), fontWeight: FontWeight.w500, color: isSelected ? AppColors.accent : AppColors.textSecondary)),
              ],
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
          border: Border.all(color: uploaded ? AppColors.success : AppColors.border, width: uploaded ? 2 : 1),
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
              child: Text(uploaded ? 'Done' : 'Upload', style: TextStyle(fontSize: Responsive.sp(context,12), fontWeight: FontWeight.w600, color: uploaded ? AppColors.success : AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context,20)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0,-4))]),
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
                if (_currentStep < 2) setState(() => _currentStep++);
                else _showSuccessDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: EdgeInsets.symmetric(vertical: Responsive.h(context,14)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12))),
              ),
              child: Text(_currentStep == 2 ? 'Submit Application' : 'Continue', style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600)),
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
            Text('Your Winga application has been submitted for review. Our team will verify your profile within 24-48 hours. Once approved, you can start selling!', textAlign: TextAlign.center, style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
            SizedBox(height: Responsive.h(context,24)),
            ElevatedButton(
              onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: Size(double.infinity, Responsive.h(context,48)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12)))),
              child: Text('Back to Account', style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context,14))),
            ),
          ],
        ),
      ),
    );
  }
}