import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import 'cargo_booking_screen.dart';

class ScheduleTransportScreen extends StatefulWidget {
  const ScheduleTransportScreen({super.key});

  @override
  State<ScheduleTransportScreen> createState() => _ScheduleTransportScreenState();
}

enum _Step { vehicleSelection, form }

class _ScheduleTransportScreenState extends State<ScheduleTransportScreen> {
  _Step _step = _Step.vehicleSelection;
  String? _selectedVehicle;

  final _loadTypeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _weightKgCtrl = TextEditingController();
  final _weightTonsCtrl = TextEditingController();
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  final _formKey = GlobalKey<FormState>();

  final _pickupFocusNode = FocusNode();
  final _destFocusNode = FocusNode();

  // Pickup search
  List<Map<String, dynamic>> _pickupSuggestions = [];
  bool _isSearchingPickup = false;
  bool _showNoPickupResults = false;
  String? _pickupSearchError;
  Timer? _pickupDebounce;
  int _pickupReqId = 0;

  // Destination search
  List<Map<String, dynamic>> _destSuggestions = [];
  bool _isSearchingDest = false;
  bool _showNoDestResults = false;
  String? _destSearchError;
  Timer? _destDebounce;
  int _destReqId = 0;

  // Location data
  LatLng? _pickupPosition;
  String? _pickupName;
  LatLng? _destPosition;
  String? _destName;

  // Route data
  List<LatLng> _routePoints = [];
  double _routeDistKm = 0.0;
  String _routeEta = '';
  bool _isLoadingRoute = false;

  // Semi Truck extras
  String _cargoType = 'Loose';
  String _containerSize = '20ft';
  bool _isDangerous = false;

  // Book Space (Box Truck only)
  bool _isBookSpace = false;
  double _spacePercentage = 25.0;

  @override
  void initState() {
    super.initState();
    _pickupCtrl.addListener(_onPickupSearchChanged);
    _destCtrl.addListener(_onDestSearchChanged);
  }

  @override
  void dispose() {
    _pickupDebounce?.cancel();
    _destDebounce?.cancel();
    _pickupCtrl.removeListener(_onPickupSearchChanged);
    _destCtrl.removeListener(_onDestSearchChanged);
    _loadTypeCtrl.dispose();
    _phoneCtrl.dispose();
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    _weightKgCtrl.dispose();
    _weightTonsCtrl.dispose();
    _pickupFocusNode.dispose();
    _destFocusNode.dispose();
    super.dispose();
  }

  // ============================================================
  // WEIGHT AUTO-CALC
  // ============================================================

  void _onWeightKgChanged(String val) {
    final kg = double.tryParse(val);
    if (kg != null) {
      _weightTonsCtrl.text = (kg / 1000).toStringAsFixed(3);
    } else {
      _weightTonsCtrl.text = '';
    }
  }

