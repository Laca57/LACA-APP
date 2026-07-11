import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/google_map_tile.dart';

// ============================================================
// SCREEN 1 - My Vehicles Fleet List (myvehiclescreen1)
// ============================================================
class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  List<Map<String, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _vehicles = _buildDefaultFleet();
  }

  List<Map<String, dynamic>> _buildDefaultFleet() {
    return [
      {
        'name': 'Toyota Hilux',
        'plate': 'TBC 1234',
        'year': '2019',
        'color': const Color(0xFF1E88E5),
        'status': 'Active',
        'statusColor': AppColors.success,
        'type': 'Pickup',
        'fuelLevel': 0.75,
        'mileage': '45,230 km',
        'location': 'Dar es Salaam',
        'engineTemp': '89°C',
        'lastService': '2 weeks ago',
        'health': {
          'engine': 85,
          'brakes': 70,
          'tyres': 60,
          'battery': 90,
          'oil': 75,
          'transmission': 88,
          'suspension': 65,
        },
      },
      {
        'name': 'Nissan NV350',
        'plate': 'TBC 5678',
        'year': '2020',
        'color': const Color(0xFF43A047),
        'status': 'In Transit',
        'statusColor': AppColors.warning,
        'type': 'Minibus',
        'fuelLevel': 0.45,
        'mileage': '32,100 km',
        'location': 'Morogoro',
        'engineTemp': '92°C',
        'lastService': '1 month ago',
        'health': {
          'engine': 72,
          'brakes': 65,
          'tyres': 80,
          'battery': 85,
          'oil': 60,
          'transmission': 78,
          'suspension': 70,
        },
      },
      {
        'name': 'Isuzu FRR',
        'plate': 'TBC 9012',
        'year': '2018',
        'color': const Color(0xFFE53935),
        'status': 'Maintenance',
        'statusColor': AppColors.error,
        'type': 'Truck',
        'fuelLevel': 0.3,
        'mileage': '78,500 km',
        'location': 'Workshop',
        'engineTemp': '97°C',
        'lastService': '2 days ago',
        'health': {
          'engine': 45,
          'brakes': 55,
          'tyres': 40,
          'battery': 60,
          'oil': 35,
          'transmission': 50,
          'suspension': 30,
        },
      },
      {
        'name': 'Mitsubishi Canter',
        'plate': 'TBC 3456',
        'year': '2021',
        'color': const Color(0xFF9C27B0),
        'status': 'Active',
        'statusColor': AppColors.success,
        'type': 'Truck',
        'fuelLevel': 0.88,
        'mileage': '18,700 km',
        'location': 'Dar es Salaam',
        'engineTemp': '86°C',
        'lastService': '1 week ago',
        'health': {
          'engine': 92,
          'brakes': 88,
          'tyres': 95,
          'battery': 98,
          'oil': 90,
          'transmission': 85,
          'suspension': 88,
        },
      },
      {
        'name': 'Toyota Hiace',
        'plate': 'TBC 7890',
        'year': '2022',
        'color': const Color(0xFF2196F3),
        'status': 'Active',
        'statusColor': AppColors.success,
        'type': 'Van',
        'fuelLevel': 0.62,
        'mileage': '12,400 km',
        'location': 'Dar es Salaam',
        'engineTemp': '88°C',
        'lastService': '3 weeks ago',
        'health': {
          'engine': 95,
          'brakes': 90,
          'tyres': 92,
          'battery': 96,
          'oil': 88,
          'transmission': 93,
          'suspension': 90,
        },
      },
      {
        'name': 'Scania R460',
        'plate': 'TBC 1111',
        'year': '2020',
        'color': const Color(0xFFE91E63),
        'status': 'In Transit',
        'statusColor': AppColors.warning,
        'type': 'Semi Trailer',
        'fuelLevel': 0.38,
        'mileage': '95,200 km',
        'location': 'Dodoma',
        'engineTemp': '94°C',
        'lastService': '1 week ago',
        'health': {
          'engine': 68,
          'brakes': 72,
          'tyres': 55,
          'battery': 82,
          'oil': 70,
          'transmission': 75,
          'suspension': 62,
        },
      },
      {
        'name': 'Foton Tunland',
        'plate': 'TBC 2222',
        'year': '2023',
        'color': const Color(0xFFFF9800),
        'status': 'Active',
        'statusColor': AppColors.success,
        'type': 'Pickup',
        'fuelLevel': 0.95,
        'mileage': '5,800 km',
        'location': 'Dar es Salaam',
        'engineTemp': '84°C',
        'lastService': 'Just serviced',
        'health': {
          'engine': 98,
          'brakes': 95,
          'tyres': 97,
          'battery': 99,
          'oil': 96,
          'transmission': 94,
          'suspension': 95,
        },
      },
      {
        'name': 'Isuzu Elf NQR',
        'plate': 'TBC 3333',
        'year': '2017',
        'color': const Color(0xFF795548),
        'status': 'Maintenance',
        'statusColor': AppColors.error,
        'type': 'Truck',
        'fuelLevel': 0.15,
        'mileage': '112,300 km',
        'location': 'Workshop',
        'engineTemp': '99°C',
        'lastService': 'Overdue',
        'health': {
          'engine': 38,
          'brakes': 42,
          'tyres': 25,
          'battery': 45,
          'oil': 30,
          'transmission': 40,
          'suspension': 35,
        },
      },
    ];
  }

  void _showAddVehicleDialog() {
    final nameCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    String selectedType = 'Pickup';
    final types = ['Pickup', 'Minibus', 'Van', 'Truck', 'Semi Trailer'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register Vehicle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: plateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Plate Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: yearCtrl,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => selectedType = v ?? 'Pickup',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          PrimaryButton(
            text: 'Add Vehicle',
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && plateCtrl.text.isNotEmpty) {
                setState(() {
                  _vehicles.insert(0, {
                    'name': nameCtrl.text,
                    'plate': plateCtrl.text.toUpperCase(),
                    'year': yearCtrl.text,
                    'color': AppColors.primary,
                    'status': 'Active',
                    'statusColor': AppColors.success,
                    'type': selectedType,
                    'fuelLevel': 1.0,
                    'mileage': '0 km',
                    'location': 'Dar es Salaam',
                    'engineTemp': '--',
                    'lastService': 'Just added',
                    'health': {
                      'engine': 100,
                      'brakes': 100,
                      'tyres': 100,
                      'battery': 100,
                      'oil': 100,
                      'transmission': 100,
                      'suspension': 100,
                    },
                  });
                });
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteVehicle(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Vehicle'),
        content: Text('Remove ${_vehicles[index]['name']} (${_vehicles[index]['plate']}) from your fleet?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _vehicles.removeAt(index));
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _vehicles.where((v) => v['status'] == 'Active').length;
    final transitCount = _vehicles.where((v) => v['status'] == 'In Transit').length;
    final issuesCount = _vehicles.where((v) => v['status'] == 'Maintenance').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddVehicleDialog,
            tooltip: 'Register Vehicle',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkHeader, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Fleet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_vehicles.length} vehicles',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$activeCount active • $transitCount in transit • $issuesCount maintenance',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSummaryStat('Active', activeCount.toString(), AppColors.success),
                      const SizedBox(width: 24),
                      _buildSummaryStat('In Transit', transitCount.toString(), AppColors.warning),
                      const SizedBox(width: 24),
                      _buildSummaryStat('Issues', issuesCount.toString(), AppColors.error),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Favourite vehicles - horizontal scroll
                  const Text(
                    'Favourite Vehicles',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white60),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _vehicles.length < 5 ? _vehicles.length : 5,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final v = _vehicles[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VehicleDetailScreen(
                                  name: v['name'],
                                  plate: v['plate'],
                                  year: v['year'],
                                  color: v['color'],
                                  status: v['status'],
                                  statusColor: v['statusColor'],
                                  fuelLevel: (v['fuelLevel'] as double),
                                  mileage: v['mileage'],
                                  location: v['location'],
                                  engineTemp: v['engineTemp'],
                                  lastService: v['lastService'],
                                  type: v['type'],
                                  health: Map<String, int>.from(v['health'] as Map),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.directions_car, size: 16, color: v['color']),
                                const SizedBox(width: 6),
                                Text(
                                  v['plate'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Vehicle Cards
            ...List.generate(_vehicles.length, (i) {
              final v = _vehicles[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildVehicleCard(
                  context,
                  v['name'],
                  v['plate'],
                  v['year'],
                  v['color'],
                  v['status'],
                  v['statusColor'],
                  fuelLevel: (v['fuelLevel'] as double),
                  mileage: v['mileage'],
                  location: v['location'],
                  engineTemp: v['engineTemp'],
                  lastService: v['lastService'],
                  type: v['type'],
                  index: i,
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    String name,
    String plate,
    String year,
    Color color,
    String status,
    Color statusColor, {
    required double fuelLevel,
    required String mileage,
    required String location,
    required String engineTemp,
    required String lastService,
    required String type,
    required int index,
  }) {
    final health = _vehicles[index]['health'] as Map<String, dynamic>;
    final overallHealth = health.values.fold<int>(0, (sum, v) => sum + (v as int)) ~/ health.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(
              name: name,
              plate: plate,
              year: year,
              color: color,
              status: status,
              statusColor: statusColor,
              fuelLevel: fuelLevel,
              mileage: mileage,
              location: location,
              engineTemp: engineTemp,
              lastService: lastService,
              type: type,
              health: Map<String, int>.from(health),
              onDelete: () => _deleteVehicle(index),
              onEdit: () => _showEditVehicleSheet(index),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.directions_car, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        Text('$plate • $year • $type',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _deleteVehicle(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Overall health bar
            Row(
              children: [
                const Icon(Icons.favorite, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Health',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: overallHealth / 100,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overallHealth >= 70
                            ? AppColors.success
                            : overallHealth >= 45
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$overallHealth%',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            // Fuel gauge
            Row(
              children: [
                const Icon(Icons.local_gas_station,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                const Text('Fuel',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fuelLevel,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        fuelLevel > 0.7
                            ? AppColors.success
                            : fuelLevel > 0.3
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(fuelLevel * 100).toInt()}%',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.speed,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(mileage,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const Spacer(),
                const Icon(Icons.local_fire_department,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(engineTemp,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const Spacer(),
                const Icon(Icons.build,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(lastService,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(location,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditVehicleSheet(int index) {
    final v = _vehicles[index];
    final nameCtrl = TextEditingController(text: v['name']);
    final plateCtrl = TextEditingController(text: v['plate']);
    final yearCtrl = TextEditingController(text: v['year']);
    String selectedType = v['type'] ?? 'Pickup';
    final types = ['Pickup', 'Minibus', 'Van', 'Truck', 'Semi Trailer'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('Edit Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Vehicle Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: plateCtrl, decoration: const InputDecoration(labelText: 'Plate Number', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: yearCtrl, decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
              items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => selectedType = val ?? selectedType,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Save Changes',
              onPressed: () {
                setState(() {
                  _vehicles[index]['name'] = nameCtrl.text;
                  _vehicles[index]['plate'] = plateCtrl.text.toUpperCase();
                  _vehicles[index]['year'] = yearCtrl.text;
                  _vehicles[index]['type'] = selectedType;
                });
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 2 - Vehicle Detail / Comprehensive Condition Monitoring
// (Send Package style — full map + draggable bottom sheet)
// "View Live" updates the same map in-place with route + timeline
// ============================================================
class VehicleDetailScreen extends StatefulWidget {
  final String name;
  final String plate;
  final String year;
  final Color color;
  final String status;
  final Color statusColor;
  final double fuelLevel;
  final String mileage;
  final String location;
  final String engineTemp;
  final String lastService;
  final String type;
  final Map<String, int> health;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const VehicleDetailScreen({
    super.key,
    required this.name,
    required this.plate,
    required this.year,
    required this.color,
    required this.status,
    required this.statusColor,
    required this.fuelLevel,
    required this.mileage,
    required this.location,
    required this.engineTemp,
    required this.lastService,
    required this.type,
    required this.health,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool _isLiveView = false;
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();

  String get _name => widget.name;
  String get _plate => widget.plate;
  String get _year => widget.year;
  Color get _color => widget.color;
  Color get _statusColor => widget.statusColor;
  double get _fuelLevel => widget.fuelLevel;
  String get _mileage => widget.mileage;
  String get _location => widget.location;
  String get _engineTemp => widget.engineTemp;
  String get _lastService => widget.lastService;
  String get _type => widget.type;
  Map<String, int> get _health => widget.health;

  String get _destination {
    if (_location == 'Dar es Salaam') return 'Arusha';
    if (_location == 'Dodoma') return 'Dar es Salaam';
    return 'Arusha';
  }

  String get _distance {
    if (_location == 'Dar es Salaam' && _destination == 'Arusha') return '580 km';
    if (_location == 'Dodoma' && _destination == 'Dar es Salaam') return '460 km';
    return '520 km';
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    super.dispose();
  }

  void _toggleLiveView() {
    setState(() {
      _isLiveView = !_isLiveView;
    });
    if (_isLiveView) {
      _sheetCtrl.animateTo(0.18, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  LatLng _getLocationCoords(String loc) {
    switch (loc) {
      case 'Dar es Salaam': return const LatLng(-6.7924, 39.2083);
      case 'Morogoro': return const LatLng(-6.8270, 37.6667);
      case 'Workshop': return const LatLng(-6.8175, 39.2515);
      case 'Dodoma': return const LatLng(-6.1625, 35.7517);
      default: return const LatLng(-6.7924, 39.2083);
    }
  }

  LatLng _getDestinationCoords(String dest) {
    switch (dest) {
      case 'Arusha': return const LatLng(-3.3869, 36.6830);
      case 'Dar es Salaam': return const LatLng(-6.7924, 39.2083);
      default: return const LatLng(-3.3869, 36.6830);
    }
  }

  @override
  Widget build(BuildContext context) {
    final overallHealth = _health.values.fold<int>(0, (sum, v) => sum + v) ~/ _health.length;
    final healthColor = overallHealth >= 70 ? AppColors.success : overallHealth >= 45 ? AppColors.warning : AppColors.error;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Build markers
    final markers = <Marker>[
      MapMarkerHelper.buildVehicleMarker(
        point: _getLocationCoords(_location),
        plate: _plate,
        color: _statusColor,
      ),
    ];
    List<Polyline> polylines = [];
    if (_isLiveView) {
      markers.add(
        MapMarkerHelper.buildDestinationMarker(
          point: _getDestinationCoords(_destination),
          label: _destination,
        ),
      );
      polylines.add(
        MapRouteHelper.buildRoute(
          points: [
            _getLocationCoords(_location),
            const LatLng(-5.1000, 37.7500),
            _getDestinationCoords(_destination),
          ],
          color: AppColors.serviceTrack,
          strokeWidth: 4,
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
              center: _getLocationCoords(_location),
              zoom: _isLiveView ? 8.0 : 12.0,
              markers: markers,
              polylines: polylines,
              showToggleButton: true,
              showZoomControls: true,
            ),
          ),

          // ---- Live Tracking badge (only in live view) ----
          if (_isLiveView)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Live Tracking',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ---- Back button ----
          if (!_isLiveView)
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
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ),
          if (!_isLiveView)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 12,
              child: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') widget.onEdit?.call();
                  if (v == 'delete') widget.onDelete?.call();
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                offset: const Offset(0, 48),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Remove', style: TextStyle(color: AppColors.error))])),
                ],
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.more_vert, size: 20, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ),

          // ---- Vehicle status pill ----
          Positioned(
            top: MediaQuery.of(context).padding.top + (_isLiveView ? 50 : 56),
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car, color: _color, size: 18),
                          Text(_type, style: TextStyle(fontSize: 7, color: _color)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('$_plate • $_year', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (_isLiveView)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('In Transit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.warning)),
                          const SizedBox(height: 2),
                          Text('ETA: 45 min', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      )
                    else
                      SizedBox(
                        width: 44, height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 44, height: 44,
                              child: CircularProgressIndicator(
                                value: overallHealth / 100,
                                strokeWidth: 4,
                                backgroundColor: AppColors.border,
                                valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                              ),
                            ),
                            Text('$overallHealth%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: healthColor)),
                          ],
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
            initialChildSize: 0.35,
            minChildSize: 0.12,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.12, 0.35, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4))],
                ),
                child: Stack(
                  children: [
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

                        // ---- Quick stats row ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(child: _buildQuickStat('Mileage', _mileage, Icons.speed)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildQuickStat('Engine', _engineTemp, Icons.local_fire_department)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildQuickStat('Fuel', '${(_fuelLevel * 100).toInt()}%', Icons.local_gas_station)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ---- Live view: Route info + Timeline ----
                        if (_isLiveView) ...[
                          // Route card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.tour, size: 16, color: AppColors.serviceTrack),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '$_location → $_destination',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  Text(_distance, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Timeline
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Recent Activity',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTimelineItem(Icons.check_circle, AppColors.success, _location, 'Current location', true),
                          _buildTimelineItem(Icons.location_on, AppColors.info, _getLastStop(_location), '30 min ago', false),
                          _buildTimelineItem(Icons.location_on, AppColors.textLight, _getPrevStop(_location), '1 hour ago', false),
                          const SizedBox(height: 16),

                          // ---- action: Stop Live View ----
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _toggleLiveView,
                                icon: const Icon(Icons.visibility_off, size: 18),
                                label: const Text('Stop Live View', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // ---- Normal view: Location row + View Live ----
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: _statusColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _location,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _toggleLiveView,
                                  icon: const Icon(Icons.fullscreen, size: 16),
                                  label: const Text('View Live'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ===== COMPREHENSIVE VEHICLE HEALTH MONITORING =====
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Vehicle Condition Monitoring',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 8),

                          _buildHealthSection(context, 'Engine System', Icons.engineering, AppColors.info, [
                            _HealthMetric(label: 'Engine Health', value: _health['engine']!, icon: Icons.precision_manufacturing),
                            _HealthMetric(label: 'Oil Pressure', value: _oilPressureFromHealth(_health['engine']!), icon: Icons.opacity),
                            _HealthMetric(label: 'Coolant Temp', value: _coolantFromEngineTemp(_engineTemp), icon: Icons.ac_unit),
                            _HealthMetric(label: 'Heat Level', value: _heatLevelFromEngineTemp(_engineTemp), icon: Icons.local_fire_department),
                          ]),
                          _buildHealthSection(context, 'Fuel System', Icons.local_gas_station, AppColors.warning, [
                            _HealthMetric(label: 'Fuel Level', value: (_fuelLevel * 100).toInt(), icon: Icons.speed),
                            _HealthMetric(label: 'Fuel Efficiency', value: _fuelEfficiency(_health['engine']!), icon: Icons.trending_down),
                            _HealthMetric(label: 'Est. Range', value: _rangeFromFuel(_fuelLevel), icon: Icons.route),
                          ]),
                          _buildHealthSection(context, 'Tyres / Wheels', Icons.tire_repair, AppColors.success, [
                            _HealthMetric(label: 'Overall Tyre Condition', value: _health['tyres']!, icon: Icons.radar),
                            _HealthMetric(label: 'Front Left', value: _tyreMetric(_health['tyres']!, 0), icon: Icons.arrow_back),
                            _HealthMetric(label: 'Front Right', value: _tyreMetric(_health['tyres']!, 1), icon: Icons.arrow_forward),
                            _HealthMetric(label: 'Rear Left', value: _tyreMetric(_health['tyres']!, 2), icon: Icons.arrow_back),
                            _HealthMetric(label: 'Rear Right', value: _tyreMetric(_health['tyres']!, 3), icon: Icons.arrow_forward),
                          ]),
                          _buildHealthSection(context, 'Brake System', Icons.car_repair, AppColors.error, [
                            _HealthMetric(label: 'Brake Pad Wear', value: _health['brakes']!, icon: Icons.handyman),
                            _HealthMetric(label: 'Brake Fluid Level', value: _brakeFluidFromHealth(_health['brakes']!), icon: Icons.water_drop),
                            _HealthMetric(label: 'ABS Status', value: _absFromBrakes(_health['brakes']!), icon: Icons.warning_amber),
                          ]),
                          _buildHealthSection(context, 'Electrical System', Icons.electrical_services, const Color(0xFF9C27B0), [
                            _HealthMetric(label: 'Battery Charge', value: _health['battery']!, icon: Icons.battery_std),
                            _HealthMetric(label: 'Alternator Output', value: _alternatorFromBattery(_health['battery']!), icon: Icons.bolt),
                            _HealthMetric(label: 'Voltage', value: _voltageFromBattery(_health['battery']!), icon: Icons.flash_on),
                          ]),
                          _buildHealthSection(context, 'Transmission', Icons.settings, AppColors.serviceTrack, [
                            _HealthMetric(label: 'Gearbox Health', value: _health['transmission']!, icon: Icons.settings),
                            _HealthMetric(label: 'Fluid Temp', value: _transmissionTemp(_health['transmission']!), icon: Icons.thermostat),
                            _HealthMetric(label: 'Clutch Wear', value: _clutchFromTransmission(_health['transmission']!), icon: Icons.view_carousel),
                          ]),
                          _buildHealthSection(context, 'Suspension & Chassis', Icons.miscellaneous_services, AppColors.textSecondary, [
                            _HealthMetric(label: 'Suspension Health', value: _health['suspension']!, icon: Icons.compress),
                            _HealthMetric(label: 'Shock Absorbers', value: _shockFromSuspension(_health['suspension']!), icon: Icons.vertical_align_center),
                            _HealthMetric(label: 'Steering Alignment', value: _steeringFromSuspension(_health['suspension']!), icon: Icons.roundabout_left),
                          ]),

                          const SizedBox(height: 16),

                          // Oil Change & Service reminder
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreenLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.build_circle, color: AppColors.secondary, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Last Service', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                      Text(_lastService, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _showScheduleServiceSheet(context),
                                  child: const Text('Schedule'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Action buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Start Engine',
                                    icon: Icons.power_settings_new,
                                    height: 48,
                                    onPressed: () => _showEngineStartDialog(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showServiceHistoryDialog(context),
                                    icon: const Icon(Icons.history, size: 18),
                                    label: const Text('History'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      minimumSize: const Size(0, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),

                    // ---- Fixed bottom button ----
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _toggleLiveView,
                            icon: Icon(_isLiveView ? Icons.visibility_off : Icons.navigation, size: 18),
                            label: Text(
                              _isLiveView ? 'Stop Live View' : 'View Live',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLiveView ? AppColors.error : AppColors.primary,
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

  String _getLastStop(String loc) {
    if (loc == 'Dar es Salaam') return 'Chalinze';
    if (loc == 'Dodoma') return 'Manyoni';
    return 'Chalinze';
  }

  String _getPrevStop(String loc) {
    if (loc == 'Dar es Salaam') return 'Morogoro';
    if (loc == 'Dodoma') return 'Singida';
    return 'Morogoro';
  }

  Widget _buildTimelineItem(IconData icon, Color color, String loc, String time, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc, style: TextStyle(fontSize: 14, fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal, color: AppColors.textPrimary)),
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
            ),
        ],
      ),
    );
  }

  // ===== DERIVED METRICS =====
  int _oilPressureFromHealth(int engine) => (engine * 0.95).round().clamp(20, 100);
  int _coolantFromEngineTemp(String temp) {
    final t = int.tryParse(temp.replaceAll('°C', '')) ?? 90;
    if (t <= 88) return 90;
    if (t <= 95) return 65;
    return 35;
  }
  int _heatLevelFromEngineTemp(String temp) {
    final t = int.tryParse(temp.replaceAll('°C', '')) ?? 90;
    if (t <= 85) return 20;
    if (t <= 92) return 50;
    if (t <= 97) return 75;
    return 95;
  }
  int _fuelEfficiency(int engine) => ((engine * 0.85) + 10).round().clamp(10, 100);
  int _rangeFromFuel(double fuel) => (fuel * 100).round();
  int _tyreMetric(int overall, int pos) {
    final offsets = [5, -3, 2, -5];
    return (overall + offsets[pos % offsets.length]).clamp(10, 100);
  }
  int _brakeFluidFromHealth(int brakes) => (brakes * 0.9 + 8).round().clamp(10, 100);
  int _absFromBrakes(int brakes) => brakes >= 40 ? (brakes - 10).clamp(10, 100) : brakes;
  int _alternatorFromBattery(int battery) => (battery * 0.9).round().clamp(10, 100);
  int _voltageFromBattery(int battery) {
    if (battery >= 85) return 95;
    if (battery >= 60) return 75;
    return 50;
  }
  int _transmissionTemp(int trans) {
    if (trans >= 80) return 25;
    if (trans >= 55) return 55;
    return 85;
  }
  int _clutchFromTransmission(int trans) => (trans * 0.85).round().clamp(10, 100);
  int _shockFromSuspension(int susp) => (susp * 0.9).round().clamp(10, 100);
  int _steeringFromSuspension(int susp) => (susp * 0.85 + 5).round().clamp(10, 100);

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildHealthSection(BuildContext context, String title, IconData icon, Color sectionColor, List<_HealthMetric> metrics) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: sectionColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: sectionColor),
                  const SizedBox(width: 8),
                  Text(title,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: sectionColor)),
                ],
              ),
            ),
            // Metrics
            ...metrics.map((m) => _buildMetricRow(m)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(_HealthMetric metric) {
    final color = metric.value >= 70 ? AppColors.success : metric.value >= 45 ? AppColors.warning : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Icon(metric.icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 130,
            child: Text(metric.label,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: metric.value / 100,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              '${metric.value}%',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleServiceSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Schedule Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Service Notes',
                hintText: 'e.g. Oil change, brake inspection...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Preferred Date',
                hintText: 'Select date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Submit Request',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showEngineStartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start Engine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.power_settings_new, size: 48, color: AppColors.success),
            const SizedBox(height: 12),
            const Text('Remote engine start command sent.'),
            const SizedBox(height: 4),
            Text('${widget.name} • ${widget.plate}', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showServiceHistoryDialog(BuildContext context) {
    final history = [
      {'date': '2025-06-28', 'desc': 'Oil change & filter replacement', 'cost': 'TZS 180,000'},
      {'date': '2025-05-15', 'desc': 'Brake pad replacement (front)', 'cost': 'TZS 250,000'},
      {'date': '2025-04-02', 'desc': 'Tyre rotation & wheel alignment', 'cost': 'TZS 120,000'},
      {'date': '2025-02-10', 'desc': 'Full engine diagnostic', 'cost': 'TZS 350,000'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Service History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: history.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (_, i) {
              final h = history[i];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.build_circle, color: AppColors.secondary),
                title: Text(h['desc']!, style: const TextStyle(fontSize: 13)),
                subtitle: Text('${h['date']} • ${h['cost']}', style: const TextStyle(fontSize: 11)),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

// Helper data class for health metrics
class _HealthMetric {
  final String label;
  final int value;
  final IconData icon;
  const _HealthMetric({required this.label, required this.value, required this.icon});
}

// ============================================================
// SCREEN 3 - Vehicle Tracking / Location History (myvehiclescreen3)
// ============================================================
class VehicleTrackingScreen extends StatelessWidget {
  final String name;
  final String plate;
  final String location;
  final String type;

  const VehicleTrackingScreen({
    super.key,
    required this.name,
    required this.plate,
    required this.location,
    this.type = 'Vehicle',
  });

  @override
  Widget build(BuildContext context) {
    final destination = location == 'Dar es Salaam' ? 'Arusha' : 'Dar es Salaam';
    final origin = location;

    return Scaffold(
      appBar: AppBar(
        title: Text('$name - Location'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Interactive Google Maps taking full remaining space
          Expanded(
            child: Stack(
              children: [
                GoogleMapView(
                  height: double.infinity,
                  center: _getLocationCoords(location),
                  zoom: 14.0,
                  markers: [
                    MapMarkerHelper.buildVehicleMarker(
                      point: _getLocationCoords(location),
                      plate: plate,
                      color: AppColors.warning,
                    ),
                    MapMarkerHelper.buildDestinationMarker(
                      point: _getDestinationCoords(destination),
                      label: destination,
                    ),
                  ],
                  polylines: [
                    MapRouteHelper.buildRoute(
                      points: [
                        _getLocationCoords(location),
                        _getViaPoint(origin, destination),
                        _getDestinationCoords(destination),
                      ],
                      color: AppColors.serviceTrack,
                      strokeWidth: 4,
                    ),
                  ],
                  initialTileType: MapTileType.standard,
                  showToggleButton: true,
                  showZoomControls: true,
                ),
                // Map toolbar overlay
                Positioned(
                  top: 12,
                  left: 12,
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Live Tracking',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
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

          // Bottom sheet - vehicle info & timeline
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Vehicle info
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.directions_car, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('$plate • $type',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('In Transit',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.warning)),
                          const SizedBox(height: 2),
                          Text('ETA: 45 min',
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Route info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.tour, size: 16, color: AppColors.serviceTrack),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$origin → $destination',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                          ),
                        ),
                        Text(
                          _getDistance(origin, destination),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Recent locations timeline
                  const Text('Recent Activity',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _buildTimelineItem(Icons.check_circle, AppColors.success, location, 'Current location', true),
                  _buildTimelineItem(Icons.location_on, AppColors.info, _getLastStop(location), '30 min ago', false),
                  _buildTimelineItem(Icons.location_on, AppColors.textLight, _getPrevStop(location), '1 hour ago', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng _getLocationCoords(String loc) {
    switch (loc) {
      case 'Dar es Salaam': return const LatLng(-6.7924, 39.2083);
      case 'Morogoro': return const LatLng(-6.8270, 37.6667);
      case 'Workshop': return const LatLng(-6.8175, 39.2515);
      case 'Dodoma': return const LatLng(-6.1625, 35.7517);
      default: return const LatLng(-6.7924, 39.2083);
    }
  }

  LatLng _getDestinationCoords(String dest) {
    switch (dest) {
      case 'Arusha': return const LatLng(-3.3869, 36.6830);
      case 'Dar es Salaam': return const LatLng(-6.7924, 39.2083);
      case 'Mwanza': return const LatLng(-2.5164, 32.9175);
      default: return const LatLng(-3.3869, 36.6830);
    }
  }

  LatLng _getViaPoint(String origin, String dest) {
    if (origin == 'Dar es Salaam' && dest == 'Arusha') return const LatLng(-5.1000, 37.7500);
    if (origin == 'Dodoma' && dest == 'Dar es Salaam') return const LatLng(-6.5000, 37.5000);
    return const LatLng(-5.1000, 37.7500);
  }

  String _getDistance(String origin, String dest) {
    if (origin == 'Dar es Salaam' && dest == 'Arusha') return '580 km';
    if (origin == 'Dodoma' && dest == 'Dar es Salaam') return '460 km';
    return '520 km';
  }

  String _getLastStop(String loc) {
    if (loc == 'Dar es Salaam') return 'Chalinze';
    if (loc == 'Dodoma') return 'Manyoni';
    return 'Chalinze';
  }

  String _getPrevStop(String loc) {
    if (loc == 'Dar es Salaam') return 'Morogoro';
    if (loc == 'Dodoma') return 'Singida';
    return 'Morogoro';
  }

  Widget _buildTimelineItem(IconData icon, Color color, String loc, String time, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc,
                    style: TextStyle(fontSize: 14, fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal, color: AppColors.textPrimary)),
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('LIVE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
            ),
        ],
      ),
    );
  }
}
