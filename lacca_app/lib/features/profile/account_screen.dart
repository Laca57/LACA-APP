import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/ad_banner.dart';
import '../../core/utils/responsive.dart';
import '../inspectors/inspectors_screen.dart';
import '../home/schedule_transport_screen.dart';
import '../auth/inspector_registration_screen.dart';
import '../auth/driver_registration_screen.dart';
import '../auth/winga_registration_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ---- Ad Banner at the top ----
            const AdBanner(
              message: '⚡ Upgrade to LACA Pro for unlimited benefits!',
            ),
            // ---- Glassmorphism Header ----
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF06172A),
                    AppColors.darkHeader,
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
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
                    Responsive.w(context, 24),
                    Responsive.h(context, 20),
                    Responsive.w(context, 24),
                    Responsive.h(context, 32),
                  ),
                  child: Column(
                    children: [
                      // Avatar with neumorphism
                      NeumorphicPressEffect(
                        onTap: () {},
                        backgroundColor: AppColors.darkHeader,
                        child: Container(
                          width: Responsive.w(context, 88),
                          height: Responsive.w(context, 88),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                            borderRadius: BorderRadius.circular(Responsive.w(context, 24)),
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'AH',
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 30),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 14)),
                      Text(
                        'Amina Hassan',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 4)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 14, color: AppColors.accent),
                            const SizedBox(width: 6),
                            Text(
                              'Verified Member',
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 12),
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 16)),
                      Row(
                        children: [
                          _statBox(context, '12', 'Orders', Icons.local_shipping),
                          SizedBox(width: Responsive.w(context, 10)),
                          _statBox(context, '4.9', 'Rating', Icons.star),
                          SizedBox(width: Responsive.w(context, 10)),
                          _statBox(context, '8', 'Reviews', Icons.reviews),
                        ],
                      ),
                    ],
                  ),
                ),
            ),

            // ---- Account Settings with Neumorphism cards ----
            _sectionHeader(context, 'ACCOUNT SETTINGS'),
            _menuTile(context, Icons.person_outline, 'Edit Profile', 'Update your personal info'),
            _menuTile(context, Icons.receipt_long_outlined, 'My Orders', 'View order history'),
            _menuTile(context, Icons.payments_outlined, 'Payment Methods', 'Manage cards & mobile money'),
            _menuTile(context, Icons.notifications_outlined, 'Notifications', 'Alert settings'),

            // ---- Business Tools with Bento-style cards ----
            _sectionHeader(context, 'BUSINESS TOOLS'),
            _menuTile(context, Icons.verified_outlined, 'Become Inspector', 'Inspect goods for international buyers', badge: 'New'),
            _menuTile(context, Icons.local_shipping_outlined, 'Become IT Driver', 'Deliver packages and earn'),
            _menuTile(context, Icons.storefront_outlined, 'Become a Winga', 'Sell via social media from Kariakoo'),

            // ---- Support ----
            _sectionHeader(context, 'SUPPORT'),
            _menuTile(context, Icons.help_outline, 'Help Center', 'FAQs and support'),
            _menuTile(context, Icons.shield_outlined, 'Privacy Policy', 'How we protect your data'),
            _menuTile(context, Icons.article_outlined, 'Terms & Conditions', 'App usage terms'),

            // ---- Logout with neumorphic effect ----
            _sectionHeader(context, ''),
            _menuTile(context, Icons.logout, 'Log Out', 'Sign out of your account', isDestructive: true),
            SizedBox(height: Responsive.h(context, 24)),
          ],
        ),
      ),
      ),
    );
  }

  Widget _statBox(BuildContext context, String value, String label, IconData icon) {
    return Expanded(
      child: NeumorphicPressEffect(
        onTap: () {},
        backgroundColor: AppColors.darkHeader,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 12)),
          decoration: DesignSystem.glassMorphism(
            backgroundColor: Colors.white,
            borderRadius: Responsive.w(context, 12),
            opacity: 0.15,
          ),
          child: Column(
            children: [
              Icon(icon, size: Responsive.w(context, 20), color: AppColors.accent),
              SizedBox(height: Responsive.h(context, 4)),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.w(context, 20),
        Responsive.h(context, 24),
        Responsive.w(context, 20),
        Responsive.h(context, 8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.sp(context, 12),
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, String subtitle, {bool isDestructive = false, String? badge}) {
    return NeumorphicPressEffect(
      onTap: () {
        if (title == 'Become Inspector') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const InspectorRegistrationScreen()));
        } else if (title == 'Become IT Driver') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverRegistrationScreen()));
        } else if (title == 'Become a Winga') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WingaRegistrationScreen()));
        }
      },
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 16),
          vertical: Responsive.h(context, 4),
        ),
        decoration: DesignSystem.bentoCard(
          borderRadius: Responsive.w(context, 14),
          borderColor: AppColors.border,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 16),
            vertical: Responsive.h(context, 2),
          ),
          leading: Container(
            width: Responsive.w(context, 42),
            height: Responsive.w(context, 42),
            decoration: DesignSystem.skeuomorphic(
              color: isDestructive ? AppColors.error : AppColors.primary,
              borderRadius: Responsive.w(context, 12),
              hasGradient: false,
              hasInnerShadow: true,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: Responsive.w(context, 22),
            ),
          ),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: Responsive.w(context, 8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 8),
                    vertical: Responsive.h(context, 2),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 10),
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.sp(context, 12),
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: AppColors.textLight,
            size: Responsive.w(context, 22),
          ),
        ),
      ),
    );
  }
}