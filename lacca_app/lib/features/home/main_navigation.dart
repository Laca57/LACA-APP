import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'home_screen.dart';
import '../profile/account_screen.dart';
import '../orders/orders_screen.dart';
import '../inspectors/inspectors_screen.dart';
import '../cargo_inspection/cargo_inspection_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OrdersScreen(),
    const InspectorsScreen(),
    const CargoInspectionScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isTabletOrWider = Responsive.isTablet(context) || Responsive.isDesktop(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTabletOrWider ? 16 : 8,
              isTabletOrWider ? 8 : 6,
              isTabletOrWider ? 16 : 8,
              isTabletOrWider ? 8 : 6,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTabletOrWider ? 8 : 4,
                vertical: isTabletOrWider ? 6 : 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(isTabletOrWider ? 24 : 20),
              ),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: _buildNavItem(
                      context,
                      isTabletOrWider: isTabletOrWider,
                      icon: _icons[index],
                      activeIcon: _activeIcons[index],
                      label: _labels[index],
                      isActive: _currentIndex == index,
                      onTap: () => setState(() => _currentIndex = index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required bool isTabletOrWider,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final iconSize = isTabletOrWider ? 24.0 : Responsive.w(context, 20);
    final fontSize = isTabletOrWider ? 12.0 : Responsive.sp(context, 11);
    final gap = isTabletOrWider ? 8.0 : Responsive.w(context, 6);
    final hp = isTabletOrWider ? 14.0 : Responsive.w(context, 10);
    final vp = isTabletOrWider ? 10.0 : Responsive.h(context, 8);
    final radius = isTabletOrWider ? 16.0 : 14.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? hp + 4 : hp,
          vertical: vp,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: iconSize,
              color: isActive ? Colors.white : AppColors.textLight,
            ),
            SizedBox(height: gap),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.verified_outlined,
    Icons.inventory_2_outlined,
    Icons.person_outline,
  ];

  static const List<IconData> _activeIcons = [
    Icons.home,
    Icons.receipt_long,
    Icons.verified,
    Icons.inventory_2,
    Icons.person,
  ];

  static const List<String> _labels = [
    'Home',
    'Orders',
    'Inspectors',
    'Cargo Insp.',
    'Account',
  ];
}
