import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/google_map_tile.dart';
import '../../core/utils/responsive.dart';
import 'trip_tracking_screen.dart';

class BookingScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final double distanceKm;
  final String routeEta;
  final List<LatLng> routePoints;

  const BookingScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distanceKm,
    required this.routeEta,
    this.routePoints = const [],
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 0;
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();

  static const List<_Vehicle> _vehicles = [
    _Vehicle(
      name: 'Courier', type: 'On Foot', icon: Icons.person,
      color: Color(0xFF607D8B), bg: Color(0xFFECEFF1),
      price: 100, weight: '2 kg',
    ),
    _Vehicle(
      name: 'Boda', type: 'Motorcycle', icon: Icons.motorcycle,
      color: Color(0xFF00A651), bg: Color(0xFFE8F5E9),
      price: 350, weight: '5 kg',
    ),
    _Vehicle(
      name: 'Bajaji', type: 'Tricycle', icon: Icons.electric_rickshaw,
      color: Color(0xFF2196F3), bg: Color(0xFFE3F2FD),
      price: 550, weight: '15 kg',
    ),
    _Vehicle(
      name: 'Carry Truck', type: 'Pickup', icon: Icons.local_shipping,
      color: Color(0xFFFF9800), bg: Color(0xFFFFF3E0),
      price: 750, weight: '500 kg',
    ),
    _Vehicle(
      name: 'Town Hiace', type: 'Minibus', icon: Icons.directions_bus,
      color: Color(0xFF9C27B0), bg: Color(0xFFF3E5F5),
      price: 950, weight: '2,000 kg',
    ),
  ];

  _Vehicle get _sel => _vehicles[_selectedIndex];

  int _roundTo500(double val) {
    return (val / 500).round() * 500;
  }

  String _format(int amt) {
    return 'TZS ${amt.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String get _totalPrice {
    final t = _roundTo500(widget.distanceKm * _sel.price);
    return _format(t);
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      MapMarkerHelper.buildMarker(
        point: widget.pickupLocation, label: 'Pickup',
        color: AppColors.serviceSendPackage, icon: Icons.my_location, size: 28,
      ),
      MapMarkerHelper.buildDestinationMarker(
        point: widget.dropoffLocation, label: 'Drop-off',
      ),
    ];

    final polylines = <Polyline>[];
    if (widget.routePoints.isNotEmpty) {
      polylines.add(
        MapRouteHelper.buildRoute(
          points: widget.routePoints,
          color: AppColors.serviceSendPackage,
          strokeWidth: 5,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen map with route
          Positioned.fill(
            child: GoogleMapView(
              height: double.infinity,
              center: widget.pickupLocation,
              zoom: 13.0,
              markers: markers,
              polylines: polylines,
              showToggleButton: true,
              showZoomControls: true,
              showMyLocationButton: true,
            ),
          ),

          // Back button
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
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          // Draggable bottom sheet with vehicles
          DraggableScrollableSheet(
            controller: _sheetCtrl,
            initialChildSize: 0.45,
            minChildSize: 0.15,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.15, 0.45, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 8,
                  ),
                  children: [
                    // Drag handle
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: 40, height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Choose Vehicle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Select a delivery vehicle for your route',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Route summary
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _dot(Icons.trip_origin, AppColors.serviceSendPackage, widget.pickupAddress),
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  width: 2, height: 10,
                                  color: AppColors.border,
                                ),
                                _dot(Icons.flag, AppColors.error, widget.dropoffAddress),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('${widget.distanceKm.toStringAsFixed(1)} km',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(widget.routeEta,
                                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Vehicle cards
                    ...List.generate(_vehicles.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.w(context, 16),
                          right: Responsive.w(context, 16),
                          bottom: Responsive.h(context, 8),
                        ),
                        child: _buildCard(context, i),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Request button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 20)),
                      child: PrimaryButton(
                        text: 'Request ${_sel.name} — $_totalPrice',
                        icon: Icons.arrow_forward,
                        onPressed: () => _confirm(context),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, int i) {
    final v = _vehicles[i];
    final sel = i == _selectedIndex;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(Responsive.w(context, 12)),
        decoration: BoxDecoration(
          color: sel ? v.color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
          border: Border.all(color: sel ? v.color : AppColors.border, width: sel ? 2 : 1),
          boxShadow: sel
              ? [BoxShadow(color: v.color.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: sel ? v.color : v.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: sel
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Icon(v.icon, size: 22, color: v.color),
            ),
            SizedBox(width: Responsive.w(context, 10)),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(v.name,
                              style: TextStyle(
                                  fontSize: Responsive.sp(context, 14),
                                  fontWeight: FontWeight.bold,
                                  color: sel ? v.color : AppColors.textPrimary)),
                        ),
                      ),
                      SizedBox(width: Responsive.w(context, 4)),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(_format(_roundTo500(widget.distanceKm * v.price)),
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 12),
                                fontWeight: FontWeight.bold,
                                color: sel ? v.color : AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(context, 3)),
                  Wrap(
                    spacing: 4, runSpacing: 2,
                    children: [
                      _chip(context, v.color, v.type),
                      _chip(context, null, 'TZS ${_format(_roundTo500(v.price.toDouble()))}/km'),
                      _chip(context, null, v.weight),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, Color? color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color != null ? color.withValues(alpha: 0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 9),
                fontWeight: color != null ? FontWeight.w500 : FontWeight.normal,
                color: color ?? AppColors.textSecondary)),
      ),
    );
  }

  Widget _dot(IconData icon, Color color, String addr) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(addr,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  void _confirm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripTrackingScreen(
          pickupLocation: widget.pickupLocation,
          dropoffLocation: widget.dropoffLocation,
          pickupAddress: widget.pickupAddress,
          dropoffAddress: widget.dropoffAddress,
          routePoints: widget.routePoints,
          vehicleName: _sel.name,
          vehicleIcon: _sel.icon,
          vehicleColor: _sel.color,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

}

class _Vehicle {
  final String name, type, weight;
  final IconData icon;
  final Color color, bg;
  final int price;

  const _Vehicle({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.bg,
    required this.price,
    required this.weight,
  });
}