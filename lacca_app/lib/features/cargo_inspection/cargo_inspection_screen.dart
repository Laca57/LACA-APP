import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ad_banner.dart';
import '../../core/utils/responsive.dart';

class CargoInspectionScreen extends StatelessWidget {
  const CargoInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargo Inspection'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const AdBanner(
            message: '🔍 Trusted Tanzanian inspection companies',
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(context, 16),
                vertical: Responsive.h(context, 12),
              ),
              itemCount: _companies.length,
              itemBuilder: (context, index) {
                return _buildCompanyCard(context, _companies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, _CargoCompany company) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Responsive.w(context, 52),
                height: Responsive.w(context, 52),
                decoration: BoxDecoration(
                  color: company.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.w(context, 14)),
                ),
                child: Icon(company.icon, size: Responsive.w(context, 26), color: company.color),
              ),
              SizedBox(width: Responsive.w(context, 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 15),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 2)),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${company.rating}',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${company.reviews} reviews',
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 10),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
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
            children: company.services.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: company.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 10),
                    fontWeight: FontWeight.w500,
                    color: company.color,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: Responsive.h(context, 10)),
          Text(
            company.description,
            style: TextStyle(
              fontSize: Responsive.sp(context, 12),
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: Responsive.h(context, 12)),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    company.location,
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 4)),
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  company.phone,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 12)),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: company.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Request Inspection',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.phone_in_talk, size: 18, color: company.color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CargoCompany {
  final String name, description, location, phone;
  final IconData icon;
  final Color color;
  final double rating;
  final int reviews;
  final List<String> services;

  const _CargoCompany({
    required this.name,
    required this.description,
    required this.location,
    required this.phone,
    required this.icon,
    required this.color,
    required this.rating,
    required this.reviews,
    required this.services,
  });
}

const List<_CargoCompany> _companies = [
  _CargoCompany(
    name: 'TBS - Tanzania Bureau of Standards',
    icon: Icons.verified,
    color: Color(0xFF1565C0),
    rating: 4.5,
    reviews: 2301,
    services: ['Quality Inspection', 'Product Testing', 'Certification'],
    location: 'Morogoro Road, Dar es Salaam',
    phone: '+255 22 245 0298',
    description: 'National standards body providing cargo inspection, quality assurance and certification services for imports and exports.',
  ),
  _CargoCompany(
    name: 'SGS Tanzania',
    icon: Icons.assured_workload,
    color: Color(0xFFE65100),
    rating: 4.7,
    reviews: 1892,
    services: ['Pre-Shipment', 'Container Inspection', 'Weight Verification'],
    location: 'Plot 55, Mwai Kibaki Road, Dar es Salaam',
    phone: '+255 22 212 2477',
    description: 'Global leader in inspection, verification, testing and certification. Specializes in pre-shipment cargo inspection.',
  ),
  _CargoCompany(
    name: 'Bureau Veritas Tanzania',
    icon: Icons.gavel,
    color: Color(0xFF2E7D32),
    rating: 4.6,
    reviews: 1456,
    services: ['Marine Cargo', 'Industrial Inspection', 'Customs Verification'],
    location: 'Plot 23, Haile Selassie Road, Dar es Salaam',
    phone: '+255 22 211 4995',
    description: 'World-leading inspection and certification services. Expertise in marine cargo, industrial equipment and customs verification.',
  ),
  _CargoCompany(
    name: 'Intertek Tanzania',
    icon: Icons.science,
    color: Color(0xFF6A1B9A),
    rating: 4.4,
    reviews: 923,
    services: ['Chemical Testing', 'Agricultural Cargo', 'Quality Audit'],
    location: 'Mikocheni B, Dar es Salaam',
    phone: '+255 22 278 0091',
    description: 'Total quality assurance provider. Specializes in chemical testing, agricultural cargo inspection and quality audits.',
  ),
  _CargoCompany(
    name: 'TICTS - Tanzania International Container Terminal',
    icon: Icons.dock,
    color: Color(0xFF00838F),
    rating: 4.3,
    reviews: 1782,
    services: ['Container Inspection', 'Customs Clearance', 'Cargo Handling'],
    location: 'Dar es Salaam Port, Kivukoni',
    phone: '+255 22 213 5700',
    description: 'Premier container terminal operator offering integrated cargo inspection, clearance and handling services at Dar es Salaam Port.',
  ),
];