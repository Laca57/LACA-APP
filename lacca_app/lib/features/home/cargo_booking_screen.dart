import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/google_map_tile.dart';
import '../../core/utils/responsive.dart';

class CargoBookingScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final double distanceKm;
  final String routeEta;
  final List<LatLng> routePoints;
  final String phone;
  final String vehicleType;

  const CargoBookingScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distanceKm,
    required this.routeEta,
    this.routePoints = const [],
    this.phone = '',
    this.vehicleType = 'Box Truck',
  });

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  int _selectedIndex = -1;
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 9, minute: 0);

  bool get _isBoxTruck => widget.vehicleType == 'Box Truck';

  static final List<_AvailableTruck> _boxTrucks = [
    _AvailableTruck(
      plateNumber: 'T 123 ABC',
      driverName: 'Juma Bakari',
      phone: '0712 100 200',
      pricePerKm: 1500,
      capacity: '3,000 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'T 456 DEF',
      driverName: 'Mwanahamisi Salim',
      phone: '0713 300 400',
      pricePerKm: 1500,
      capacity: '3,000 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'T 789 GHI',
      driverName: 'Hamza Mushi',
      phone: '0714 500 600',
      pricePerKm: 1600,
      capacity: '3,500 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'T 321 JKL',
      driverName: 'Amina Khamis',
      phone: '0715 700 800',
      pricePerKm: 1400,
      capacity: '3,000 kg',
      isAvailable: false,
    ),
    _AvailableTruck(
      plateNumber: 'T 654 MNO',
      driverName: 'Rajab Omar',
      phone: '0716 900 000',
      pricePerKm: 1550,
      capacity: '3,000 kg',
      isAvailable: true,
    ),
  ];

  static final List<_AvailableTruck> _semiTrucks = [
    _AvailableTruck(
      plateNumber: 'ST 111 ZA',
      driverName: 'Hamisi Mwinyi',
      phone: '0717 100 200',
      pricePerKm: 2500,
      capacity: '10,000 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'ST 222 ZB',
      driverName: 'Rehema Juma',
      phone: '0718 300 400',
      pricePerKm: 2600,
      capacity: '12,000 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'ST 333 ZC',
      driverName: 'Salim Omar',
      phone: '0719 500 600',
      pricePerKm: 2400,
      capacity: '10,000 kg',
      isAvailable: true,
    ),
    _AvailableTruck(
      plateNumber: 'ST 444 ZD',
      driverName: 'Asha Mbarouk',
      phone: '0720 700 800',
      pricePerKm: 2700,
      capacity: '15,000 kg',
      isAvailable: false,
    ),
    _AvailableTruck(
      plateNumber: 'ST 555 ZE',
      driverName: 'Iddi Hassan',
      phone: '0721 900 000',
      pricePerKm: 2550,
      capacity: '10,000 kg',
      isAvailable: true,
    ),
  ];

  List<_AvailableTruck> get _trucks => _isBoxTruck ? _boxTrucks : _semiTrucks;

  Color get _accentColor => _isBoxTruck ? const Color(0xFF1565C0) : const Color(0xFFB71C1C);
  Color get _bgColor => _isBoxTruck ? const Color(0xFFE3F2FD) : const Color(0xFFFFEBEE);

  String get _stationName => _isBoxTruck ? 'Box Truck Station' : 'Semi Truck Station';

  _AvailableTruck? get _sel =>
      _selectedIndex >= 0 && _selectedIndex < _trucks.length ? _trucks[_selectedIndex] : null;

  String _fmt(double amt) {
    return 'TZS ${amt.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String get _totalPriceStr {
    if (_sel == null) return '';
    return _fmt(widget.distanceKm * _sel!.pricePerKm);
  }

  double get _totalPriceVal {
    if (_sel == null) return 0;
    return widget.distanceKm * _sel!.pricePerKm;
  }

  double get _advanceAmount => _totalPriceVal * 0.3;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (d != null) setState(() => _pickupDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _pickupTime);
    if (t != null) setState(() => _pickupTime = t);
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
      polylines.add(MapRouteHelper.buildRoute(
        points: widget.routePoints, color: AppColors.serviceSendPackage, strokeWidth: 5,
      ));
    }

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${_pickupDate.day} ${months[_pickupDate.month - 1]} ${_pickupDate.year}';
    final timeStr = '${_pickupTime.hour.toString().padLeft(2, '0')}:${_pickupTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMapView(
              key: ValueKey('cargo_${widget.pickupLocation.latitude.toStringAsFixed(4)}_${widget.pickupLocation.longitude.toStringAsFixed(4)}'),
              height: double.infinity, center: widget.pickupLocation, zoom: 13,
              markers: markers, polylines: polylines,
              showToggleButton: true, showZoomControls: true, showMyLocationButton: false,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8, left: 12,
            child: Material(elevation: 3, borderRadius: BorderRadius.circular(12), color: Colors.white,
              child: InkWell(borderRadius: BorderRadius.circular(12), onTap: () => Navigator.pop(context),
                child: Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary)))),
          ),
          DraggableScrollableSheet(
            controller: _sheetCtrl,
            initialChildSize: 0.50, minChildSize: 0.18, maxChildSize: 0.88,
            snap: true, snapSizes: const [0.18, 0.50, 0.88],
            builder: (context, sc) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4))],
              ),
              child: ListView(controller: sc, padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
                children: [
                  Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3))))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(
                    _isBoxTruck ? 'Available Box Trucks' : 'Available Semi Trucks',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                  const SizedBox(height: 4),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(
                    'Select a ${_isBoxTruck ? 'truck' : 'semi truck'} to transport your cargo',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                  const SizedBox(height: 14),

                  // Route summary
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        _dot(Icons.trip_origin, AppColors.serviceSendPackage, widget.pickupAddress),
                        Container(margin: const EdgeInsets.only(left: 6), width: 2, height: 10, color: AppColors.border),
                        _dot(Icons.flag, AppColors.error, widget.dropoffAddress),
                      ])),
                      const SizedBox(width: 10),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                        child: Column(children: [
                          FittedBox(fit: BoxFit.scaleDown,
                            child: Text('${widget.distanceKm.toStringAsFixed(1)} km',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                          FittedBox(fit: BoxFit.scaleDown,
                            child: Text(widget.routeEta, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))),
                        ])),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Date & Time picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Expanded(
                        child: _pickerCard(Icons.calendar_today, 'Pickup Date', dateStr, _pickDate),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _pickerCard(Icons.access_time, 'Pickup Time', timeStr, _pickTime),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Available trucks list
                  ...List.generate(_trucks.length, (i) {
                    return Padding(
                      padding: EdgeInsets.only(left: Responsive.w(context, 16), right: Responsive.w(context, 16), bottom: Responsive.h(context, 10)),
                      child: _buildTruckCard(context, i),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Request button (only shown when a truck is selected)
                  if (_sel != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 20)),
                      child: PrimaryButton(
                        text: 'Request ${_sel!.plateNumber} — $_totalPriceStr',
                        icon: Icons.arrow_forward,
                        onPressed: () => _showPaymentDialog(context),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickerCard(IconData icon, String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.serviceCargo),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
            const SizedBox(height: 2),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
              child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          ])),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
        ]),
      ),
    );
  }

  Widget _buildTruckCard(BuildContext context, int i) {
    final t = _trucks[i];
    final sel = i == _selectedIndex;

    return GestureDetector(
      onTap: t.isAvailable ? () => setState(() => _selectedIndex = i) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(Responsive.w(context, 12)),
        decoration: BoxDecoration(
          color: sel ? _accentColor.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
          border: Border.all(
            color: sel
                ? _accentColor
                : t.isAvailable
                    ? AppColors.border
                    : AppColors.error.withValues(alpha: 0.3),
            width: sel ? 2 : 1,
          ),
          boxShadow: sel
              ? [BoxShadow(color: _accentColor.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: sel
                  ? _accentColor
                  : t.isAvailable
                      ? _bgColor
                      : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: sel
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : Icon(
                    t.isAvailable ? Icons.local_shipping : Icons.block,
                    size: 24,
                    color: t.isAvailable ? _accentColor : AppColors.error,
                  ),
          ),
          SizedBox(width: Responsive.w(context, 10)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Flexible(
                child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                  child: Text(t.plateNumber,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        fontWeight: FontWeight.bold,
                      color: sel ? _accentColor : AppColors.textPrimary,
                    ))),
              ),
              SizedBox(width: Responsive.w(context, 4)),
              FittedBox(fit: BoxFit.scaleDown,
                child: Text(_fmt(widget.distanceKm * t.pricePerKm),
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.bold,
                      color: sel ? _accentColor : AppColors.textPrimary,
                    ))),
            ]),
            SizedBox(height: Responsive.h(context, 2)),
            Row(children: [
              Icon(Icons.person, size: 12, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Expanded(child: Text(t.driverName,
                  style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppColors.textSecondary),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
            SizedBox(height: Responsive.h(context, 3)),
            Wrap(spacing: 4, runSpacing: 2, children: [
              _chip(context, _accentColor, t.isAvailable ? 'Available' : 'Booked'),
              _chip(context, null, '${_fmt(t.pricePerKm)}/km'),
              _chip(context, null, t.capacity),
            ]),
          ])),
        ]),
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
      child: FittedBox(fit: BoxFit.scaleDown,
        child: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 9),
            fontWeight: color != null ? FontWeight.w500 : FontWeight.normal, color: color ?? AppColors.textSecondary))),
    );
  }

  Widget _dot(IconData icon, Color color, String addr) {
    return Row(children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 6),
      Expanded(child: Text(addr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
    ]);
  }

  // ============================================================
  // PAYMENT DIALOG (30% advance)
  // ============================================================

  void _showPaymentDialog(BuildContext context) {
    final t = _sel!;

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
                'Secure Your Booking',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Pay at least 30% to secure your space',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _paymentRow('Truck', t.plateNumber),
                    const SizedBox(height: 6),
                    _paymentRow('Driver', t.driverName),
                    const SizedBox(height: 6),
                    _paymentRow('Phone', widget.phone.isNotEmpty ? widget.phone : t.phone),
                    const Divider(height: 20),
                    _paymentRow('Total Transport Fee', _fmt(_totalPriceVal), isBold: true),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Advance (30%)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                          Text(
                            _fmt(_advanceAmount),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining ${_fmt(_totalPriceVal - _advanceAmount)} after delivery',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Pay ${_fmt(_advanceAmount)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.textPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONFIRMATION DIALOG
  // ============================================================

  void _showConfirmationDialog(BuildContext context) {
    final t = _sel!;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${_pickupDate.day} ${months[_pickupDate.month - 1]} ${_pickupDate.year}';

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
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, size: 44, color: AppColors.success),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your space on ${t.plateNumber} has been secured!',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please take your cargo to the $_stationName one day before $dateStr.',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
}

class _AvailableTruck {
  final String plateNumber;
  final String driverName;
  final String phone;
  final double pricePerKm;
  final String capacity;
  final bool isAvailable;

  const _AvailableTruck({
    required this.plateNumber,
    required this.driverName,
    required this.phone,
    required this.pricePerKm,
    required this.capacity,
    required this.isAvailable,
  });
}
