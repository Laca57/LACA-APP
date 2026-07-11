import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/google_map_tile.dart';
import 'booking_screen.dart';

class SendPackageScreen extends StatefulWidget {
  const SendPackageScreen({super.key});

  @override
  State<SendPackageScreen> createState() => _SendPackageScreenState();
}

class _SendPackageScreenState extends State<SendPackageScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();

  // ---- Location & Map State ----
  LatLng? _currentPosition;
  LatLng? _pickupPosition;
  String? _pickupName;
  LatLng? _destinationPosition;
  String? _destinationName;
  List<LatLng> _routePoints = [];
  double _routeDistanceKm = 0.0;
  String _routeEta = '';
  bool _isLocatingUser = true;
  bool _isLoadingRoute = false;
  String? _locationError;

  // ---- Destination Search State ----
  List<Map<String, dynamic>> _searchSuggestions = [];
  bool _isSearching = false;
  bool _showNoResults = false;
  String? _searchError;
  Timer? _debounceTimer;
  int _searchRequestId = 0;

  // ---- Pickup Search State ----
  List<Map<String, dynamic>> _pickupSuggestions = [];
  bool _isSearchingPickup = false;
  bool _showNoPickupResults = false;
  String? _pickupSearchError;
  Timer? _pickupDebounceTimer;
  int _pickupSearchRequestId = 0;

  // ---- History (hardcoded — simulates places the user once went) ----
  final List<Map<String, String>> _historyPlaces = [
    {
      'name': 'Kariakoo Market',
      'address': 'Uhuru Street, Ilala, Dar es Salaam',
      'date': '2 days ago',
    },
    {
      'name': 'Mlimani City Mall',
      'address': 'Sam Nujoma Road, Dar es Salaam',
      'date': '5 days ago',
    },
    {
      'name': 'Julius Nyerere Airport',
      'address': 'Terminal 3, Dar es Salaam',
      'date': '1 week ago',
    },
    {
      'name': 'Mwenge Woodcarvers',
      'address': 'Mwenge, Dar es Salaam',
      'date': '2 weeks ago',
    },
    {
      'name': 'Posta Mpya',
      'address': 'Sokoine Drive, Dar es Salaam',
      'date': '3 weeks ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _pickupController.addListener(_onPickupSearchChanged);
    _destinationController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _pickupDebounceTimer?.cancel();
    _pickupController.removeListener(_onPickupSearchChanged);
    _destinationController.removeListener(_onSearchChanged);
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    _searchFocusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOCATION
  // ============================================================
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocatingUser = true;
      _locationError = null;
    });

    try {
      // Check location service status
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
          _isLocatingUser = false;
          _fallbackToDar();
        });
        return;
      }

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied.';
            _isLocatingUser = false;
            _fallbackToDar();
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permission permanently denied.';
          _isLocatingUser = false;
          _fallbackToDar();
        });
        return;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLocatingUser = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationError = 'Could not get location.';
        _isLocatingUser = false;
        _fallbackToDar();
      });
    }
  }

  void _fallbackToDar() {
    _currentPosition = const LatLng(-6.7924, 39.2083);
  }

  void _navigateToMyLocation() {
    if (_currentPosition != null) {
      // Trigger a rebuild so the map re-centers on the current position.
      // We'll also close the sheet so the user can see the map.
      _sheetController.animateTo(
        0.15,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {});
    }
  }

  // ============================================================
  // NOMINATIM SEARCH
  // ============================================================
  void _onSearchChanged() {
    _debounceTimer?.cancel();
    final query = _destinationController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
        _isSearching = false;
        _showNoResults = false;
        _searchError = null;
      });
      return;
    }

    // Clear any stale error immediately when user starts typing again
    if (_searchError != null) {
      setState(() => _searchError = null);
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _searchPlace(query);
    });
  }

  Future<void> _searchPlace(String query) async {
    final int requestId = ++_searchRequestId;

    setState(() {
      _isSearching = true;
      _showNoResults = false;
      // Only clear error if it was a connectivity error; keep no-results messages ephemeral
      if (_searchError != null && _searchError!.contains('Check internet')) {
        _searchError = null;
      }
    });

    try {
      final encoded = Uri.encodeComponent('$query,Dar es Salaam,Tanzania');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encoded&format=jsonv2&limit=5&addressdetails=1',
      );

      // ignore: avoid_print
      print('🔍 Searching Nominatim: $url (request #$requestId)');

      final response = await http.get(
        url,
        headers: const {
          'User-Agent': 'LACAApp/1.0 (contact@laca.co.tz)',
          'Accept-Language': 'en',
        },
      ).timeout(const Duration(seconds: 12));

      // --- Discard stale responses from cancelled/older requests ---
      if (!mounted || requestId != _searchRequestId) return;

      // ignore: avoid_print
      print('📡 Nominatim response status: ${response.statusCode} (request #$requestId)');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          setState(() {
            _searchSuggestions = [];
            _isSearching = false;
            _showNoResults = true;
          });
          return;
        }

        setState(() {
          _searchSuggestions = data.map((item) {
            final name = (item['display_name'] as String?)?.split(',').first.trim() ?? 'Unknown';
            return {
              'name': name,
              'address': item['display_name'] as String? ?? '',
              'lat': double.tryParse(item['lat']?.toString() ?? '') ?? 0.0,
              'lon': double.tryParse(item['lon']?.toString() ?? '') ?? 0.0,
            };
          }).toList();
          _isSearching = false;
          _showNoResults = false;
          _searchError = null;
        });
      } else {
        setState(() {
          _isSearching = false;
          _searchError = 'Search service unavailable (${response.statusCode})';
        });
      }
    } catch (e) {
      // --- Discard if a newer request already superseded this one ---
      if (!mounted || requestId != _searchRequestId) return;

      // ignore: avoid_print
      print('❌ Nominatim exception for request #$requestId: $e');

      // Only show error if we haven't already shown results from a newer request
      setState(() {
        _isSearching = false;
        // Don't clear _searchSuggestions if we already have results
        if (_searchSuggestions.isEmpty) {
          _searchError = 'Could not connect to search service. Check internet.';
        } else {
          // If we already have valid results, just stop loading silently
          _searchError = null;
        }
      });
    }
  }

  // ============================================================
  // PICKUP SEARCH (NOMINATIM)
  // ============================================================
  void _onPickupSearchChanged() {
    _pickupDebounceTimer?.cancel();
    final query = _pickupController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _pickupSuggestions = [];
        _isSearchingPickup = false;
        _showNoPickupResults = false;
        _pickupSearchError = null;
      });
      return;
    }

    if (_pickupSearchError != null) {
      setState(() => _pickupSearchError = null);
    }

    _pickupDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _searchPickupPlace(query);
    });
  }

  Future<void> _searchPickupPlace(String query) async {
    final int requestId = ++_pickupSearchRequestId;

    setState(() {
      _isSearchingPickup = true;
      _showNoPickupResults = false;
      if (_pickupSearchError != null && _pickupSearchError!.contains('Check internet')) {
        _pickupSearchError = null;
      }
    });

    try {
      final encoded = Uri.encodeComponent('$query,Dar es Salaam,Tanzania');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encoded&format=jsonv2&limit=5&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: const {
          'User-Agent': 'LACAApp/1.0 (contact@laca.co.tz)',
          'Accept-Language': 'en',
        },
      ).timeout(const Duration(seconds: 12));

      if (!mounted || requestId != _pickupSearchRequestId) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          setState(() {
            _pickupSuggestions = [];
            _isSearchingPickup = false;
            _showNoPickupResults = true;
          });
          return;
        }

        setState(() {
          _pickupSuggestions = data.map((item) {
            final name = (item['display_name'] as String?)?.split(',').first.trim() ?? 'Unknown';
            return {
              'name': name,
              'address': item['display_name'] as String? ?? '',
              'lat': double.tryParse(item['lat']?.toString() ?? '') ?? 0.0,
              'lon': double.tryParse(item['lon']?.toString() ?? '') ?? 0.0,
            };
          }).toList();
          _isSearchingPickup = false;
          _showNoPickupResults = false;
          _pickupSearchError = null;
        });
      } else {
        setState(() {
          _isSearchingPickup = false;
          _pickupSearchError = 'Search service unavailable (${response.statusCode})';
        });
      }
    } catch (e) {
      if (!mounted || requestId != _pickupSearchRequestId) return;

      setState(() {
        _isSearchingPickup = false;
        if (_pickupSuggestions.isEmpty) {
          _pickupSearchError = 'Could not connect to search service. Check internet.';
        } else {
          _pickupSearchError = null;
        }
      });
    }
  }

  void _selectPickupLocation(String name, String address, double lat, double lon) {
    _pickupFocusNode.unfocus();
    _pickupController.text = address;
    setState(() {
      _pickupSuggestions = [];
      _pickupPosition = LatLng(lat, lon);
      _pickupName = name;
    });
    _fetchRoute();
  }

  void _resetPickupToCurrent() {
    _pickupController.clear();
    setState(() {
      _pickupPosition = null;
      _pickupName = null;
      _pickupSuggestions = [];
    });
    _fetchRoute();
  }

  LatLng get _effectivePickup => _pickupPosition ?? _currentPosition ?? const LatLng(-6.7924, 39.2083);

  // ============================================================
  // SELECT DESTINATION → FETCH ROUTE VIA OSRM
  // ============================================================
  Future<void> _selectDestination(String name, String address, double lat, double lon) async {
    _searchFocusNode.unfocus();
    _destinationController.text = address;
    setState(() {
      _searchSuggestions = [];
      _destinationPosition = LatLng(lat, lon);
      _destinationName = name;
    });

    // Collapse sheet so user sees the route on the map
    _sheetController.animateTo(
      0.15,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    await _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (_destinationPosition == null) return;

    final pickup = _effectivePickup;

    setState(() => _isLoadingRoute = true);

    try {
      final dropoff = _destinationPosition!;

      // OSRM expects lon,lat;lon,lat
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${pickup.longitude},${pickup.latitude};'
        '${dropoff.longitude},${dropoff.latitude}'
        '?overview=full&geometries=geojson&steps=false',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 12));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final distanceMeters = (route['distance'] ?? 0).toDouble();
          final durationSeconds = (route['duration'] ?? 0).toDouble();
          final coordinates = route['geometry']['coordinates'] as List;

          final List<LatLng> points = coordinates
              .map((c) => LatLng(c[1] as double, c[0] as double))
              .toList();

          final hours = (durationSeconds / 3600).floor();
          final mins = ((durationSeconds % 3600) / 60).round();

          setState(() {
            _routePoints = points;
            _routeDistanceKm = distanceMeters / 1000.0;
            _routeEta = hours > 0 ? '${hours}h ${mins}min' : '$mins min';
            _isLoadingRoute = false;
          });
          return;
        }
      }

      // Fallback: straight line
      _setFallbackStraightLine();
    } catch (e) {
      if (mounted) _setFallbackStraightLine();
    }
  }

  void _setFallbackStraightLine() {
    if (_destinationPosition == null) return;
    final pickup = _effectivePickup;
    setState(() {
      _routePoints = [pickup, _destinationPosition!];
      _routeDistanceKm = _haversineDistance(pickup, _destinationPosition!);
      final hours = (_routeDistanceKm / 40).floor(); // assume ~40 km/h avg
      final mins = ((_routeDistanceKm / 40 * 60) % 60).round();
      _routeEta = hours > 0 ? '${hours}h ${mins}min' : '$mins min';
      _isLoadingRoute = false;
    });
  }

  double _haversineDistance(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(a.latitude * pi / 180) *
            cos(b.latitude * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(h), sqrt(1 - h));
  }

  // ============================================================
  // SELECT PLACE FROM HISTORY / SAVED → GEOCODE VIA NOMINATIM
  // ============================================================
  Future<void> _selectFromAddress(String name, String address) async {
    _searchFocusNode.unfocus();
    _destinationController.text = address;

    // Try to geocode the address to get coordinates
    try {
      final encoded = Uri.encodeComponent('$address,Dar es Salaam,Tanzania');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encoded&format=jsonv2&limit=1',
      );
      final response = await http.get(
        url,
        headers: const {'User-Agent': 'LACAApp/1.0 (laca@example.com)'},
      ).timeout(const Duration(seconds: 6));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(data[0]['lon']?.toString() ?? '') ?? 0.0;
          if (lat != 0.0 && lon != 0.0) {
            setState(() {
              _destinationPosition = LatLng(lat, lon);
              _destinationName = name;
            });
            _sheetController.animateTo(
              0.15,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            await _fetchRoute();
            return;
          }
        }
      }
    } catch (_) {}

    // If geocoding fails, just set the address text
    setState(() {});
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Determine the map center
    final mapCenter = _currentPosition ?? const LatLng(-6.7924, 39.2083);

    // Build markers list
    final List<Marker> markers = [];
    markers.add(
      MapMarkerHelper.buildMarker(
        point: _effectivePickup,
        label: _pickupName ?? 'Pickup',
        color: AppColors.serviceSendPackage,
        icon: Icons.my_location,
        size: 30,
      ),
    );
    if (_destinationPosition != null) {
      markers.add(
        MapMarkerHelper.buildDestinationMarker(
          point: _destinationPosition!,
          label: _destinationName ?? 'Drop-off',
        ),
      );
    }

    // Build polylines
    final List<Polyline> polylines = [];
    if (_routePoints.isNotEmpty) {
      polylines.add(
        MapRouteHelper.buildRoute(
          points: _routePoints,
          color: AppColors.serviceSendPackage,
          strokeWidth: 5,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ---- Full-Screen Map ----
          // Key forces full rebuild when user location is acquired so the
          // map re-centers on the real GPS position (not Dar fallback).
          Positioned.fill(
            child: GoogleMapView(
              key: ValueKey(
                'send_map_${_currentPosition?.latitude.toStringAsFixed(6)}_${_currentPosition?.longitude.toStringAsFixed(6)}',
              ),
              height: double.infinity,
              center: mapCenter,
              zoom: 14.0,
              markers: markers,
              polylines: polylines,
              showToggleButton: true,
              showZoomControls: true,
              showMyLocationButton: true,
              onMyLocationPressed: _navigateToMyLocation,
            ),
          ),

          // ---- Location loading / error indicator ----
          if (_isLocatingUser)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16,
              right: 16,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Finding your location...',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_locationError != null && _currentPosition == null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16,
              right: 16,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ---- Route info pill (shown when a route is active) ----
          if (_routePoints.isNotEmpty && _routeDistanceKm > 0)
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
                          color: AppColors.serviceSendPackage.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.route,
                          color: AppColors.serviceSendPackage,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _destinationName ?? 'Destination',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_routeDistanceKm.toStringAsFixed(1)} km • $_routeEta',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.serviceSendPackage,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isLoadingRoute)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // ---- Back Button (top-left, over map) ----
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

          // ---- Draggable Scrollable Bottom Sheet ----
          DraggableScrollableSheet(
            controller: _sheetController,
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
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // ---- Scrollable content ----
                    ListView(
                      controller: scrollController,
                      padding: EdgeInsets.only(bottom: 80 + bottomPadding),
                      children: [
                        // ---- Drag Handle ----
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

                        // ---- Header ----
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Send Package',
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
                            'Set pickup & destination to get started',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ---- Pickup Location Field ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _pickupController,
                              focusNode: _pickupFocusNode,
                              decoration: InputDecoration(
                                hintText: _isLocatingUser ? 'Finding location...' : 'Pickup location',
                                hintStyle: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 15,
                                ),
                                prefixIcon: const Icon(
                                  Icons.trip_origin,
                                  color: AppColors.serviceAgro,
                                  size: 22,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_pickupPosition != null)
                                      IconButton(
                                        icon: const Icon(Icons.my_location, size: 18, color: AppColors.serviceSendPackage),
                                        onPressed: _resetPickupToCurrent,
                                      ),
                                    if (_pickupController.text.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textLight),
                                        onPressed: _resetPickupToCurrent,
                                      ),
                                  ],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                        // ---- Pickup search results ----
                        if (_isSearchingPickup)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                            child: Row(
                              children: [
                                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                                SizedBox(width: 12),
                                Text('Searching...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),

                        if (_pickupSearchError != null)
                          _buildErrorBanner(_pickupSearchError!),

                        if (_showNoPickupResults)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.search_off, size: 18, color: AppColors.textLight),
                                SizedBox(width: 10),
                                Text('No places found', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
                              ],
                            ),
                          ),

                        if (_pickupSuggestions.isNotEmpty)
                          ..._pickupSuggestions.map(
                            (suggestion) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildPickupSuggestion(
                                suggestion['name'] as String,
                                suggestion['address'] as String,
                                (suggestion['lat'] as num).toDouble(),
                                (suggestion['lon'] as num).toDouble(),
                              ),
                            ),
                          ),

                        if (_pickupSuggestions.isNotEmpty && _searchSuggestions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(color: AppColors.divider, height: 16),
                          ),

                        const SizedBox(height: 10),

                        // ---- Destination Field ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _destinationController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Where are you going?',
                                hintStyle: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 15,
                                ),
                                prefixIcon: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_destinationController.text.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textLight),
                                        onPressed: () {
                                          _destinationController.clear();
                                          setState(() {
                                            _destinationPosition = null;
                                            _destinationName = null;
                                            _routePoints = [];
                                            _routeDistanceKm = 0.0;
                                            _routeEta = '';
                                            _searchSuggestions = [];
                                          });
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.my_location, color: AppColors.serviceSendPackage, size: 22),
                                      onPressed: _navigateToMyLocation,
                                    ),
                                  ],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                        // ---- Destination search results ----
                        if (_isSearching)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                            child: Row(
                              children: [
                                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                                SizedBox(width: 12),
                                Text('Searching...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),

                        if (_searchError != null)
                          _buildErrorBanner(_searchError!),


                        if (_showNoResults)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.search_off, size: 18, color: AppColors.textLight),
                                SizedBox(width: 10),
                                Text(
                                  'No places found',
                                  style: TextStyle(fontSize: 13, color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ),

                        if (_searchSuggestions.isNotEmpty)
                          ..._searchSuggestions.map(
                            (suggestion) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildSearchSuggestion(
                                suggestion['name'] as String,
                                suggestion['address'] as String,
                                (suggestion['lat'] as num).toDouble(),
                                (suggestion['lon'] as num).toDouble(),
                              ),
                            ),
                          ),

                        // Divider before saved/history if suggestions are shown
                        if (_searchSuggestions.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(color: AppColors.divider, height: 24),
                          ),

                        const SizedBox(height: 8),

                        // ---- Saved Places ----
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Saved Places',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildPlaceCard(
                            Icons.home,
                            'Home',
                            '123 Mafinga Street, Dar es Salaam',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildPlaceCard(
                            Icons.work,
                            'Work',
                            '456 Samora Avenue, Dar es Salaam',
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ---- History Section ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'History',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._historyPlaces.map(
                          (place) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildHistoryItem(
                              place['name']!,
                              place['address']!,
                              place['date']!,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),

                    // ---- Fixed Continue Button at bottom ----
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
                        child: PrimaryButton(
                          text: 'Continue to Book',
                          icon: Icons.arrow_forward,
                          onPressed: _destinationPosition != null
                              ? () {
                                  final pickupAddr = _pickupName ??
                                      (_pickupController.text.isNotEmpty
                                          ? _pickupController.text
                                          : 'Current Location');
                                  final dropoffAddr = _destinationName ?? _destinationController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingScreen(
                                        pickupLocation: _effectivePickup,
                                        dropoffLocation: _destinationPosition!,
                                        pickupAddress: pickupAddr,
                                        dropoffAddress: dropoffAddr,
                                        distanceKm: _routeDistanceKm > 0
                                            ? _routeDistanceKm
                                            : _haversineDistance(
                                                _effectivePickup,
                                                _destinationPosition!,
                                              ),
                                        routeEta: _routeEta.isNotEmpty ? _routeEta : 'Calculating...',
                                        routePoints: _routePoints.isNotEmpty ? _routePoints : [],
                                      ),
                                    ),
                                  );
                                }
                              : null,
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

  // ============================================================
  // WIDGET BUILDERS
  // ============================================================

  // ---- Error Banner ----
  Widget _buildErrorBanner(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, size: 16, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Pickup Search Suggestion ----
  Widget _buildPickupSuggestion(String name, String address, double lat, double lon) {
    return GestureDetector(
      onTap: () => _selectPickupLocation(name, address, lat, lon),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.serviceAgro.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.serviceAgro.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.serviceAgro.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.trip_origin, color: AppColors.serviceAgro, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Destination Search Suggestion ----
  Widget _buildSearchSuggestion(String name, String address, double lat, double lon) {
    return GestureDetector(
      onTap: () => _selectDestination(name, address, lat, lon),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.serviceSendPackage.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.serviceSendPackage.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.serviceSendPackage.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on, color: AppColors.serviceSendPackage, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Saved Place Card ----
  Widget _buildPlaceCard(IconData icon, String title, String address) {
    return GestureDetector(
      onTap: () => _selectFromAddress(title, address),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  // ---- History Item ----
  Widget _buildHistoryItem(String name, String address, String date) {
    return GestureDetector(
      onTap: () => _selectFromAddress(name, address),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.textLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.history,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
