import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ad_banner.dart';
import '../../core/utils/responsive.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const AdBanner(
            message: '📦 Track all your packages in one place!',
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(context, 16),
                vertical: Responsive.h(context, 12),
              ),
              itemCount: _mockOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, _mockOrders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _Order order) {
    final statusColors = {
      'Delivered': AppColors.success,
      'In Transit': AppColors.info,
      'Scheduled': AppColors.warning,
      'Pending': AppColors.textLight,
      'Confirmed': AppColors.serviceCargo,
    };
    final statusColor = statusColors[order.status] ?? AppColors.textSecondary;

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, 12)),
      padding: EdgeInsets.all(Responsive.w(context, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w(context, 14)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 13),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 10)),
          Row(
            children: [
              Icon(Icons.trip_origin, size: 14, color: AppColors.serviceSendPackage),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.pickup,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 12),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Container(width: 2, height: 12, color: AppColors.border),
          ),
          Row(
            children: [
              Icon(Icons.flag, size: 14, color: AppColors.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.dropoff,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 12),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 10)),
          Row(
            children: [
              _infoChip(context, Icons.calendar_today, order.date),
              SizedBox(width: Responsive.w(context, 8)),
              _infoChip(context, Icons.local_shipping, order.vehicle),
              SizedBox(width: Responsive.w(context, 8)),
              _infoChip(context, Icons.monetization_on, order.price),
            ],
          ),
          SizedBox(height: Responsive.h(context, 10)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: order.progress,
              backgroundColor: AppColors.border,
              color: statusColor,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textLight),
          const SizedBox(width: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: Responsive.sp(context, 10),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Order {
  final String id, status, pickup, dropoff, date, vehicle, price;
  final double progress;

  const _Order({
    required this.id,
    required this.status,
    required this.pickup,
    required this.dropoff,
    required this.date,
    required this.vehicle,
    required this.price,
    required this.progress,
  });
}

const List<_Order> _mockOrders = [
  _Order(
    id: 'LCA-2024-8921',
    status: 'Delivered',
    pickup: '123 Mafinga Street, Dar es Salaam',
    dropoff: '456 Samora Avenue, Dar es Salaam',
    date: '5 Jun 2026',
    vehicle: 'Boda',
    price: 'TZS 4,200',
    progress: 1.0,
  ),
  _Order(
    id: 'FRT-5211',
    status: 'In Transit',
    pickup: 'Dar es Salaam Port',
    dropoff: 'Mbeya CBD',
    date: '6 Jun 2026',
    vehicle: 'Carry Truck',
    price: 'TZS 85,000',
    progress: 0.65,
  ),
  _Order(
    id: 'FRT-5212',
    status: 'Confirmed',
    pickup: 'Julius Nyerere Airport',
    dropoff: 'Mlimani City, Dar es Salaam',
    date: '7 Jun 2026',
    vehicle: 'Town Hiace',
    price: 'TZS 32,000',
    progress: 0.3,
  ),
  _Order(
    id: 'SCH-001',
    status: 'Scheduled',
    pickup: 'Kariakoo Market, Dar es Salaam',
    dropoff: 'Arusha Terminal',
    date: '10 Jun 2026',
    vehicle: 'Semi Truck',
    price: 'TZS 450,000',
    progress: 0.1,
  ),
  _Order(
    id: 'IMP-2024-334',
    status: 'Pending',
    pickup: 'BE FORWARD, Japan',
    dropoff: 'Dar es Salaam Port',
    date: '15 Jun 2026',
    vehicle: 'Container Ship',
    price: 'TZS 2,500,000',
    progress: 0.05,
  ),
  _Order(
    id: 'CGO-007',
    status: 'Delivered',
    pickup: 'Mwenge, Dar es Salaam',
    dropoff: 'Tazara Station',
    date: '3 Jun 2026',
    vehicle: 'Box Truck',
    price: 'TZS 120,000',
    progress: 1.0,
  ),
];