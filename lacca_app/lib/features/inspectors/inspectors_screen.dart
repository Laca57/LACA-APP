import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ad_banner.dart';
import '../../core/utils/responsive.dart';

class InspectorsScreen extends StatelessWidget {
  const InspectorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspectors'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const AdBanner(
            message: '🌍 Verified international inspectors for your business',
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(context, 16),
                vertical: Responsive.h(context, 12),
              ),
              itemCount: _inspectors.length,
              itemBuilder: (context, index) =>
                  _buildInspectorCard(context, _inspectors[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectorCard(BuildContext context, _Inspector inspector) {
    final flagColors = {
      'Japan': const Color(0xFFBC002D),
      'China': const Color(0xFFDE2910),
      'UAE': const Color(0xFF009933),
      'Germany': const Color(0xFFDD0000),
      'USA': const Color(0xFF3C3B6E),
      'Tanzania': const Color(0xFF1EB53A),
    };
    final flagColor = flagColors[inspector.country] ?? AppColors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, 14)),
      padding: EdgeInsets.all(Responsive.w(context, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w(context, 16)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: Responsive.w(context, 56),
                height: Responsive.w(context, 56),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      inspector.color.withValues(alpha: 0.8),
                      inspector.color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(Responsive.w(context, 16)),
                ),
                child: Center(
                  child: Text(
                    inspector.name.split(' ').map((s) => s[0]).take(2).join(),
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Responsive.w(context, 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspector.name,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 15),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 3)),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: flagColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              inspector.country[0],
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          inspector.country,
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.star, size: 14, color: AppColors.warning),
                        Text(
                          '${inspector.rating}',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        inspector.price,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '/ inspection',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9),
                          color: AppColors.success.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 12)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: inspector.specialties.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: inspector.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 10),
                    fontWeight: FontWeight.w500,
                    color: inspector.color,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: Responsive.h(context, 10)),
          Text(
            inspector.description,
            style: TextStyle(
              fontSize: Responsive.sp(context, 12),
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: Responsive.h(context, 12)),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: AppColors.info),
                    const SizedBox(width: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${inspector.verified} verified',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 10),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: inspector.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Contact Inspector',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Inspector {
  final String name, country, price, description;
  final Color color;
  final double rating;
  final int verified;
  final List<String> specialties;

  const _Inspector({
    required this.name,
    required this.country,
    required this.price,
    required this.description,
    required this.color,
    required this.rating,
    required this.verified,
    required this.specialties,
  });
}

const List<_Inspector> _inspectors = [
  _Inspector(
    name: 'Takeshi Yamamoto',
    country: 'Japan',
    price: 'TZS 350,000',
    color: Color(0xFFE53935),
    rating: 4.9,
    verified: 1247,
    specialties: ['Vehicle Inspection', 'Export Quality', 'Mechanical'],
    description:
        '20+ years experience inspecting Japanese used cars. Specializes in BE FORWARD and SBT Japan vehicle verification.',
  ),
  _Inspector(
    name: 'Li Wei Chen',
    country: 'China',
    price: 'TZS 280,000',
    color: Color(0xFF1E88E5),
    rating: 4.8,
    verified: 892,
    specialties: ['Electronics', 'Manufacturing', 'Container Cargo'],
    description:
        'Certified inspector for Chinese exports. Verifies electronics, machinery and manufactured goods before shipment.',
  ),
  _Inspector(
    name: 'Ahmed Al-Rashid',
    country: 'UAE',
    price: 'TZS 420,000',
    color: Color(0xFFF9A825),
    rating: 4.7,
    verified: 634,
    specialties: ['Luxury Goods', 'Auto Parts', 'General Cargo'],
    description:
        'Dubai-based inspector for Middle Eastern imports. Specializes in high-value goods and auto parts verification.',
  ),
  _Inspector(
    name: 'Hans Mueller',
    country: 'Germany',
    price: 'TZS 550,000',
    color: Color(0xFF6A1B9A),
    rating: 4.9,
    verified: 1521,
    specialties: ['Industrial Equipment', 'Machinery', 'Quality Audit'],
    description:
        'German TÜV-certified inspector. Provides comprehensive inspection reports for European machinery imports.',
  ),
  _Inspector(
    name: 'Sarah Johnson',
    country: 'USA',
    price: 'TZS 480,000',
    color: Color(0xFF2E7D32),
    rating: 4.6,
    verified: 456,
    specialties: ['Agricultural', 'Chemical', 'Pharmaceutical'],
    description:
        'FDA and USDA background. Inspects agricultural products, chemicals and pharmaceuticals for African importers.',
  ),
];