import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  int _currentStep = 0;
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _location = TextEditingController();
  final _vehiclePlate = TextEditingController();
  final _vehicleType = TextEditingController();

  String _deliveryArea = '';
  String _vehicleCategory = '';
  bool _hasValidLicense = false;
  bool _uploadedId = false;
  bool _uploadedLicense = false;
  bool _uploadedProfile = false;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _location.dispose();
    _vehiclePlate.dispose();
    _vehicleType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become an IT Driver'),
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
                      ? _buildVehicleInfoForm()
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
                color: index <= _currentStep ? AppColors.serviceSendPackage : AppColors.border,
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
        _buildTextField('City / Location', Icons.location_on_outlined, _location),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Vehicle Plate Number', Icons.directions_car_outlined, _vehiclePlate),
        SizedBox(height: Responsive.h(context,16)),
        _buildTextField('Vehicle Type', Icons.local_shipping_outlined, _vehicleType),
      ],
    );
  }

  Widget _buildVehicleInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Preferences', style: TextStyle(fontSize: Responsive.sp(context,20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,4)),
        Text('Set your delivery preferences', style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
        SizedBox(height: Responsive.h(context,24)),
        Text('Delivery Area', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,12)),
        _buildAreaGrid(),
        SizedBox(height: Responsive.h(context,20)),
        Text('Vehicle Category', style: TextStyle(fontSize: Responsive.sp(context,14), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        SizedBox(height: Responsive.h(context,12)),
        _buildVehicleGrid(),
        SizedBox(height: Responsive.h(context,20)),
        Row(
          children: [
            Checkbox(
              value: _hasValidLicense,
              onChanged: (v) => setState(() => _hasValidLicense = v ?? false),
              activeColor: AppColors.serviceSendPackage,
            ),
            Expanded(
              child: Text(
                'I confirm I have a valid driving license',
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
        _buildDocumentCard('Driving License', 'Upload your valid driving license', Icons.badge, _uploadedLicense, () {
          setState(() => _uploadedLicense = !_uploadedLicense);
        }),
        SizedBox(height: Responsive.h(context,16)),
        _buildDocumentCard('Profile Photo', 'A clear photo of yourself', Icons.camera_alt_outlined, _uploadedProfile, () {
          setState(() => _uploadedProfile = !_uploadedProfile);
        }),
        SizedBox(height: Responsive.h(context,24)),
        Container(
          padding: EdgeInsets.all(Responsive.w(context,16)),
          decoration: BoxDecoration(
            color: AppColors.serviceSendPackage.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Responsive.w(context,12)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.serviceSendPackage, size: Responsive.w(context,22)),
              SizedBox(width: Responsive.w(context,12)),
              Expanded(
                child: Text(
                  'After submission, our admin team will verify your vehicle details and license within 24-48 hours. You will receive a notification once approved.',
                  style: TextStyle(fontSize: Responsive.sp(context,12), color: AppColors.serviceSendPackage),
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

  Widget _buildAreaGrid() {
    final areas = [
      {'name': 'Dar es Salaam', 'icon': Icons.location_city},
      {'name': 'Arusha', 'icon': Icons.terrain},
      {'name': 'Mwanza', 'icon': Icons.water},
      {'name': 'Mbeya', 'icon': Icons.forest},
      {'name': 'Dodoma', 'icon': Icons.account_balance},
      {'name': 'Tanga', 'icon': Icons.sailing},
    ];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: areas.map((area) {
        final isSelected = _deliveryArea == area['name'];
        return GestureDetector(
          onTap: () => setState(() => _deliveryArea = area['name'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,14), vertical: Responsive.h(context,10)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.serviceSendPackage.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,12)),
              border: Border.all(color: isSelected ? AppColors.serviceSendPackage : AppColors.border, width: isSelected ? 2 : 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(area['icon'] as IconData, size: Responsive.w(context,18), color: isSelected ? AppColors.serviceSendPackage : AppColors.textLight),
                SizedBox(width: Responsive.w(context,6)),
                Text(area['name'] as String, style: TextStyle(fontSize: Responsive.sp(context,13), fontWeight: FontWeight.w600, color: isSelected ? AppColors.serviceSendPackage : AppColors.textPrimary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVehicleGrid() {
    final vehicles = ['Motorcycle', 'Boda Boda', 'Bajaji', 'Pickup Truck', 'Box Truck'];
    return Wrap(
      spacing: Responsive.w(context,8),
      runSpacing: Responsive.w(context,8),
      children: vehicles.map((v) {
        final isSelected = _vehicleCategory == v;
        return GestureDetector(
          onTap: () => setState(() => _vehicleCategory = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context,12), vertical: Responsive.h(context,8)),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.serviceSendPackage.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.w(context,20)),
              border: Border.all(color: isSelected ? AppColors.serviceSendPackage : AppColors.border),
            ),
            child: Text(v, style: TextStyle(fontSize: Responsive.sp(context,12), fontWeight: FontWeight.w500, color: isSelected ? AppColors.serviceSendPackage : AppColors.textSecondary)),
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
                backgroundColor: AppColors.serviceSendPackage,
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
            Text('Your driver application has been submitted for review. Our admin team will verify your vehicle details and license within 24-48 hours.', textAlign: TextAlign.center, style: TextStyle(fontSize: Responsive.sp(context,13), color: AppColors.textSecondary)),
            SizedBox(height: Responsive.h(context,24)),
            ElevatedButton(
              onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.serviceSendPackage, minimumSize: Size(double.infinity, Responsive.h(context,48)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.w(context,12)))),
              child: Text('Back to Account', style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context,14))),
            ),
          ],
        ),
      ),
    );
  }
}