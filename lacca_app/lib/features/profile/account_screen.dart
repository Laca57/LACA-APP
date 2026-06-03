import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'AH',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Amina Hassan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+255 712 345 678',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'amina.hassan@email.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu Items
            _buildMenuItem(Icons.person_outline, 'My Profile', () {}),
            _buildMenuItem(Icons.assignment_outlined, 'My Orders', () {}),
            _buildMenuItem(Icons.payments_outlined, 'Payment Methods', () {}),
            _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
            const SizedBox(height: 8),
            _buildMenuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
            _buildMenuItem(Icons.support_agent, 'Customer Support', () {}),
            _buildMenuItem(Icons.info_outline, 'About LACA', () {}),
            const SizedBox(height: 8),
            _buildMenuItem(Icons.logout, 'Log Out', () {
              Navigator.pushReplacementNamed(context, '/login');
            }, isDestructive: true),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textLight,
        ),
        onTap: onTap,
      ),
    );
  }
}