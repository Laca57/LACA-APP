import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle 1 - Active
            _buildVehicleCard(
              'Toyota Hilux',
              'TBC 1234',
              '2019',
              const Color(0xFF1E88E5),
              'Active',
              AppColors.success,
              fuelLevel: 0.75,
              mileage: '45,230 km',
            ),
            const SizedBox(height: 12),
            // Vehicle 2
            _buildVehicleCard(
              'Nissan NV350',
              'TBC 5678',
              '2020',
              const Color(0xFF43A047),
              'In Transit',
              AppColors.warning,
              fuelLevel: 0.45,
              mileage: '32,100 km',
            ),
            const SizedBox(height: 12),
            // Vehicle 3
            _buildVehicleCard(
              'Isuzu FRR',
              'TBC 9012',
              '2018',
              const Color(0xFFE53935),
              'Maintenance',
              AppColors.error,
              fuelLevel: 0.3,
              mileage: '78,500 km',
            ),
            const SizedBox(height: 20),
            // Quick Stats
            const Text(
              'Fleet Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFleetStatCard(
                    'Total',
                    '3',
                    Icons.directions_car,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFleetStatCard(
                    'Active',
                    '1',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFleetStatCard(
                    'Maintenance',
                    '1',
                    Icons.build,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Vehicles health
            const Text(
              'Vehicle Health',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildHealthCard('Engine', 85, AppColors.success),
            _buildHealthCard('Brakes', 70, AppColors.warning),
            _buildHealthCard('Tyres', 60, AppColors.warning),
            _buildHealthCard('Battery', 90, AppColors.success),
            _buildHealthCard('Oil', 75, AppColors.success),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    String name,
    String plate,
    String year,
    Color color,
    String status,
    Color statusColor, {
    required double fuelLevel,
    required String mileage,
  }) {
    return Container(
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
                      Text('$plate • $year',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
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
            ],
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.speed, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(mileage,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text('Dar es Salaam',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFleetStatCard(
      String label, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String part, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(part,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text('$percentage%',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ),
        ],
      ),
    );
  }
}