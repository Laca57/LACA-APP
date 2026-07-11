import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/google_map_tile.dart';

enum TripState { finding, found, arriving }

class TripTrackingScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final List<LatLng> routePoints;
  final String vehicleName;
  final IconData vehicleIcon;
  final Color vehicleColor;
  final String totalPrice;

  const TripTrackingScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.routePoints,
    required this.vehicleName,
    required this.vehicleIcon,
    required this.vehicleColor,
    required this.totalPrice,
  });

  @override
  State<TripTrackingScreen> createState() => _TripTrackingScreenState();
}

class _TripTrackingScreenState extends State<TripTrackingScreen>
    with SingleTickerProviderStateMixin {
  TripState _tripState = TripState.finding;
  LatLng _vehiclePosition = const LatLng(-6.7924, 39.2083);
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  Timer? _stateTimer;
  Timer? _moveTimer;
  int _moveStep = 0;
  List<LatLng> _approachPath = [];

  static const List<Map<String, String>> _mockDrivers = [
    {'name': 'Juma Salum', 'rating': '4.9', 'rides': '2,341', 'plate': 'T 123 BOD'},
    {'name': 'Amina Mohamed', 'rating': '4.8', 'rides': '1,872', 'plate': 'T 456 BAJ'},
    {'name': 'Hamza Juma', 'rating': '4.7', 'rides': '3,104', 'plate': 'T 789 CAR'},
  ];

  @override
  void initState() {
    super.initState();
    _vehiclePosition = widget.pickupLocation;

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _generateApproachPath();
    _runStateSequence();
  }

  void _generateApproachPath() {
    final pickup = widget.pickupLocation;
    final nearby = LatLng(
      pickup.latitude + (Random().nextDouble() - 0.5) * 0.01,
      pickup.longitude + (Random().nextDouble() - 0.5) * 0.01,
    );
    final steps = 20;
    _approachPath = List.generate(steps, (i) {
      final t = (i + 1) / steps;
      return LatLng(
        nearby.latitude + (pickup.latitude - nearby.latitude) * t,
        nearby.longitude + (pickup.longitude - nearby.longitude) * t,
      );
    });
  }

  void _runStateSequence() {
    _stateTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _tripState = TripState.found);
      _startVehicleMovement();

      _stateTimer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() => _tripState = TripState.arriving);
      });
    });
  }

  void _startVehicleMovement() {
    _moveStep = 0;
    _moveTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted || _moveStep >= _approachPath.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _vehiclePosition = _approachPath[_moveStep];
        _moveStep++;
      });
    });
  }

  @override
  void dispose() {
    _stateTimer?.cancel();
    _moveTimer?.cancel();
    _pulseCtrl.dispose();
    _sheetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      MapMarkerHelper.buildMarker(
        point: widget.pickupLocation,
        label: 'Pickup',
        color: AppColors.serviceSendPackage,
        icon: Icons.my_location,
        size: 28,
      ),
      MapMarkerHelper.buildDestinationMarker(
        point: widget.dropoffLocation,
        label: 'Drop-off',
      ),
      Marker(
        point: _vehiclePosition,
        width: 50,
        height: 50,
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (context, child) {
            final scale = _tripState == TripState.finding ? _pulseAnim.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.vehicleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: widget.vehicleColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  widget.vehicleIcon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            );
          },
        ),
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
          Positioned.fill(
            child: GoogleMapView(
              height: double.infinity,
              center: _vehiclePosition,
              zoom: 15.0,
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
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
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

          // Top status card
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(14),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildTopCard(),
              ),
            ),
          ),

          // Bottom sheet
          DraggableScrollableSheet(
            controller: _sheetCtrl,
            initialChildSize: 0.32,
            minChildSize: 0.12,
            maxChildSize: 0.45,
            snap: true,
            snapSizes: const [0.12, 0.32, 0.45],
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _buildBottomContent(),
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

  Widget _buildTopCard() {
    switch (_tripState) {
      case TripState.finding:
        return _infoPill(
          key: const ValueKey('finding'),
          icon: Icons.radar,
          iconColor: AppColors.warning,
          text: 'Finding your driver...',
          trailing: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.warning,
            ),
          ),
        );
      case TripState.found:
        return _infoPill(
          key: const ValueKey('found'),
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          text: 'Driver found — heading to pickup',
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.textLight,
          ),
        );
      case TripState.arriving:
        final eta = '${2 + Random().nextInt(5)} min';
        return _infoPill(
          key: const ValueKey('arriving'),
          icon: Icons.near_me,
          iconColor: AppColors.serviceSendPackage,
          text: 'Driver arriving in $eta',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.serviceSendPackage.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              eta,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.serviceSendPackage,
              ),
            ),
          ),
        );
    }
  }

  Widget _infoPill({
    required Key key,
    required IconData icon,
    required Color iconColor,
    required String text,
    required Widget trailing,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildBottomContent() {
    switch (_tripState) {
      case TripState.finding:
        return _buildFindingContent();
      case TripState.found:
        return _buildFoundContent();
      case TripState.arriving:
        return _buildArrivingContent();
    }
  }

  Widget _buildFindingContent() {
    return Padding(
      key: const ValueKey('finding_bottom'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: widget.vehicleColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnim.value,
                  child: Icon(
                    widget.vehicleIcon,
                    size: 34,
                    color: widget.vehicleColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Searching for nearby drivers...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Looking for available ${widget.vehicleName} drivers in your area',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            backgroundColor: AppColors.divider,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFoundContent() {
    final driver = _mockDrivers[Random().nextInt(_mockDrivers.length)];
    return Padding(
      key: const ValueKey('found_bottom'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.vehicleColor, widget.vehicleColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    driver['name']!.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppColors.warning),
                        const SizedBox(width: 3),
                        Text(
                          '${driver['rating']} • ${driver['rides']} rides',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            driver['plate']!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: AppColors.success,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message, size: 18),
                  label: const Text('Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.vehicleColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildArrivingContent() {
    final driver = _mockDrivers[Random().nextInt(_mockDrivers.length)];
    final minLeft = 2 + Random().nextInt(5);
    return Padding(
      key: const ValueKey('arriving_bottom'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.vehicleColor, widget.vehicleColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    driver['name']!.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.serviceSendPackage.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppColors.serviceSendPackage,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '$minLeft min',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.serviceSendPackage,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${widget.totalPrice}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: AppColors.success,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.serviceSendPackage.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.serviceSendPackage.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.serviceSendPackage,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arriving at pickup',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.pickupAddress,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