  void _onWeightTonsChanged(String val) {
    final tons = double.tryParse(val);
    if (tons != null) {
      _weightKgCtrl.text = (tons * 1000).toStringAsFixed(1);
    } else {
      _weightKgCtrl.text = '';
    }
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _pickupDate = picked);
    }
  }

  String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ============================================================
  // PICKUP SEARCH (NOMINATIM)
  // ============================================================

  void _onPickupSearchChanged() {
    _pickupDebounce?.cancel();
    final q = _pickupCtrl.text.trim();
    if (q.isEmpty) {
      setState(() {
        _pickupSuggestions = [];
        _isSearchingPickup = false;
        _showNoPickupResults = false;
        _pickupSearchError = null;
      });
      return;
    }
    if (_pickupSearchError != null) setState(() => _pickupSearchError = null);
    _pickupDebounce = Timer(const Duration(milliseconds: 400), () => _searchPickupPlace(q));
  }

  Future<void> _searchPickupPlace(String q) async {
    final id = ++_pickupReqId;
    setState(() {
      _isSearchingPickup = true;
      _showNoPickupResults = false;
      if (_pickupSearchError?.contains('Check internet') == true) _pickupSearchError = null;
    });
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$q,Dar es Salaam,Tanzania')}&format=jsonv2&limit=5');
      final r = await http.get(url, headers: const {'User-Agent': 'LACAApp/1.0', 'Accept-Language': 'en'}).timeout(const Duration(seconds: 12));
      if (!mounted || id != _pickupReqId) return;
      if (r.statusCode == 200) {
        final List<dynamic> data = json.decode(r.body);
        if (data.isEmpty) {
          setState(() { _pickupSuggestions = []; _isSearchingPickup = false; _showNoPickupResults = true; });
          return;
        }
        setState(() {
          _pickupSuggestions = data.map((i) => {
            'name': (i['display_name'] as String?)?.split(',').first.trim() ?? 'Unknown',
            'address': i['display_name'] as String? ?? '',
            'lat': double.tryParse(i['lat']?.toString() ?? '') ?? 0.0,
            'lon': double.tryParse(i['lon']?.toString() ?? '') ?? 0.0,
          }).toList();
          _isSearchingPickup = false; _showNoPickupResults = false; _pickupSearchError = null;
        });
      } else {
        setState(() { _isSearchingPickup = false; _pickupSearchError = 'Search unavailable (${r.statusCode})'; });
      }
    } catch (e) {
      if (!mounted || id != _pickupReqId) return;
      setState(() { _isSearchingPickup = false; if (_pickupSuggestions.isEmpty) _pickupSearchError = 'Could not connect. Check internet.'; });
    }
  }

  void _selectPickup(String name, String address, double lat, double lon) {
    _pickupFocusNode.unfocus();
    _pickupCtrl.text = address;
    setState(() {
      _pickupSuggestions = [];
      _pickupPosition = LatLng(lat, lon);
      _pickupName = name;
    });
    _fetchRoute();
  }

  // ============================================================
  // DESTINATION SEARCH (NOMINATIM)
  // ============================================================

  void _onDestSearchChanged() {
    _destDebounce?.cancel();
    final q = _destCtrl.text.trim();
    if (q.isEmpty) {
      setState(() {
        _destSuggestions = [];
        _isSearchingDest = false;
        _showNoDestResults = false;
        _destSearchError = null;
      });
      return;
    }
    if (_destSearchError != null) setState(() => _destSearchError = null);
    _destDebounce = Timer(const Duration(milliseconds: 400), () => _searchDestPlace(q));
  }

  Future<void> _searchDestPlace(String q) async {
    final id = ++_destReqId;
    setState(() {
      _isSearchingDest = true;
      _showNoDestResults = false;
      if (_destSearchError?.contains('Check internet') == true) _destSearchError = null;
    });
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$q,Dar es Salaam,Tanzania')}&format=jsonv2&limit=5');
      final r = await http.get(url, headers: const {'User-Agent': 'LACAApp/1.0', 'Accept-Language': 'en'}).timeout(const Duration(seconds: 12));
      if (!mounted || id != _destReqId) return;
      if (r.statusCode == 200) {
        final List<dynamic> data = json.decode(r.body);
        if (data.isEmpty) {
          setState(() { _destSuggestions = []; _isSearchingDest = false; _showNoDestResults = true; });
          return;
        }
        setState(() {
          _destSuggestions = data.map((i) => {
            'name': (i['display_name'] as String?)?.split(',').first.trim() ?? 'Unknown',
            'address': i['display_name'] as String? ?? '',
            'lat': double.tryParse(i['lat']?.toString() ?? '') ?? 0.0,
            'lon': double.tryParse(i['lon']?.toString() ?? '') ?? 0.0,
          }).toList();
          _isSearchingDest = false; _showNoDestResults = false; _destSearchError = null;
        });
      } else {
        setState(() { _isSearchingDest = false; _destSearchError = 'Search unavailable (${r.statusCode})'; });
      }
    } catch (e) {
      if (!mounted || id != _destReqId) return;
      setState(() { _isSearchingDest = false; if (_destSuggestions.isEmpty) _destSearchError = 'Could not connect. Check internet.'; });
    }
  }

  void _selectDest(String name, String address, double lat, double lon) {
    _destFocusNode.unfocus();
    _destCtrl.text = address;
    setState(() {
      _destSuggestions = [];
      _destPosition = LatLng(lat, lon);
      _destName = name;
    });
    _fetchRoute();
  }

  // ============================================================
  // ROUTE FETCHING (OSRM)
  // ============================================================

  Future<void> _fetchRoute() async {
    if (_pickupPosition == null || _destPosition == null) return;
    setState(() => _isLoadingRoute = true);
    try {
      final p = _pickupPosition!;
      final d = _destPosition!;
      final url = Uri.parse('https://router.project-osrm.org/route/v1/driving/${p.longitude},${p.latitude};${d.longitude},${d.latitude}?overview=full&geometries=geojson');
      final r = await http.get(url).timeout(const Duration(seconds: 12));
      if (!mounted) return;
      if (r.statusCode == 200) {
        final data = json.decode(r.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final distM = (route['distance'] ?? 0).toDouble();
          final dur = (route['duration'] ?? 0).toDouble();
          final coords = route['geometry']['coordinates'] as List;
          final pts = coords.map((c) => LatLng(c[1] as double, c[0] as double)).toList();
          final h = (dur / 3600).floor();
          final m = ((dur % 3600) / 60).round();
          setState(() {
            _routePoints = pts;
            _routeDistKm = distM / 1000;
            _routeEta = h > 0 ? '${h}h ${m}min' : '$m min';
            _isLoadingRoute = false;
          });
          return;
        }
      }
      _fallbackRoute();
    } catch (_) {
      if (mounted) _fallbackRoute();
    }
  }

  void _fallbackRoute() {
    if (_pickupPosition == null || _destPosition == null) return;
    final d = _haversine(_pickupPosition!, _destPosition!);
    setState(() {
      _routePoints = [_pickupPosition!, _destPosition!];
      _routeDistKm = d;
      final h = (d / 40).floor();
      final m = ((d / 40 * 60) % 60).round();
      _routeEta = h > 0 ? '${h}h ${m}min' : '$m min';
      _isLoadingRoute = false;
    });
  }

  double _haversine(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;
    return r * 2 * atan2(
      sqrt(sin(dLat / 2) * sin(dLat / 2) +
        cos(a.latitude * pi / 180) * cos(b.latitude * pi / 180) * sin(dLon / 2) * sin(dLon / 2)),
      sqrt(1 - (sin(dLat / 2) * sin(dLat / 2) +
        cos(a.latitude * pi / 180) * cos(b.latitude * pi / 180) * sin(dLon / 2) * sin(dLon / 2))),
    );
  }

  // ============================================================
  // BOOK SPACE — PRICE CALCULATION
  // ============================================================

  final double _baseRatePerKm = 500;

  double _fullTruckPrice() => _routeDistKm * _baseRatePerKm;

  double _bookSpacePrice() => _fullTruckPrice() * (_spacePercentage / 100);

  double _advancePayment() => _bookSpacePrice() * 0.3;

  // ============================================================
  // SUBMIT / SUCCESS DIALOG / NAVIGATE
  // ============================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _showSuccessDialog();
  }

  void _submitBookSpace() {
    if (!_formKey.currentState!.validate()) return;
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
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, size: 40, color: AppColors.warning),
              ),
              const SizedBox(height: 20),
              const Text(
                'Space Booking Confirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _summaryRow('Space Booked', '${_spacePercentage.round()}%'),
                    const SizedBox(height: 6),
                    _summaryRow('Total Price', 'TZS ${_bookSpacePrice().toStringAsFixed(0)}'),
                    const SizedBox(height: 6),
                    _summaryRow('Advance Paid (30%)', 'TZS ${_advancePayment().toStringAsFixed(0)}', isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining TZS ${(_bookSpacePrice() - _advancePayment()).toStringAsFixed(0)} will be paid after delivery',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.warning : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
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
                'Transport Request\nSubmitted Successfully!',
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
                'Your request for $_selectedVehicle has been received.',
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
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openBookingScreen();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping, size: 20),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Want to transport now?\nCheck on the available vehicles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBookingScreen() {
    final defaultPos = const LatLng(-6.7924, 39.2083);
    final pickup = _pickupPosition ?? defaultPos;
    final dest = _destPosition ?? defaultPos;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CargoBookingScreen(
          pickupLocation: pickup,
          dropoffLocation: dest,
          pickupAddress: _pickupName ?? _pickupCtrl.text,
          dropoffAddress: _destName ?? _destCtrl.text,
          distanceKm: _routeDistKm > 0 ? _routeDistKm : _haversine(pickup, dest),
          routeEta: _routeEta.isNotEmpty ? _routeEta : 'Calculating...',
          routePoints: _routePoints.isNotEmpty ? _routePoints : [],
          phone: _phoneCtrl.text.trim(),
          vehicleType: _selectedVehicle ?? 'Box Truck',
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _step == _Step.vehicleSelection ? 'Schedule Transport' : 'Transport Details',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _step == _Step.form
              ? () => setState(() => _step = _Step.vehicleSelection)
              : () => Navigator.pop(context),
        ),
      ),
      body: _step == _Step.vehicleSelection ? _buildVehicleSelection() : _buildForm(),
    );
  }

  // ============================================================
  // VEHICLE SELECTION
  // ============================================================

  Widget _buildVehicleSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Choose Vehicle Type',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select the type of truck for your transport',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          _vehicleCard(
            iconPath: 'assets/images/Boxtruck_icon.jpg',
            name: 'Box Truck',
            desc: 'Enclosed truck \u2014 ideal for furniture,\nelectronics & palletized goods',
            capacity: 'Up to 3,000 kg',
            color: const Color(0xFF1565C0),
            bgColor: const Color(0xFFE3F2FD),
            onTap: () => setState(() {
              _selectedVehicle = 'Box Truck';
              _step = _Step.form;
            }),
          ),
          const SizedBox(height: 16),
          _vehicleCard(
            iconPath: 'assets/images/semitruck_icon.png',
            name: 'Semi Truck',
            desc: 'Large container truck \u2014 for heavy\nequipment, bulk & containers',
            capacity: 'Up to 10,000 kg',
            color: const Color(0xFFB71C1C),
            bgColor: const Color(0xFFFFEBEE),
            onTap: () => setState(() {
              _selectedVehicle = 'Semi Truck';
              _step = _Step.form;
            }),
          ),
        ],
      ),
    );
  }

  Widget _vehicleCard({
    required String iconPath,
    required String name,
    required String desc,
    required String capacity,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          capacity,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.chevron_right, color: AppColors.textLight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FORM
  // ============================================================

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Vehicle header banner ----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _selectedVehicle == 'Box Truck'
                        ? const Color(0xFF1565C0)
                        : const Color(0xFFB71C1C),
                    _selectedVehicle == 'Box Truck'
                        ? const Color(0xFF1976D2)
                        : const Color(0xFFD32F2F),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (_selectedVehicle == 'Box Truck'
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFB71C1C))
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      _selectedVehicle == 'Box Truck'
                          ? 'assets/images/Boxtruck_icon.jpg'
                          : 'assets/images/semitruck_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVehicle ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Fill in the details below',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---- Book Space toggle (Box Truck only) ----
            if (_selectedVehicle == 'Box Truck') ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.local_offer, color: AppColors.warning, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Space',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Book partial space instead of the whole truck',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Switch(
                          value: _isBookSpace,
                          onChanged: (v) => setState(() => _isBookSpace = v),
                          activeColor: AppColors.warning,
                        ),
                      ],
                    ),
                    if (_isBookSpace) ...[
                      const SizedBox(height: 16),
                      const Text('Space Coverage', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Slider(
                        value: _spacePercentage,
                        min: 5,
                        max: 100,
                        divisions: 19,
                        label: '${_spacePercentage.round()}%',
                        onChanged: (v) => setState(() => _spacePercentage = v),
                        activeColor: AppColors.warning,
                      ),
                      Center(
                        child: Text(
                          '${_spacePercentage.round()}% of truck space',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.warning),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_routeDistKm > 0) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Full Truck Price', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  Text('TZS ${_fullTruckPrice().toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your Space (${_spacePercentage.round()}%)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  Text('TZS ${_bookSpacePrice().toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
                                ],
                              ),
                              const Divider(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, size: 14, color: AppColors.warning),
                                    const SizedBox(width: 6),
                                    Text(
                                      '30% Advance: TZS ${_advancePayment().toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Pay 30% in advance to seal your space booking',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ---- Load Information ----
            const Text(
              'Load Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildField(
              controller: _loadTypeCtrl,
              label: 'Type of Load',
              hint: 'e.g. Furniture, Electronics, Grains...',
              icon: Icons.inventory_2,
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter load type' : null,
            ),

            const SizedBox(height: 16),
            _buildField(
              controller: _phoneCtrl,
              label: 'Phone Number',
              hint: 'e.g. 0712 345 678',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter phone number' : null,
            ),

            // ---- Semi Truck: Cargo type (loose / container) ----
            if (_selectedVehicle == 'Semi Truck') ...[
              const SizedBox(height: 8),
              const Text('Cargo Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _radioCard(
                    value: 'Loose',
                    group: _cargoType,
                    label: 'Loose Cargo',
                    icon: Icons.pallet,
                    onChanged: (v) => setState(() => _cargoType = v),
                  ),
                  const SizedBox(width: 12),
                  _radioCard(
                    value: 'Container',
                    group: _cargoType,
                    label: 'Container',
                    icon: Icons.inventory_2,
                    onChanged: (v) => setState(() => _cargoType = v),
                  ),
                ],
              ),
              if (_cargoType == 'Container') ...[
                const SizedBox(height: 12),
                const Text('Container Size', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _radioCard(
                      value: '20ft',
                      group: _containerSize,
                      label: '20 Feet',
                      icon: Icons.straighten,
                      onChanged: (v) => setState(() => _containerSize = v),
                    ),
                    const SizedBox(width: 12),
                    _radioCard(
                      value: '40ft',
                      group: _containerSize,
                      label: '40 Feet',
                      icon: Icons.straighten,
                      onChanged: (v) => setState(() => _containerSize = v),
                    ),
                  ],
                ),
              ],
            ],

            const SizedBox(height: 16),

            // ---- Pickup Location (with search) ----
            _buildSearchField(
              controller: _pickupCtrl,
              focusNode: _pickupFocusNode,
              label: 'Pickup Location',
              hint: 'Search pickup location',
              icon: Icons.trip_origin,
              iconColor: AppColors.serviceAgro,
              suggestions: _pickupSuggestions,
              isSearching: _isSearchingPickup,
              noResults: _showNoPickupResults,
              searchError: _pickupSearchError,
              onSelect: _selectPickup,
              onClear: () {
                _pickupCtrl.clear();
                setState(() {
                  _pickupPosition = null;
                  _pickupName = null;
                  _pickupSuggestions = [];
                  _routePoints = [];
                  _routeDistKm = 0;
                  _routeEta = '';
                });
              },
            ),

            const SizedBox(height: 16),

            // ---- Destination Location (with search) ----
            _buildSearchField(
              controller: _destCtrl,
              focusNode: _destFocusNode,
              label: 'Destination Location',
              hint: 'Search destination location',
              icon: Icons.flag,
              iconColor: AppColors.error,
              suggestions: _destSuggestions,
              isSearching: _isSearchingDest,
              noResults: _showNoDestResults,
              searchError: _destSearchError,
              onSelect: _selectDest,
              onClear: () {
                _destCtrl.clear();
                setState(() {
                  _destPosition = null;
                  _destName = null;
                  _destSuggestions = [];
                  _routePoints = [];
                  _routeDistKm = 0;
                  _routeEta = '';
                });
              },
            ),

            // ---- Route info banner ----
            if (_routeDistKm > 0 && _pickupPosition != null && _destPosition != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.serviceSendPackage.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.serviceSendPackage.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.route, size: 18, color: AppColors.serviceSendPackage),
                      const SizedBox(width: 8),
                      Text(
                        '${_routeDistKm.toStringAsFixed(1)} km  •  $_routeEta',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.serviceSendPackage,
                        ),
                      ),
                      if (_isLoadingRoute) ...[
                        const SizedBox(width: 8),
                        const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                      ],
                    ],
                  ),
                ),
              ),

            // ---- Semi Truck: Dangerous / Non-Dangerous ----
            if (_selectedVehicle == 'Semi Truck') ...[
              const SizedBox(height: 20),
              const Text('Cargo Classification', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _radioCard(
                    value: true,
                    group: _isDangerous,
                    label: 'Dangerous',
                    icon: Icons.warning_amber_rounded,
                    colorWhenSelected: AppColors.error,
                    onChanged: (v) => setState(() => _isDangerous = v),
                  ),
                  const SizedBox(width: 12),
                  _radioCard(
                    value: false,
                    group: _isDangerous,
                    label: 'Non Dangerous',
                    icon: Icons.check_circle_outline,
                    colorWhenSelected: AppColors.success,
                    onChanged: (v) => setState(() => _isDangerous = v),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // ---- Weight & Schedule ----
            const Text(
              'Weight & Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _weightKgCtrl,
                    label: 'Weight (KG)',
                    hint: 'e.g. 1500',
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                    onChanged: _onWeightKgChanged,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: _weightTonsCtrl,
                    label: 'Weight (Tons)',
                    hint: 'e.g. 1.5',
                    icon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                    onChanged: _onWeightTonsChanged,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ---- Pickup Date ----
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Pickup Date',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _fmtDate(_pickupDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ---- Submit button ----
            if (_isBookSpace && _routeDistKm > 0)
              PrimaryButton(
                text: 'Pay 30% Advance (TZS ${_advancePayment().toStringAsFixed(0)})',
                icon: Icons.lock,
                onPressed: _submitBookSpace,
              )
            else
              PrimaryButton(
                text: 'Submit Transport Request',
                icon: Icons.check_circle,
                onPressed: _submit,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH FIELD WITH SUGGESTIONS
  // ============================================================

  Widget _buildSearchField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, dynamic>> suggestions,
    required bool isSearching,
    required bool noResults,
    required String? searchError,
    required Function(String name, String address, double lat, double lon) onSelect,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
              prefixIcon: Icon(icon, size: 22, color: iconColor),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: AppColors.textLight),
                      onPressed: onClear,
                    )
                  : null,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
        ),
        if (isSearching)
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 6),
            child: Row(
              children: [
                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Searching...', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        if (searchError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, size: 14, color: AppColors.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(searchError, style: const TextStyle(fontSize: 11, color: AppColors.error)),
                ),
              ],
            ),
          ),
        if (noResults)
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 6),
            child: Row(
              children: [
                Icon(Icons.search_off, size: 14, color: AppColors.textLight),
                SizedBox(width: 6),
                Text('No places found', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
        if (suggestions.isNotEmpty)
          ...suggestions.map((s) => _suggestionItem(
                s['name'] as String,
                s['address'] as String,
                (s['lat'] as num).toDouble(),
                (s['lon'] as num).toDouble(),
                onSelect,
                iconColor,
              )),
      ],
    );
  }

  Widget _suggestionItem(
    String name,
    String address,
    double lat,
    double lon,
    Function(String name, String address, double lat, double lon) onSelect,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => onSelect(name, address, lat, lon),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.location_on, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 1),
                  Text(address,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RADIO CARD
  // ============================================================

  Widget _radioCard<T>({
    required T value,
    required T group,
    required String label,
    required IconData icon,
    Color? colorWhenSelected,
    required ValueChanged<T> onChanged,
  }) {
    final selected = value == group;
    final activeColor = colorWhenSelected ?? AppColors.primary;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? activeColor.withValues(alpha: 0.08) : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? activeColor : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? activeColor : AppColors.textLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? activeColor : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STANDARD FORM FIELD
  // ============================================================

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
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
}
