import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_text_field.dart';

class FreightBookingScreen extends StatefulWidget {
  const FreightBookingScreen({super.key});

  @override
  State<FreightBookingScreen> createState() => _FreightBookingScreenState();
}

class _FreightBookingScreenState extends State<FreightBookingScreen> {
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _goodsController = TextEditingController();
  final _hsCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedVehicle;
  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Motorcycle', 'capacity': 'Up to 50 kg', 'icon': Icons.motorcycle, 'price': 'TZS 15,000'},
    {'name': 'Pickup Truck', 'capacity': 'Up to 500 kg', 'icon': Icons.local_shipping, 'price': 'TZS 50,000'},
    {'name': 'Box Truck', 'capacity': 'Up to 2,000 kg', 'icon': Icons.fire_truck, 'price': 'TZS 120,000'},
    {'name': 'Semi Truck', 'capacity': 'Up to 10,000 kg', 'icon': Icons.directions_car, 'price': 'TZS 250,000'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _goodsController.dispose();
    _hsCodeController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentStep == 0 ? 'Freight Booking' : 'Vehicle Selection'),
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
                _buildStepIndicator(2, 'Vehicle', 1),
                _buildStepLine(1),
                _buildStepIndicator(3, 'Confirm', 2),
              ],
            ),
          ),
          Expanded(
            child: _currentStep == 0
                ? _buildDetailsStep()
                : _currentStep == 1
                    ? _buildVehicleStep()
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipment Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Fill in the details of your shipment',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          LabeledTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          LabeledTextField(
            label: 'Contact Number',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          LabeledTextField(
            label: 'Goods Description',
            hint: 'Describe the goods',
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: LabeledTextField(
                  label: 'HS Code',
                  hint: 'e.g. 8703',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabeledTextField(
                  label: 'Quantity',
                  hint: 'e.g. 10',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LabeledTextField(
            label: 'Weight (kg)',
            hint: 'Total weight in kg',
            icon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          // Document upload area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: const Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.textLight),
                SizedBox(height: 8),
                Text(
                  'Upload Documents',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Invoice, Packing List (optional)',
                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Continue to Vehicle',
            icon: Icons.arrow_forward,
            onPressed: () {
              setState(() => _currentStep = 1);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVehicleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Vehicle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose a vehicle suitable for your cargo',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ConfirmVehicleScreen(
            vehicles: _vehicles,
            selectedVehicle: _selectedVehicle,
            onVehicleSelected: (vehicle) {
              setState(() => _selectedVehicle = vehicle);
            },
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Continue to Confirm',
            icon: Icons.arrow_forward,
            onPressed: _selectedVehicle != null
                ? () {
                    setState(() => _currentStep = 2);
                  }
                : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildConfirmStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review & Confirm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Please review your booking details',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _buildConfirmCard('Shipment Details', [
            'Goods: $_goodsController',
            'Weight: $_weightController kg',
            'Quantity: $_quantityController',
          ]),
          const SizedBox(height: 12),
          _buildConfirmCard('Vehicle', [
            'Type: $_selectedVehicle',
            _vehicles.firstWhere((v) => v['name'] == _selectedVehicle,
                orElse: () => {'capacity': ''})['capacity'],
            _vehicles.firstWhere((v) => v['name'] == _selectedVehicle,
                orElse: () => {'price': ''})['price'],
          ]),
          const SizedBox(height: 24),
          GreenButton(
            text: 'Confirm Booking',
            icon: Icons.check_circle,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RequestReceivedScreen(),
                ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...items
              .where((item) => item.isNotEmpty && !item.contains(': null'))
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}

class ConfirmVehicleScreen extends StatelessWidget {
  final List<Map<String, dynamic>> vehicles;
  final String? selectedVehicle;
  final Function(String) onVehicleSelected;

  const ConfirmVehicleScreen({
    super.key,
    required this.vehicles,
    required this.selectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: vehicles.map((vehicle) {
        final isSelected = selectedVehicle == vehicle['name'];
        return GestureDetector(
          onTap: () => onVehicleSelected(vehicle['name'] as String),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accentGreenLight : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.secondary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    vehicle['icon'] as IconData,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vehicle['capacity'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      vehicle['price'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppColors.secondary, size: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class RequestReceivedScreen extends StatelessWidget {
  const RequestReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.accentGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Request Received!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your booking request has been submitted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Tracking Number',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'LCA-FRT-2025-5211',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}