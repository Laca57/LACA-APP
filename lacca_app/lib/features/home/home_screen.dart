import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../agro/agro_business_screen.dart';
import 'send_package_screen.dart';
import 'car_import_screen.dart';
import 'track_shipment_screen.dart';
import 'cargo_clearing_screen.dart';
import 'schedule_transport_screen.dart';
import '../auth/inspector_registration_screen.dart';
import '../auth/driver_registration_screen.dart';
import '../auth/winga_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Togabe School Ad Banner ----
                _TogabeSchoolAd(),
                // ---- Enhanced Header with deeper gradient ----
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF06172A), // Deep navy
                    AppColors.darkHeader,
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.w(context, 20),
                    Responsive.h(context, 16),
                    Responsive.w(context, 20),
                    Responsive.h(context, 24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Personalized greeting with avatar ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: Responsive.w(context, 48),
                                  height: Responsive.w(context, 48),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.accent, AppColors.secondary],
                                    ),
                                    borderRadius: BorderRadius.circular(Responsive.w(context, 14)),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'AH',
                                      style: TextStyle(
                                        fontSize: Responsive.sp(context, 18),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.w(context, 12)),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Good morning,',
                                        style: TextStyle(
                                          fontSize: Responsive.sp(context, 12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Amina Hassan',
                                          style: TextStyle(
                                            fontSize: Responsive.sp(context, 18),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Menu button
                          PopupMenuButton<String>(
                            icon: Container(
                              width: Responsive.w(context, 44),
                              height: Responsive.w(context, 44),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
                              ),
                              child: Icon(Icons.menu, color: Colors.white, size: Responsive.w(context, 22)),
                            ),
                            onSelected: (value) {
                              if (value == 'inspector') Navigator.push(context, MaterialPageRoute(builder: (_) => const InspectorRegistrationScreen()));
                              else if (value == 'driver') Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverRegistrationScreen()));
                              else if (value == 'winga') Navigator.push(context, MaterialPageRoute(builder: (_) => const WingaRegistrationScreen()));
                              else if (value == 'package_driver') Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverRegistrationScreen()));
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'inspector', child: Row(children: [Icon(Icons.verified, color: AppColors.serviceCargo), const SizedBox(width: 12), const Text('Become Inspector')])),
                              PopupMenuItem(value: 'driver', child: Row(children: [Icon(Icons.directions_car, color: AppColors.serviceSendPackage), const SizedBox(width: 12), const Text('Become IT Driver')])),
                              PopupMenuItem(value: 'package_driver', child: Row(children: [Icon(Icons.local_shipping, color: AppColors.serviceAgro), const SizedBox(width: 12), const Text('Become Package Driver')])),
                              PopupMenuItem(value: 'winga', child: Row(children: [Icon(Icons.storefront, color: AppColors.accent), const SizedBox(width: 12), const Text('Become a Winga')])),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: Responsive.h(context, 12)),

                      // ---- Activity snippet (Personalization) ----
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 14), vertical: Responsive.h(context, 8)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: Responsive.w(context, 16), color: Colors.white.withValues(alpha: 0.8)),
                            SizedBox(width: Responsive.w(context, 8)),
                            Expanded(
                              child: Text(
                                'You have a package arriving today',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 12),
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: Responsive.h(context, 14)),

                      // ---- Enhanced Stats Cards with color tints & chevrons ----
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Active',
                              '3',
                              Icons.shopping_bag_outlined,
                              AppColors.serviceCargo,
                              () {},
                            ),
                          ),
                          SizedBox(width: Responsive.w(context, 8)),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Processing',
                              '2',
                              Icons.access_time,
                              AppColors.warning,
                              () {},
                            ),
                          ),
                          SizedBox(width: Responsive.w(context, 8)),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Delivered',
                              '12',
                              Icons.check_circle_outline,
                              AppColors.success,
                              () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: Responsive.h(context, 16)),

            // ---- Services section with tighter spacing ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our Services',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 13),
                      color: AppColors.serviceSendPackage,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(context, 10)),

            // ---- Services Grid with subtle borders ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16)),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.15,
                children: [
                  _EnhancedServiceCard(
                    title: 'Send Package',
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.serviceSendPackage,
                    hint: 'Fast Deliveries • 24h',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SendPackageScreen())),
                  ),
                  _EnhancedServiceCard(
                    title: 'Schedule Transport',
                    icon: Icons.fire_truck_outlined,
                    color: const Color(0xFF795548),
                    hint: 'Large Cargo',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleTransportScreen())),
                  ),
                  _EnhancedServiceCard(
                    title: 'Import Car',
                    icon: Icons.directions_car_outlined,
                    color: AppColors.serviceImportCar,
                    hint: 'Drive Your Dream',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CarImportScreen())),
                  ),
                  _EnhancedServiceCard(
                    title: 'Cargo Clearing',
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.serviceCargo,
                    hint: 'Clearance & Forwarding',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CargoClearingScreen())),
                  ),
                  _EnhancedServiceCard(
                    title: 'Agro Business',
                    icon: Icons.agriculture_outlined,
                    color: AppColors.serviceAgro,
                    hint: 'Grow & Harvest',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgroBusinessScreen())),
                  ),
                  _EnhancedServiceCard(
                    title: 'Track Shipment',
                    icon: Icons.near_me_outlined,
                    color: AppColors.serviceTrack,
                    hint: 'Real-time View',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackShipmentScreen())),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 16)),

            // ---- Recent Activity ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 13),
                      color: AppColors.serviceSendPackage,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildActivityItem(
              context,
              Icons.check_circle,
              AppColors.success,
              'Package Delivered',
              'Order #LCA-2024-8921 delivered',
              '2h ago',
            ),
            _buildActivityItem(
              context,
              Icons.local_shipping,
              AppColors.info,
              'In Transit',
              'Cargo #FRT-5211 on the way',
              '5h ago',
            ),
            _buildActivityItem(
              context,
              Icons.receipt,
              AppColors.warning,
              'New Booking',
              'Freight #FRT-5212 confirmed',
              '1d ago',
            ),
            _buildActivityItem(
              context,
              Icons.agriculture,
              AppColors.serviceAgro,
              'Quote Requested',
              'Urea Fertilizer sent to supplier',
              '2d ago',
            ),
            SizedBox(height: Responsive.h(context, 20)),
          ],
        ),
      ),
      ),
    );
  }

  // ---- Enhanced stat card with color tint, larger number, chevron ----
  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 12),
          vertical: Responsive.h(context, 14),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(Responsive.w(context, 14)),
          border: Border.all(
            color: color.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: Responsive.w(context, 18)),
                Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.5), size: Responsive.w(context, 16)),
              ],
            ),
            SizedBox(height: Responsive.h(context, 4)),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 24),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(context, 2)),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Activity item with subtle styling ----
  Widget _buildActivityItem(BuildContext context, IconData icon, Color color, String title, String subtitle, String time) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 16),
        vertical: Responsive.h(context, 3),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 12),
        vertical: Responsive.h(context, 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.w(context, 36),
            height: Responsive.w(context, 36),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.w(context, 10)),
            ),
            child: Icon(icon, color: color, size: Responsive.w(context, 18)),
          ),
          SizedBox(width: Responsive.w(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(context, 2)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: Responsive.w(context, 6)),
          Icon(
            Icons.chevron_right,
            size: Responsive.w(context, 18),
            color: AppColors.textLight,
          ),
        ],
      ),
    );
  }
}

