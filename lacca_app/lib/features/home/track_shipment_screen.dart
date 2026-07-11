import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/google_map_tile.dart';
import '../vehicles/my_vehicles_screen.dart';

class TrackShipmentScreen extends StatefulWidget {
  const TrackShipmentScreen({super.key});

  @override
  State<TrackShipmentScreen> createState() => _TrackShipmentScreenState();
}

class _TrackShipmentScreenState extends State<TrackShipmentScreen> {
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();
  final TextEditingController _trackingInputCtrl = TextEditingController();

  // Driver — create tracking
  final TextEditingController _pickupCtrl = TextEditingController();
  final TextEditingController _destCtrl = TextEditingController();
  final TextEditingController _cargoDescCtrl = TextEditingController();

  String? _generatedTrackingNumber;
  List<_TrackedShipment> _shipments = [];
  _TrackedShipment? _activeTracking;

  @override
  void dispose() {
    _sheetCtrl.dispose();
    _trackingInputCtrl.dispose();
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    _cargoDescCtrl.dispose();
    super.dispose();
  }

  String _generateTrackingNumber() {
    final now = DateTime.now();
    final rand = Random().nextInt(9000) + 1000;
    return 'LCA-TRK-${now.year}-$rand';
  }

  void _createTracking() {
    if (_pickupCtrl.text.trim().isEmpty || _destCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter pickup and destination'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final number = _generateTrackingNumber();
    final shipment = _TrackedShipment(
      trackingNumber: number,
      pickup: _pickupCtrl.text.trim(),
      destination: _destCtrl.text.trim(),
      cargoDesc: _cargoDescCtrl.text.trim().isNotEmpty ? _cargoDescCtrl.text.trim() : 'General cargo',
      status: 'In Transit',
      createdAt: DateTime.now(),
    );
    setState(() {
      _generatedTrackingNumber = number;
      _shipments.insert(0, shipment);
      _activeTracking = shipment;
      _pickupCtrl.clear();
      _destCtrl.clear();
      _cargoDescCtrl.clear();
    });
    _sheetCtrl.animateTo(0.18, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _trackShipment() {
    final input = _trackingInputCtrl.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter a tracking number'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final found = _shipments.where((s) => s.trackingNumber == input).toList();
    if (found.isNotEmpty) {
      setState(() {
        _activeTracking = found.first;
        _trackingInputCtrl.clear();
      });
      _sheetCtrl.animateTo(0.18, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tracking number not found'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _shareTracking(String number) {
    Clipboard.setData(ClipboardData(text: number));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking number $number copied to clipboard'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  LatLng _randomPoint() {
    final rng = Random();
    final lat = -6.8 + rng.nextDouble() * 0.4;
    final lon = 39.2 + rng.nextDouble() * 0.3;
    return LatLng(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const center = LatLng(-6.7924, 39.2083);

    // Build markers
    final markers = <Marker>[];
    if (_activeTracking != null) {
      markers.add(
        MapMarkerHelper.buildMarker(
          point: center,
          label: 'Origin: ${_activeTracking!.pickup}',
          color: AppColors.serviceTrack,
          icon: Icons.my_location,
          size: 28,
        ),
      );
      markers.add(
        MapMarkerHelper.buildVehicleMarker(
          point: _randomPoint(),
          plate: _activeTracking!.trackingNumber,
          color: AppColors.warning,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ---- Full-screen map ----
          Positioned.fill(
            child: GoogleMapView(
              height: double.infinity,
              center: center,
              zoom: 12,
              markers: markers,
              showToggleButton: true,
              showZoomControls: true,
              showMyLocationButton: true,
            ),
          ),

          // ---- Back button ----
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),

          // ---- Active tracking pill ----
          if (_activeTracking != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.serviceTrack.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_shipping, color: AppColors.serviceTrack, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeTracking!.trackingNumber,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_activeTracking!.pickup} → ${_activeTracking!.destination}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _activeTracking!.status,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ---- Draggable bottom sheet ----
          DraggableScrollableSheet(
            controller: _sheetCtrl,
            initialChildSize: 0.45,
            minChildSize: 0.12,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.12, 0.45, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4)),
                  ],
                ),
                child: Stack(
                  children: [
                    // ---- Scrollable content ----
                    ListView(
                      controller: scrollController,
                      padding: EdgeInsets.only(bottom: 80 + bottomPadding),
                      children: [
                        // ---- Drag handle ----
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: 40, height: 5,
                              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3)),
                            ),
                          ),
                        ),

                        // ---- Header ----
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Track Shipment',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Create a tracking number or track your cargo',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ============================================================
                        // SECTION: My Vehicles — Quick Access
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.directions_car, color: AppColors.primary, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'My Vehicles',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Monitor your fleet health & location',
                                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: AppColors.textLight),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _fleetStat(Icons.check_circle, 'Active', AppColors.success),
                                    const SizedBox(width: 16),
                                    _fleetStat(Icons.local_shipping, 'In Transit', AppColors.warning),
                                    const SizedBox(width: 16),
                                    _fleetStat(Icons.build, 'Issues', AppColors.error),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const MyVehiclesScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                    child: const Text('Manage Fleet', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ============================================================
                        // SECTION 1: IT DRIVER — Create Tracking Number
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 4, height: 18,
                                decoration: BoxDecoration(color: AppColors.serviceTrack, borderRadius: BorderRadius.circular(2)),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'IT Driver — Create Tracking',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Generated tracking number
                        if (_generatedTrackingNumber != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.serviceTrack.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.serviceTrack.withValues(alpha: 0.2)),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Tracking Number Generated',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.serviceTrack),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _generatedTrackingNumber!,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _iconBtn(Icons.copy, 'Copy', () => _shareTracking(_generatedTrackingNumber!)),
                                      const SizedBox(width: 16),
                                      _iconBtn(Icons.share, 'Share', () => _shareTracking(_generatedTrackingNumber!)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),

                        // Pickup
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _pickupCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Pickup location',
                                prefixIcon: Icon(Icons.trip_origin, color: AppColors.serviceAgro, size: 22),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Destination
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _destCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Destination',
                                prefixIcon: Icon(Icons.flag, color: AppColors.error, size: 22),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Cargo description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _cargoDescCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Cargo description (optional)',
                                prefixIcon: Icon(Icons.inventory_2, color: AppColors.textLight, size: 22),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _createTracking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.serviceTrack,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Create Tracking Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ============================================================
                        // SECTION 2: CLIENT — Track Shipment
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 4, height: 18,
                                decoration: BoxDecoration(color: AppColors.serviceSendPackage, borderRadius: BorderRadius.circular(2)),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Track a Shipment',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _trackingInputCtrl,
                              decoration: InputDecoration(
                                hintText: 'Enter tracking number',
                                prefixIcon: const Icon(Icons.qr_code_scanner, color: AppColors.textLight, size: 20),
                                suffixIcon: _trackingInputCtrl.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textLight),
                                        onPressed: () => _trackingInputCtrl.clear(),
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _trackShipment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.serviceSendPackage,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Track Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),

                        // ---- Active tracking details ----
                        if (_activeTracking != null) ...[
                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 4, height: 18,
                                  decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(2)),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Shipment Details',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  _detailRow(Icons.qr_code, 'Tracking No.', _activeTracking!.trackingNumber),
                                  const Divider(height: 16),
                                  _detailRow(Icons.trip_origin, 'Pickup', _activeTracking!.pickup),
                                  const Divider(height: 16),
                                  _detailRow(Icons.flag, 'Destination', _activeTracking!.destination),
                                  const Divider(height: 16),
                                  _detailRow(Icons.inventory_2, 'Cargo', _activeTracking!.cargoDesc),
                                  const Divider(height: 16),
                                  _detailRow(Icons.info_outline, 'Status', _activeTracking!.status),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // ---- Recent shipments list ----
                        if (_shipments.isNotEmpty) ...[
                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 4, height: 18,
                                  decoration: BoxDecoration(color: AppColors.serviceTrack, borderRadius: BorderRadius.circular(2)),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Recent Shipments',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...List.generate(_shipments.length, (i) {
                            final s = _shipments[i];
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 20, right: 20,
                                bottom: i < _shipments.length - 1 ? 8 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _activeTracking = s);
                                  _sheetCtrl.animateTo(0.18, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: _activeTracking?.trackingNumber == s.trackingNumber
                                        ? AppColors.serviceTrack.withValues(alpha: 0.06)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _activeTracking?.trackingNumber == s.trackingNumber
                                          ? AppColors.serviceTrack
                                          : AppColors.border,
                                      width: _activeTracking?.trackingNumber == s.trackingNumber ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.serviceTrack.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.local_shipping, color: AppColors.serviceTrack, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s.trackingNumber,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${s.pickup} → ${s.destination}',
                                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'In Transit',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.warning),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),

                    // ---- Fixed bottom tracking pill (shows when actively tracking) ----
                    if (_activeTracking != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () => _shareTracking(_activeTracking!.trackingNumber),
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text('Share Tracking Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _fleetStat(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.serviceTrack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _TrackedShipment {
  final String trackingNumber;
  final String pickup;
  final String destination;
  final String cargoDesc;
  final String status;
  final DateTime createdAt;

  const _TrackedShipment({
    required this.trackingNumber,
    required this.pickup,
    required this.destination,
    required this.cargoDesc,
    required this.status,
    required this.createdAt,
  });
}
