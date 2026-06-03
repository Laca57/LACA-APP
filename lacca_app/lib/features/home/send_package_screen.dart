import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';

class SendPackageScreen extends StatelessWidget {
  const SendPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Package'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 48, color: AppColors.textLight),
                    SizedBox(height: 8),
                    Text(
                      'Map View',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    Text(
                      'Select pickup and drop-off locations',
                      style: TextStyle(fontSize: 12, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Saved Places
            const Text(
              'Saved Places',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildPlaceCard(Icons.home, 'Home', '123 Mafinga Street, Dar es Salaam'),
            const SizedBox(height: 8),
            _buildPlaceCard(Icons.work, 'Work', '456 Samora Avenue, Dar es Salaam'),
            const SizedBox(height: 20),
            // Quick Actions
            const Text(
              'Recent Locations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentLocation('Kariakoo Market', '2.5 km away'),
            _buildRecentLocation('Mlimani City', '4.8 km away'),
            _buildRecentLocation('Julius Nyerere Airport', '12 km away'),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Continue to Book',
              icon: Icons.arrow_forward,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(IconData icon, String title, String address) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(address,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLocation(String name, String distance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, size: 20, color: AppColors.textLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: const TextStyle(color: AppColors.textPrimary)),
          ),
          Text(distance,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textLight)),
        ],
      ),
    );
  }
}