// ---- Togabe Pre & Primary School Ad Banner ----
class _TogabeSchoolAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/togabe.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOGABE PRE AND PRIMARY SCHOOL',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Responsive.h(context, 2)),
                  Row(
                    children: [
                      Icon(Icons.school, size: 12, color: Colors.white.withValues(alpha: 0.8)),
                      SizedBox(width: Responsive.w(context, 4)),
                      Text(
                        'Quality Education • Enroll Today',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 11),
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Ad',
                  style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Enhanced ServiceCard with press animation ----
class _EnhancedServiceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? hint;
  final VoidCallback onTap;

  const _EnhancedServiceCard({
    required this.title,
    required this.icon,
    required this.color,
    this.hint,
    required this.onTap,
  });

  @override
  State<_EnhancedServiceCard> createState() => _EnhancedServiceCardState();
}

class _EnhancedServiceCardState extends State<_EnhancedServiceCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(Responsive.w(context, 10)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Responsive.w(context, 14)),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.06),
                blurRadius: Responsive.w(context, 6),
                offset: const Offset(0, 2),
              ),
            ],
          ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Responsive.w(context, 44),
                    height: Responsive.w(context, 44),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Responsive.w(context, 12)),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: Responsive.w(context, 22)),
                  ),
                  SizedBox(height: Responsive.h(context, 6)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.sp(context, 11),
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  if (widget.hint != null) ...[
                    SizedBox(height: Responsive.h(context, 2)),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.hint!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}