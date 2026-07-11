import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';

class FreightBookingScreen extends StatefulWidget {
  const FreightBookingScreen({super.key});

  @override
  State<FreightBookingScreen> createState() => _FreightBookingScreenState();
}

class _FreightBookingScreenState extends State<FreightBookingScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Personal info
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();

  // Shipper info
  final _shipperNameController = TextEditingController();
  final _shipperAddressController = TextEditingController();

  // Consignee info
  final _consigneeNameController = TextEditingController();
  final _consigneeAddressController = TextEditingController();

  // Goods info
  final _goodsDescriptionController = TextEditingController();
  final _hsCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();

  // Transport info
  String? _selectedTransportMode;
  String? _selectedCarrier;
  final _etdController = TextEditingController();
  final _etaController = TextEditingController();

  final List<String> _carriers = ['MAERSK', 'MSC', 'CMA CGM', 'COSCO', 'PIL', 'SHARAF', 'ONE', 'HAPAG-LLOYD'];

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
    _etdController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentStep == 0 ? 'Cargo Clearance & Forwarding' : 'Review & Confirm'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Colors.white,
            child: Row(
              children: [
                _buildStepIndicator(1, 'Details', 0),
                _buildStepLine(0),
                _buildStepIndicator(2, 'Confirm', 1),
              ],
            ),
          ),
          Expanded(
            child: _currentStep == 0
                ? _buildDetailsStep()
                : _buildConfirmStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, int index) {
    final isActive = _currentStep >= index;
    final isCompleted = _currentStep > index;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : AppColors.border,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? AppColors.primary : AppColors.textLight,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int index) {
    final isActive = _currentStep > index;
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.primary : AppColors.border,
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CARGO CLEARANCE & FORWARDING FORM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            const Text('Fill in all required fields for cargo clearance', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // Personal Information
            _buildSectionHeader('Personal Information'),
            const SizedBox(height: 12),
            _buildTextField('Full Name', Icons.person_outline, _fullNameController, 'Enter your full name'),
            const SizedBox(height: 12),
            _buildTextField('Email / Phone', Icons.contact_phone, _contactController, 'Contact information'),
            const SizedBox(height: 20),

            // Shipper
            _buildSectionHeader('Shipper Information'),
            const SizedBox(height: 12),
            _buildTextField('Shipper Name', Icons.person_outline, _shipperNameController, 'Shipper full name'),
            const SizedBox(height: 12),
            _buildTextField('Shipper Address', Icons.home, _shipperAddressController, 'Shipper address'),
            const SizedBox(height: 20),

            // Consignee
            _buildSectionHeader('Consignee Information'),
            const SizedBox(height: 12),
            _buildTextField('Consignee Name', Icons.person_outline, _consigneeNameController, 'Consignee full name'),
            const SizedBox(height: 12),
            _buildTextField('Consignee Address', Icons.location_on, _consigneeAddressController, 'Consignee address'),
            const SizedBox(height: 20),

            // Goods
            _buildSectionHeader('Goods Information'),
            const SizedBox(height: 12),
            _buildTextField('Description of Goods', Icons.inventory, _goodsDescriptionController, 'Describe goods', maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField('HS Code', Icons.code, _hsCodeController, 'e.g. 8471.30'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('Quantity', Icons.numbers, _quantityController, 'Number of units', keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Weight (kg)', Icons.scale, _weightController, 'Weight in kg', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 20),

            // Transport
            _buildSectionHeader('Transport Information'),
            const SizedBox(height: 12),
            _buildTransportDropdown(),
            const SizedBox(height: 12),
            _buildCarrierDropdown(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('ETD', Icons.calendar_today, _etdController, 'dd/mm/yyyy', keyboardType: TextInputType.datetime)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('ETA', Icons.calendar_today, _etaController, 'dd/mm/yyyy', keyboardType: TextInputType.datetime)),
              ],
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Continue to Review',
              icon: Icons.arrow_forward,
              onPressed: () {
                setState(() => _currentStep = 1);
              },
            ),
            const SizedBox(height: 16),
          ],
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
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accentGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  IconData _getTransportIcon(String mode) {
    switch (mode) {
      case 'Air Freight': return Icons.flight;
      case 'Sea Freight': return Icons.directions_boat;
      case 'Road Freight': return Icons.local_shipping;
      case 'Rail Freight': return Icons.train;
      default: return Icons.local_shipping;
    }
  }

  Widget _buildTransportDropdown() {
    final transportModes = [
      {'value': 'Air Freight', 'icon': Icons.flight},
      {'value': 'Sea Freight', 'icon': Icons.directions_boat},
      {'value': 'Road Freight', 'icon': Icons.local_shipping},
      {'value': 'Rail Freight', 'icon': Icons.train},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transport Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedTransportMode,
          decoration: InputDecoration(
            prefixIcon: _selectedTransportMode != null
                ? Icon(_getTransportIcon(_selectedTransportMode!), color: AppColors.textSecondary, size: 20)
                : const Icon(Icons.local_shipping, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accentGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: transportModes.map((mode) {
            return DropdownMenuItem(
              value: mode['value'] as String,
              child: Row(
                children: [
                  Icon(mode['icon'] as IconData, size: 18, color: AppColors.textPrimary),
                  const SizedBox(width: 10),
                  Text(mode['value'] as String),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedTransportMode = value),
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildCarrierDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Carrier Name (Shipping Company)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedCarrier,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.directions_boat, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accentGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: _carriers.map((carrier) {
            return DropdownMenuItem(
              value: carrier,
              child: Text(carrier),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedCarrier = value),
          validator: (value) => value == null ? 'Please select a carrier' : null,
        ),
      ],
    );
  }

  Widget _buildConfirmStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Review & Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Please review your booking details', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          _buildConfirmCard('Personal', [
            'Name: ${_fullNameController.text}',
            'Contact: ${_contactController.text}',
          ]),
          const SizedBox(height: 12),
          _buildConfirmCard('Shipper', [
            'Name: ${_shipperNameController.text}',
            'Address: ${_shipperAddressController.text}',
          ]),
          const SizedBox(height: 12),
          _buildConfirmCard('Consignee', [
            'Name: ${_consigneeNameController.text}',
            'Address: ${_consigneeAddressController.text}',
          ]),
          const SizedBox(height: 12),
          _buildConfirmCard('Goods', [
            'Description: ${_goodsDescriptionController.text}',
            'HS Code: ${_hsCodeController.text}',
            'Quantity: ${_quantityController.text}',
            'Weight: ${_weightController.text} kg',
          ]),
          const SizedBox(height: 12),
          _buildConfirmCard('Transport', [
            'Mode: ${_selectedTransportMode ?? "N/A"}',
            'Carrier: ${_selectedCarrier ?? "N/A"}',
            'ETD: ${_etdController.text}',
            'ETA: ${_etaController.text}',
          ]),
          const SizedBox(height: 24),
          GreenButton(
            text: 'Confirm Booking',
            icon: Icons.check_circle,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RequestReceivedScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildConfirmCard(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...items.where((item) => item.isNotEmpty && !item.contains(': null')).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: [
              const Icon(Icons.check, size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
            ]),
          )),
        ],
      ),
    );
  }
}


class RequestReceivedScreen extends StatelessWidget {
  const RequestReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, foregroundColor: AppColors.primary),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.accentGreenLight, shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: AppColors.success, size: 56)),
              const SizedBox(height: 24),
              const Text('Request Received!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Your booking request has been submitted successfully.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                child: const Column(children: [
                  Text('Tracking Number', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  SizedBox(height: 8),
                  Text('LCA-FRT-2025-5211', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1)),
                ]),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}