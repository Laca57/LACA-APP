import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/google_map_tile.dart';

class BoltRideOptionsScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropoffAddress;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final double distanceKm;
  const BoltRideOptionsScreen({
    super.key,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.distanceKm = 0,
  });
  @override
  State<BoltRideOptionsScreen> createState() => _BoltRideOptionsScreenState();
}

class _BoltRideOptionsScreenState extends State<BoltRideOptionsScreen> {
  MapTileType _mapType = MapTileType.standard;
  int _selectedVehicleIndex = 0;
  List<LatLng> _roadRoute = [];
  bool _isLoadingRoute = true;
  late final double _distanceKm;
  late final List<Map<String, dynamic>> _vehicleOptions;

  @override
  void initState() {
    super.initState();
    _distanceKm = widget.distanceKm > 0 ? widget.distanceKm : _calculateDistance(widget.pickupLocation, widget.dropoffLocation);
    _vehicleOptions = [
      {'name': 'Boda Boda', 'type': 'Motorcycle', 'icon': Icons.motorcycle_rounded, 'color': const Color(0xFF00A651), 'pricePerKm': 350, 'eta': '5 min', 'maxWeight': '5 kg', 'description': 'Fastest way through traffic', 'iconBg': const Color(0xFFE8F5E9)},
      {'name': 'Bajaji', 'type': 'Tricycle', 'icon': Icons.electric_bike_rounded, 'color': const Color(0xFF2196F3), 'pricePerKm': 550, 'eta': '7 min', 'maxWeight': '15 kg', 'description': 'Covered ride for fragile items', 'iconBg': const Color(0xFFE3F2FD)},
      {'name': 'Carry Truck', 'type': 'Pickup Truck', 'icon': Icons.local_shipping_rounded, 'color': const Color(0xFFFF9800), 'pricePerKm': 750, 'eta': '12 min', 'maxWeight': '500 kg', 'description': 'For furniture & bulk cargo', 'iconBg': const Color(0xFFFFF3E0)},
      {'name': 'Town Hiace', 'type': 'Minibus', 'icon': Icons.directions_bus_rounded, 'color': const Color(0xFF9C27B0), 'pricePerKm': 950, 'eta': '15 min', 'maxWeight': '2,000 kg', 'description': 'High capacity for heavy shipments', 'iconBg': const Color(0xFFF3E5F5)},
    ];
    _fetchRoadRoute();
  }

  double _calculateDistance(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;
    final h = sin(dLat / 2) * sin(dLat / 2) + cos(a.latitude * pi / 180) * cos(b.latitude * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(h), sqrt(1 - h));
  }

