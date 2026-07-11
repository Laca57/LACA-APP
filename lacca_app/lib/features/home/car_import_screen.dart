import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../inspectors/inspectors_screen.dart';
import '../inspectors/company_inspectors_screen.dart';

class CarImportScreen extends StatefulWidget {
  const CarImportScreen({super.key});

  @override
  State<CarImportScreen> createState() => _CarImportScreenState();
}

class _CarImportScreenState extends State<CarImportScreen> {
  // Kibubu wallet state
  double _kibubuBalance = 1250000;
  final double _kibubuTarget = 5000000;
  final TextEditingController _kibubuDepositController = TextEditingController();

  // TRA calculator state
  String _selectedMake = 'Toyota';
  String _selectedModel = 'Sedan - Corolla';
  String _selectedYear = '2015';
  String _selectedCountry = 'Japan';
  String _selectedFuelType = 'Petrol';
  String _selectedEngineCC = '1800cc';
  double _calculatedTax = 0;
  double _calculatedTotal = 0;
  bool _showTaxResult = false;

  final List<String> _makes = ['Toyota', 'Nissan', 'Honda', 'Suzuki', 'Mitsubishi', 'Mazda', 'Subaru', 'BMW', 'Mercedes-Benz', 'Volvo', 'Volkswagen', 'Ford', 'Hyundai', 'Kia', 'Isuzu', 'Land Rover', 'Lexus', 'Audi'];
  final List<String> _models = [
    'Sedan - Corolla', 'Sedan - Camry', 'Sedan - Civic', 'Sedan - Accord',
    'SUV - Harrier', 'SUV - RAV4', 'SUV - Prado', 'SUV - Land Cruiser',
    'SUV - CR-V', 'SUV - X-Trail', 'SUV - Fortuner',
    'Hatchback - Vitara', 'Hatchback - Swift', 'Hatchback - Fit',
    'Pickup - Hilux', 'Pickup - D-Max', 'Pickup - Navara',
    'Minivan - Noah', 'Minivan - Alphard', 'Minivan - Hiace',
    'Coupe - Supra', 'Coupe - GT-R', 'Coupe - MX-5',
  ];
  final List<String> _years = List.generate(37, (i) => (1990 + i).toString());
  final List<String> _countries = ['Japan', 'UAE', 'Germany', 'USA', 'UK', 'China', 'South Korea', 'India', 'South Africa', 'Thailand', 'Italy', 'Sweden', 'France'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Hybrid', 'Electric', 'Petrol-Hybrid', 'Diesel-Hybrid', 'LPG', 'CNG'];
  final List<String> _engineOptions = ['800cc', '1000cc', '1300cc', '1500cc', '1800cc', '2000cc', '2200cc', '2500cc', '3000cc', '3500cc', '4000cc', '4500cc', '5000cc+'];

  @override
  void dispose() {
    _kibubuDepositController.dispose();
    super.dispose();
  }

  bool get _isNewCar => (int.tryParse(_selectedYear) ?? 0) >= DateTime.now().year - 10;

  double _estimateCarValue() {
    final year = int.tryParse(_selectedYear) ?? 2015;
    final age = DateTime.now().year - year;
    final baseValue = _getMakeBaseValue();
    final depreciation = (age.clamp(0, 20) / 20) * 0.7;
    final engineMultiplier = _getEngineMultiplier();
    return baseValue * (1 - depreciation) * engineMultiplier;
  }

  double _getMakeBaseValue() {
    final premiums = <String, double>{
      'Toyota': 25000000, 'Nissan': 18000000, 'Honda': 20000000,
      'Suzuki': 12000000, 'Mitsubishi': 15000000, 'Mazda': 16000000,
      'Subaru': 17000000, 'BMW': 35000000, 'Mercedes-Benz': 40000000,
      'Volvo': 28000000, 'Volkswagen': 22000000, 'Ford': 18000000,
      'Hyundai': 15000000, 'Kia': 14000000, 'Isuzu': 20000000,
      'Land Rover': 45000000, 'Lexus': 38000000, 'Audi': 30000000,
    };
    return premiums[_selectedMake] ?? 15000000;
  }

  double _getEngineMultiplier() {
    final cc = int.tryParse(_selectedEngineCC.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1800;
    if (cc <= 1000) return 0.7;
    if (cc <= 1500) return 0.85;
    if (cc <= 2000) return 1.0;
    if (cc <= 3000) return 1.3;
    return 1.6;
  }

  void _calculateTax() {
    final estimatedValue = _estimateCarValue();
    final freight = estimatedValue * 0.12;
    final insurance = estimatedValue * 0.02;
    final cifValue = estimatedValue + freight + insurance;
    final importDuty = cifValue * 0.25;
    double exciseDutyRate = _isNewCar ? _getNewCarExciseRate() : _getUsedCarExciseRate();
    final exciseDuty = (cifValue + importDuty) * exciseDutyRate;
    final vat = (cifValue + importDuty + exciseDuty) * 0.18;
    final sdl = cifValue * 0.015;
    final idf = cifValue * 0.006;
    final totalTax = importDuty + exciseDuty + vat + sdl + idf;
    setState(() { _calculatedTax = totalTax; _calculatedTotal = cifValue + totalTax; _showTaxResult = true; });
  }

  double _getNewCarExciseRate() {
    final cc = int.tryParse(_selectedEngineCC.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1800;
    if (cc <= 1000) return 0.05;
    if (cc <= 2000) return 0.10;
    if (cc <= 3000) return 0.20;
    return 0.30;
  }

  double _getUsedCarExciseRate() {
    final cc = int.tryParse(_selectedEngineCC.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1800;
    if (cc <= 1000) return 0.10;
    if (cc <= 2000) return 0.15;
    if (cc <= 3000) return 0.25;
    return 0.35;
  }

  void _depositToKibubu() {
    final amount = double.tryParse(_kibubuDepositController.text) ?? 0;
    if (amount <= 0) return;
    setState(() { _kibubuBalance += amount; _kibubuDepositController.clear(); });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('TZS ${amount.toStringAsFixed(0)} deposited to Kibubu!'),
      backgroundColor: AppColors.secondary, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Car'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildBanner(),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.savings, 'Kibubu Wallet', 'Save little by little until you reach your goal'),
          const SizedBox(height: 12), _buildKibubuCard(),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.store, 'Popular Sources', 'Choose where to import from'),
          const SizedBox(height: 12),
          _buildSourceCard('BE FORWARD', "Japan's #1 Exporter"),
          const SizedBox(height: 8), _buildSourceCard('SBT Japan', 'Reliable Used Cars'),
          const SizedBox(height: 8), _buildSourceCard('Local Dealers', 'Tanzania Dealerships'),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.assignment_turned_in, 'Inspection Services', 'Choose your inspection provider'),
          const SizedBox(height: 12),
          _buildInspectorOptionCard(
            icon: Icons.business,
            title: 'Company Inspectors',
            description: 'COTECNA, EAA, TBS & more',
            color: AppColors.primary,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanyInspectorsScreen())),
          ),
          const SizedBox(height: 8),
          _buildInspectorOptionCard(
            icon: Icons.person,
            title: 'Individual Inspectors',
            description: 'Verified independent inspectors',
            color: AppColors.serviceImportCar,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InspectorsScreen())),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.calculate, 'TRA Tax Calculator', 'Calculate import duties and taxes for your vehicle'),
          const SizedBox(height: 12), _buildTaxCalculator(),
          const SizedBox(height: 24),
          PrimaryButton(text: 'Start Import Process', icon: Icons.arrow_forward, onPressed: () {}),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, String subtitle) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 20, color: AppColors.serviceImportCar), const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 4),
      Padding(padding: const EdgeInsets.only(left: 28), child: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontStyle: FontStyle.italic))),
    ]);
  }

  Widget _buildBanner() {
    return Container(height: 160, width: double.infinity,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.serviceImportCar, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16)),
      child: const Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.directions_car, color: Colors.white, size: 36),
        SizedBox(height: 8), Text('Import Your Dream Car', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 4), Text('From Japan, UAE, and more', style: TextStyle(fontSize: 14, color: Colors.white70)),
      ])),
    );
  }

  Widget _buildKibubuCard() {
    final progress = (_kibubuBalance / _kibubuTarget).clamp(0.0, 1.0);
    final remaining = _kibubuTarget - _kibubuBalance;
    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.savings, color: AppColors.secondary, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Kibubu Savings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('Save towards your car import goal', style: TextStyle(fontSize: 11, color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.accentGreenLight, borderRadius: BorderRadius.circular(8)),
            child: const Text('Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary))),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('TZS ${_kibubuBalance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          Text('TZS ${_kibubuTarget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
        ]),
        const SizedBox(height: 6),
        SizedBox(width: double.infinity, child: ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.border, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary), minHeight: 10))),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${(progress * 100).toStringAsFixed(0)}% complete', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text('TZS ${remaining.toStringAsFixed(0)} remaining', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: TextField(controller: _kibubuDepositController, keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter amount (TZS)', prefixText: 'TZS ',
                prefixStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
                border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), isDense: true),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          )),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: _depositToKibubu,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(100, 52), elevation: 0),
            child: const Text('Deposit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: ['50,000', '100,000', '200,000', '500,000'].map((a) => 
          GestureDetector(onTap: () => _kibubuDepositController.text = a,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.accentGreenLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2))),
              child: Text('TZS $a', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.secondary))))
        ).toList()),
      ]),
    );
  }

  Widget _buildSourceCard(String name, String description) {
    return Container(padding: const EdgeInsets.all(14), width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.serviceImportCar.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.store, color: AppColors.serviceImportCar, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ])),
        const Icon(Icons.chevron_right, color: AppColors.textLight),
      ]),
    );
  }

  Widget _buildInspectorOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(14), width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 26)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 15)),
            const SizedBox(height: 3), Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          Icon(Icons.chevron_right, color: AppColors.textLight),
        ]),
      ),
    );
  }

  Widget _buildTaxCalculator() {
    return Container(padding: const EdgeInsets.all(16), width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.serviceCargo.withValues(alpha: 0.3))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.serviceCargo.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.calculate, color: AppColors.serviceCargo, size: 22)),
          const SizedBox(width: 10),
          const Expanded(child: Text('TRA Import Duty Calculator', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        ]),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(10), width: double.infinity,
          decoration: BoxDecoration(color: AppColors.serviceCargo.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
          child: const Row(children: [
            Icon(Icons.info_outline, size: 14, color: AppColors.serviceCargo),
            SizedBox(width: 6),
            Expanded(child: Text('Select Vehicle Details below to calculate value', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
          ])),
        const SizedBox(height: 16),
        _buildDropdown('Make', _selectedMake, _makes, (v) { if (v != null) setState(() => _selectedMake = v); }),
        const SizedBox(height: 10),
        _buildDropdown('Model & Body', _selectedModel, _models, (v) { if (v != null) setState(() => _selectedModel = v); }),
        const SizedBox(height: 10),
        _buildDropdown('Year of Manufacture', _selectedYear, _years, (v) { if (v != null) setState(() => _selectedYear = v); }),
        const SizedBox(height: 10),
        _buildDropdown('Country of Origin', _selectedCountry, _countries, (v) { if (v != null) setState(() => _selectedCountry = v); }),
        const SizedBox(height: 10),
        _buildDropdown('Fuel Type', _selectedFuelType, _fuelTypes, (v) { if (v != null) setState(() => _selectedFuelType = v); }),
        const SizedBox(height: 10),
        _buildDropdown('Engine', _selectedEngineCC, _engineOptions, (v) { if (v != null) setState(() => _selectedEngineCC = v); }),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: _calculateTax, icon: const Icon(Icons.calculate, size: 18), label: const Text('Calculate Tax'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.serviceCargo, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14)))),
        if (_showTaxResult) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), width: double.infinity,
            decoration: BoxDecoration(color: AppColors.accentGreenLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2))),
            child: Column(children: [
              const Text('Estimated Import Costs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              _taxRow('Est. Vehicle Value', 'TZS ${_estimateCarValue().toStringAsFixed(0)}', AppColors.textPrimary),
              const SizedBox(height: 4),
              _taxRow('Total Tax Payable', 'TZS ${_calculatedTax.toStringAsFixed(0)}', AppColors.serviceCargo),
              const SizedBox(height: 6),
              _taxRow('Total Cost (incl. tax)', 'TZS ${_calculatedTotal.toStringAsFixed(0)}', AppColors.primary),
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(10), width: double.infinity,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                child: const Row(children: [Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary), SizedBox(width: 6),
                  Expanded(child: Text('Rates may vary. Visit TRA for official assessment.', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontStyle: FontStyle.italic)))]))
            ])),
        ],
      ]),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      const SizedBox(height: 4),
      Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged))),
    ]);
  }

  Widget _taxRow(String label, String value, Color color) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
    ]);
  }
}