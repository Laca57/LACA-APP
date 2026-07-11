import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ad_banner.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/responsive.dart';

class CompanyInspectorsScreen extends StatelessWidget {
  const CompanyInspectorsScreen({super.key});

  static const List<_CompanyInspector> _companies = [
    _CompanyInspector(
      name: 'COTECNA',
      fullName: 'COTECNA Inspection S.A.',
      description: 'Swiss-based inspection & compliance company',
      services: 'Pre-shipment inspection, cargo verification, quality control',
      country: 'Switzerland',
      rating: 4.7,
    ),
    _CompanyInspector(
      name: 'EAA',
      fullName: 'East African Authority',
      description: 'Regional inspection & standards authority',
      services: 'Vehicle inspection, import compliance, roadworthiness',
      country: 'Tanzania',
      rating: 4.4,
    ),
    _CompanyInspector(
      name: 'TBS',
      fullName: 'Tanzania Bureau of Standards',
      description: 'National standards & inspection body',
      services: 'Product certification, quality assurance, standards compliance',
      country: 'Tanzania',
      rating: 4.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Inspectors'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const AdBanner(
            message: '🏢 Accredited inspection companies for your imports',
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(context, 16),
                vertical: Responsive.h(context, 12),
              ),
              itemCount: _companies.length,
              itemBuilder: (context, index) =>
                  _buildCompanyCard(context, _companies[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, _CompanyInspector company) {
    final Color companyColor;
    switch (company.name) {
      case 'COTECNA':
        companyColor = const Color(0xFF1565C0);
        break;
      case 'EAA':
        companyColor = const Color(0xFF2E7D32);
        break;
      case 'TBS':
        companyColor = const Color(0xFFE65100);
        break;
      default:
        companyColor = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, 14)),
      padding: EdgeInsets.all(Responsive.w(context, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w(context, 16)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: companyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    company.name.substring(0, 1),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: companyColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Responsive.w(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company.fullName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: companyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFFFB300)),
                    const SizedBox(width: 3),
                    Text(
                      company.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: companyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 10)),
          Text(
            company.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: Responsive.h(context, 6)),
          Row(
            children: [
              const Icon(Icons.work_outline, size: 14, color: AppColors.textLight),
              SizedBox(width: Responsive.w(context, 4)),
              Expanded(
                child: Text(
                  company.services,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 10)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCocForm(context, company),
              style: ElevatedButton.styleFrom(
                backgroundColor: companyColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Request Inspection',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCocForm(BuildContext context, _CompanyInspector company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CocFormSheet(company: company),
    );
  }
}

// ============================================================
// COC REQUEST FORM (bottom sheet)
// ============================================================

class _CocFormSheet extends StatefulWidget {
  final _CompanyInspector company;
  const _CocFormSheet({required this.company});

  @override
  State<_CocFormSheet> createState() => _CocFormSheetState();
}

class _CocFormSheetState extends State<_CocFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  final Map<String, bool> _documents = {
    'Invoice': false,
    'Export Certificate': false,
    'House Bill of Lading': false,
    'Packing List (optional)': false,
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_documents.entries.any((e) => e.key != 'Packing List (optional)' && e.value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please attach at least Invoice, Export Certificate, and House Bill of Lading'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 44,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'We have received\nyour request!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.company.name} will review and invoice you shortly",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.verified, color: Color(0xFF00897B), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COC Request — ${widget.company.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Certificate of Conformity for roadworthiness',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textLight),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'Enter your email address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter your email';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Phone Number',
                      hint: 'e.g. +255 712 345 678',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter your phone number' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _countryCtrl,
                      label: 'Destination Country of the Vehicle',
                      hint: 'e.g. Tanzania, Kenya, Uganda...',
                      icon: Icons.public,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter destination country' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Required Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Attach the following documents for your COC request',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._documents.keys.map((doc) => _docTile(doc)),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Send a Request',
                      icon: Icons.send_rounded,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
      ),
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
    );
  }

  Widget _docTile(String doc) {
    final isOptional = doc.contains('(optional)');
    final attached = _documents[doc] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: attached ? const Color(0xFF00897B).withValues(alpha: 0.06) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: attached ? const Color(0xFF00897B) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: attached
                    ? const Color(0xFF00897B).withValues(alpha: 0.12)
                    : AppColors.textLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                attached ? Icons.description : Icons.upload_file,
                size: 20,
                color: attached ? const Color(0xFF00897B) : AppColors.textLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.replaceAll(' (optional)', ''),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isOptional)
                    Text(
                      'Optional',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() => _documents[doc] = !attached);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: attached ? const Color(0xFF00897B) : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  attached ? 'Attached' : 'Attach',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyInspector {
  final String name;
  final String fullName;
  final String description;
  final String services;
  final String country;
  final double rating;

  const _CompanyInspector({
    required this.name,
    required this.fullName,
    required this.description,
    required this.services,
    required this.country,
    required this.rating,
  });
}