  Future<void> _fetchRoadRoute() async {
    setState(() => _isLoadingRoute = true);
    try {
      final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${widget.pickupLocation.longitude},${widget.pickupLocation.latitude};${widget.dropoffLocation.longitude},${widget.dropoffLocation.latitude}?overview=full&geometries=geojson',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final coordinates = route['geometry']['coordinates'] as List;
          final List<LatLng> routePoints = coordinates.map((c) => LatLng(c[1] as double, c[0] as double)).toList();
          setState(() {
            _roadRoute = routePoints;
            _isLoadingRoute = false;
          });
          return;
        }
      }
      setState(() {
        _roadRoute = [widget.pickupLocation, widget.dropoffLocation];
        _isLoadingRoute = false;
      });
    } catch (e) {
      setState(() {
        _roadRoute = [widget.pickupLocation, widget.dropoffLocation];
        _isLoadingRoute = false;
      });
    }
  }

  String _formatPrice(int pricePerKm) {
    final total = (_distanceKm * pricePerKm).round();
    return 'TZS ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(color: AppColors.accentGreenLight, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 42),
            ),
            const SizedBox(height: 16),
            const Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Your ${_vehicleOptions[_selectedVehicleIndex]['name']} is on the way', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Text(_formatPrice(_vehicleOptions[_selectedVehicleIndex]['pricePerKm'] as int), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.serviceSendPackage)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Done')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                GoogleMapView(
                  height: double.infinity,
                  center: LatLng(
                    (widget.pickupLocation.latitude + widget.dropoffLocation.latitude) / 2,
                    (widget.pickupLocation.longitude + widget.dropoffLocation.longitude) / 2,
                  ),
                  zoom: 13.0,
                  markers: [
                    MapMarkerHelper.buildMarker(
                      point: widget.pickupLocation, label: 'Pickup',
                      color: AppColors.serviceSendPackage, icon: Icons.my_location, size: 30,
                    ),
                    MapMarkerHelper.buildDestinationMarker(
                      point: widget.dropoffLocation, label: 'Drop-off',
                    ),
                  ],
                  polylines: [
                    if (_isLoadingRoute)
                      MapRouteHelper.buildRoute(
                        points: [widget.pickupLocation, widget.dropoffLocation],
                        color: AppColors.serviceSendPackage.withValues(alpha: 0.5),
                        strokeWidth: 4,
                      )
                    else if (_roadRoute.isNotEmpty)
                      MapRouteHelper.buildRoute(
                        points: _roadRoute,
                        color: AppColors.serviceSendPackage,
                        strokeWidth: 4,
                      )
                    else
                      MapRouteHelper.buildRoute(
                        points: [widget.pickupLocation, widget.dropoffLocation],
                        color: AppColors.serviceSendPackage,
                        strokeWidth: 4,
                      ),
                  ],
                  initialTileType: _mapType,
                  showToggleButton: true,
                  showZoomControls: false,
                  onTileTypeChanged: (type) => setState(() => _mapType = type),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8, left: 16,
                  child: SafeArea(
                    child: Material(
                      elevation: 3, borderRadius: BorderRadius.circular(12), color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 60, left: 16, right: 16,
                  child: Material(
                    elevation: 3, borderRadius: BorderRadius.circular(14), color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.serviceSendPackage.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.route_rounded, size: 18, color: AppColors.serviceSendPackage),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${_truncateAddr(widget.pickupAddress)} → ${_truncateAddr(widget.dropoffAddress)}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text('${_distanceKm.toStringAsFixed(1)} km • Choose your ride',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(width: 36, height: 5, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, size: 16, color: AppColors.serviceSendPackage),
                        const SizedBox(width: 6),
                        Text('Choose a vehicle (${_vehicleOptions.length} options)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                        const Spacer(),
                        Text('${_distanceKm.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.serviceSendPackage)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: _vehicleOptions.length,
                      itemBuilder: (context, index) {
                        final vehicle = _vehicleOptions[index];
                        return _buildVehicleOption(vehicle, index == _selectedVehicleIndex, index);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_vehicleOptions[_selectedVehicleIndex]['name'] as String,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(_formatPrice(_vehicleOptions[_selectedVehicleIndex]['pricePerKm'] as int),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.serviceSendPackage)),
                                    const SizedBox(width: 6),
                                    Text('(${_vehicleOptions[_selectedVehicleIndex]['pricePerKm']} TZS/km)', style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                                    const SizedBox(width: 8),
                                    Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textLight)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 3),
                                    Text(_vehicleOptions[_selectedVehicleIndex]['eta'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _confirmBooking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.serviceSendPackage,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Book', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _truncateAddr(String addr) => addr.length > 22 ? '${addr.substring(0, 20)}...' : addr;

  Widget _buildVehicleOption(Map<String, dynamic> vehicle, bool isSelected, int index) {
    final vehicleIcon = vehicle['icon'] as IconData;
    final vehicleColor = vehicle['color'] as Color;
    final iconBg = vehicle['iconBg'] as Color;
    final pricePerKm = vehicle['pricePerKm'] as int;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicleIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? vehicleColor.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? vehicleColor : AppColors.border.withValues(alpha: 0.5), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(vehicleIcon, color: vehicleColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(vehicle['name'] as String, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6)),
                        child: Text(vehicle['type'] as String, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(vehicle['description'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text(vehicle['maxWeight'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text(vehicle['eta'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_formatPrice(pricePerKm), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? vehicleColor : AppColors.textPrimary)),
                Text('$pricePerKm TZS/km', style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                const SizedBox(height: 4),
                Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? vehicleColor : AppColors.border),
                  child: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


