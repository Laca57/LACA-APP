import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class CargoClearanceFormScreen extends StatefulWidget {
  const CargoClearanceFormScreen({super.key});

  @override
  State<CargoClearanceFormScreen> createState() => _CargoClearanceFormScreenState();
}

class _CargoClearanceFormScreenState extends State<CargoClearanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _shipperNameController = TextEditingController();
  final _shipperAddressController = TextEditingController();
  final _consigneeNameController = TextEditingController();
  final _consigneeAddressController = TextEditingController();
  final _goodsDescriptionController = TextEditingController();
  final _hsCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _carrierNameController = TextEditingController();
  final _etdController = TextEditingController();
  final _etaController = TextEditingController();
  String? _selectedTransportMode;

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactController.dispose();
    _shipperNameController.dispose();
    _shipperAddressController.dispose();
    _consigneeNameController.dispose();
    _consigneeAddressController.dispose();
    _goodsDescriptionController.dispose();
    _hsCodeController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _carrierNameController.dispose();
    _etdController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargo Clearance & Forwarding'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.serviceCargo, AppColors.serviceFreight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.inventory_2, color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    const Text(
                      'CARGO CLEARANCE & FORWARDING FORM REQUEST',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fill out the form below to request clearance and forwarding services',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: _fullNameController,
                icon: Icons.person,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Email Address / Phone Number',
                hint: 'Enter email or phone number',
                controller: _contactController,
                icon: Icons.contact_phone,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your contact information' : null,
              ),
              const SizedBox(height: 20),

              // Shipper Information Section
              _buildSectionHeader('Shipper Information'),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Shipper Name',
                hint: 'Enter shipper\'s full name',
                controller: _shipperNameController,
                icon: Icons.person_outline,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter shipper\'s name' : null,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Shipper Address',
                hint: 'Enter shipper\'s address',
                controller: _shipperAddressController,
                icon: Icons.home,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter shipper\'s address' : null,
              ),
              const SizedBox(height: 20),

              // Consignee Information Section
              _buildSectionHeader('Consignee Information'),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Consignee Name',
                hint: 'Enter consignee\'s full name',
                controller: _consigneeNameController,
                icon: Icons.person_outline,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter consignee\'s name' : null,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Consignee Address',
                hint: 'Enter consignee\'s address',
                controller: _consigneeAddressController,
                icon: Icons.location_on,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter consignee\'s address' : null,
              ),
              const SizedBox(height: 20),

              // Goods Information Section
              _buildSectionHeader('Goods Information'),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Description of Goods',
                hint: 'Describe the goods being shipped',
                controller: _goodsDescriptionController,
                icon: Icons.inventory,
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Please describe the goods' : null,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'HS Code',
                hint: 'Harmonized System code (e.g., 8471.30)',
                controller: _hsCodeController,
                icon: Icons.code,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter the HS code' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Quantity',
                      hint: 'Number of units',
                      controller: _quantityController,
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'Weight',
                      hint: 'Weight in kg',
                      controller: _weightController,
                      icon: Icons.scale,
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Transport Information Section
              _buildSectionHeader('Transport Information'),
              const SizedBox(height: 12),

              _buildDropdownField(),
              const SizedBox(height: 12),

              _buildTextField(
                label: 'Carrier Name',
                hint: 'Name of the carrier / shipping company',
                controller: _carrierNameController,
                icon: Icons.business,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter carrier name' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'ETD (Departure)',
                      hint: 'dd/mm/yyyy',
                      controller: _etdController,
                      icon: Icons.flight_takeoff,
                      keyboardType: TextInputType.datetime,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'ETA (Arrival)',
                      hint: 'dd/mm/yyyy',
                      controller: _etaController,
                      icon: Icons.flight_land,
                      keyboardType: TextInputType.datetime,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Attach Documents Section
              _buildSectionHeader('Attach Documents'),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload, size: 40, color: AppColors.accentGreen),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap to attach documents',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Commercial invoice, packing list, certificate of origin, etc.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Form Submitted'),
                          content: const Text('Your cargo clearance form has been submitted successfully. Our team will review and contact you shortly.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transport Mode',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedTransportMode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.local_shipping, color: AppColors.textSecondary, size: 20),
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: const [
            DropdownMenuItem(value: 'Air', child: Text('Air')),
            DropdownMenuItem(value: 'Sea', child: Text('Sea')),
            DropdownMenuItem(value: 'Road', child: Text('Road')),
            DropdownMenuItem(value: 'Rail', child: Text('Rail')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedTransportMode = value;
            });
          },
          validator: (value) => value == null ? 'Please select transport mode' : null,
        ),
      ],
    );
  }
}