import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/service_card.dart';
import '../agro/agro_business_screen.dart';
import '../freight/freight_booking_screen.dart';
import 'send_package_screen.dart';
import 'car_import_screen.dart';
import 'track_shipment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkHeader, AppColors.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Good morning,',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const Text(
                                'Amina Hassan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Active',
                              '3',
                              Icons.shopping_bag_outlined,
                              AppColors.serviceCargo,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              'Delivered',
                              '12',
                              Icons.check_circle_outline,
                              AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              'Pending',
                              '2',
                              Icons.hourglass_empty,
                              AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Our Services section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Our Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  ServiceCard(
                    title: 'Send\nPackage',
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.serviceSendPackage,
                    onTap: () => _navigate(context, const SendPackageScreen()),
                  ),
                  ServiceCard(
                    title: 'Import\nCar',
                    icon: Icons.directions_car_outlined,
                    color: AppColors.serviceImportCar,
                    onTap: () => _navigate(context, const CarImportScreen()),
                  ),
                  ServiceCard(
                    title: 'Cargo\nClearing',
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.serviceCargo,
                    onTap: () => _navigate(context, const CargoClearingScreen()),
                  ),
                  ServiceCard(
                    title: 'Agro\nBusiness',
                    icon: Icons.agriculture_outlined,
                    color: AppColors.serviceAgro,
                    onTap: () => _navigate(context, const AgroBusinessScreen()),
                  ),
                  ServiceCard(
                    title: 'Freight\nBooking',
                    icon: Icons.flight_takeoff_outlined,
                    color: AppColors.serviceFreight,
                    onTap: () => _navigate(context, const FreightBookingScreen()),
                  ),
                  ServiceCard(
                    title: 'Track\nShipment',
                    icon: Icons.near_me_outlined,
                    color: AppColors.serviceTrack,
                    onTap: () => _navigate(context, const TrackShipmentScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Recent Activity
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              Icons.check_circle,
              AppColors.success,
              'Package Delivered',
              'Order #LCA-2024-8921 was delivered successfully',
              '2 hours ago',
            ),
            _buildActivityItem(
              Icons.local_shipping,
              AppColors.info,
              'In Transit',
              'Your cargo shipment #FRT-5211 is on the way',
              '5 hours ago',
            ),
            _buildActivityItem(
              Icons.receipt,
              AppColors.warning,
              'New Booking',
              'Freight booking #FRT-5212 has been confirmed',
              '1 day ago',
            ),
            _buildActivityItem(
              Icons.agriculture,
              AppColors.serviceAgro,
              'Quote Requested',
              'Urea Fertilizer quote has been sent to supplier',
              '2 days ago',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, Color color, String title,
      String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

// Cargo Clearing placeholder
class CargoClearingScreen extends StatelessWidget {
  const CargoClearingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargo Clearing'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const CargoClearingBody(),
    );
  }
}

class CargoClearingBody extends StatelessWidget {
  const CargoClearingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const FreightBookingScreen();
  }
}