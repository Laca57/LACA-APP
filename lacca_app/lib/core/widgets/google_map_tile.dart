import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';

/// Enum for map tile types
enum MapTileType {
  standard, // Road map
  satellite, // Satellite + roads
}

/// A reusable Google Maps tile widget with road and satellite view support.
class GoogleMapView extends StatefulWidget {
  final double height;
  final double? width;
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final List<Polygon> polygons;
  final MapTileType initialTileType;
  final bool showToggleButton;
  final bool showZoomControls;
  final EdgeInsetsGeometry? padding;
  final Function(MapTileType)? onTileTypeChanged;
  final Function(TapPosition, LatLng)? onMapTapped;
  final bool interactive;
  final bool showMyLocationButton;
  final VoidCallback? onMyLocationPressed;

  const GoogleMapView({
    super.key,
    this.height = 200,
    this.width,
    this.center = const LatLng(-6.7924, 39.2083), // Dar es Salaam
    this.zoom = 12.0,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.initialTileType = MapTileType.standard,
    this.showToggleButton = true,
    this.showZoomControls = false,
    this.padding,
    this.onTileTypeChanged,
    this.onMapTapped,
    this.interactive = true,
    this.showMyLocationButton = false,
    this.onMyLocationPressed,
  });


  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late MapTileType _currentTileType;
  final MapController _mapController = MapController();
  LatLng _lastCenter = const LatLng(-6.7924, 39.2083);

  // Google Maps tile URLs
  static const String _roadTileUrl =
      'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
  static const String _satelliteTileUrl =
      'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}';

  @override
  void initState() {
    super.initState();
    _currentTileType = widget.initialTileType;
    _lastCenter = widget.center;
  }

  @override
  void didUpdateWidget(GoogleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the center changes (e.g. user's real GPS location arrives),
    // animate the map to the new center.
    if (widget.center != _lastCenter) {
      _lastCenter = widget.center;
      _mapController.move(widget.center, widget.zoom);
    }
  }

  void _toggleTileType() {
    setState(() {
      _currentTileType = _currentTileType == MapTileType.standard
          ? MapTileType.satellite
          : MapTileType.standard;
      widget.onTileTypeChanged?.call(_currentTileType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          // Map layer
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.center,
                initialZoom: widget.zoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onTap: widget.onMapTapped,
              ),
              children: [
                // Tile layer
                TileLayer(
                  urlTemplate: _currentTileType == MapTileType.standard
                      ? _roadTileUrl
                      : _satelliteTileUrl,
                  userAgentPackageName: 'com.laca.app',
                  maxZoom: 20,
                  minZoom: 4,
                ),
                // Polygon layer
                if (widget.polygons.isNotEmpty)
                  PolygonLayer(polygons: widget.polygons),
                // Polyline layer
                if (widget.polylines.isNotEmpty)
                  PolylineLayer(polylines: widget.polylines),
                // Marker layer
                if (widget.markers.isNotEmpty)
                  MarkerLayer(markers: widget.markers),
              ],
            ),
          ),

          // Map type toggle button
          if (widget.showToggleButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 12,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _toggleTileType,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _currentTileType == MapTileType.standard
                              ? Icons.satellite_alt_outlined
                              : Icons.map_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _currentTileType == MapTileType.standard
                              ? 'Satellite'
                              : 'Road',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Zoom controls
          if (widget.showZoomControls)
            Positioned(
              right: 12,
              bottom: 80,
              child: Column(
                children: [
                  _buildZoomButton(Icons.add, () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  }),
                  const SizedBox(height: 4),
                  _buildZoomButton(Icons.remove, () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  }),
                ],
              ),
            ),

          // My-location button (re-centers the map on user)
          if (widget.showMyLocationButton)
            Positioned(
              right: 12,
              bottom: 24,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                color: AppColors.serviceSendPackage,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: widget.onMyLocationPressed,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.serviceSendPackage,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.my_location, size: 22, color: Colors.white),
                  ),
                ),
              ),
            ),

          // Location indicator
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.serviceTrack,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dar es Salaam',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
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


  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Helper to create a styled marker
class MapMarkerHelper {
  static Marker buildMarker({
    required LatLng point,
    required String label,
    Color color = AppColors.primary,
    IconData icon = Icons.location_on,
    double size = 40,
  }) {
    return Marker(
      point: point,
      width: size + 20,
      height: size + 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Icon(icon, color: color, size: size),
        ],
      ),
    );
  }

  static Marker buildVehicleMarker({
    required LatLng point,
    required String plate,
    Color color = AppColors.serviceTrack,
    String status = 'Active',
  }) {
    return Marker(
      point: point,
      width: 80,
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.directions_car, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  plate,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Icon(Icons.near_me, color: color, size: 28),
        ],
      ),
    );
  }

  static Marker buildDestinationMarker({
    required LatLng point,
    required String label,
  }) {
    return Marker(
      point: point,
      width: 60,
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Icon(Icons.flag, color: AppColors.error, size: 28),
        ],
      ),
    );
  }
}

/// Helper to create route polylines
class MapRouteHelper {
  static Polyline buildRoute({
    required List<LatLng> points,
    Color color = AppColors.primary,
    double strokeWidth = 4.0,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
      borderColor: Colors.white,
      borderStrokeWidth: 1,
    );
  }

  static Polyline buildDashedRoute({
    required List<LatLng> points,
    Color color = AppColors.textLight,
    double strokeWidth = 3.0,
  }) {
    return Polyline(
      points: points,
      color: color.withValues(alpha: 0.5),
      strokeWidth: strokeWidth,
      borderColor: Colors.white,
      borderStrokeWidth: 0.5,
    );
  }
}