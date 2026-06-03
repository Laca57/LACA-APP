import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';

class AgroBusinessScreen extends StatelessWidget {
  const AgroBusinessScreen({super.key});

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
                  colors: [AppColors.serviceAgro, Color(0xFF006837)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agro Business',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pembeyeo • Masoko • Usafirishaji',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Category Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      'Pembeyeo',
                      'Farm Inputs',
                      Icons.eco,
                      AppColors.serviceAgro,
                      context,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCategoryCard(
                      'Masoko',
                      'Markets',
                      Icons.store,
                      AppColors.serviceCargo,
                      context,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCategoryCard(
                      'Usafirishaji',
                      'Transport',
                      Icons.local_shipping,
                      AppColors.info,
                      context,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Featured Products
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildProductCard(
                    'Urea Fertilizer',
                    '50kg bag',
                    'TZS 65,000',
                    Icons.eco,
                    AppColors.serviceAgro,
                  ),
                  _buildProductCard(
                    'Maize Seeds',
                    'DH Series, 10kg',
                    'TZS 12,500',
                    Icons.grass,
                    AppColors.serviceCargo,
                  ),
                  _buildProductCard(
                    'Organic Compost',
                    '25kg bag',
                    'TZS 25,000',
                    Icons.clean_hands,
                    Colors.brown,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Recent Listings
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Listings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildListingItem(
              'Fresh Tomatoes',
              '200kg available',
              'TZS 1,500/kg',
              'Mbeya Region',
            ),
            _buildListingItem(
              'Organic Coffee Beans',
              '500kg available',
              'TZS 12,000/kg',
              'Arusha Region',
            ),
            _buildListingItem(
              'Cassava Flour',
              '1,000kg available',
              'TZS 3,000/kg',
              'Coast Region',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      String title, String subtitle, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgroCategoryScreen(title: title, subtitle: subtitle, color: color),
          ),
        );
      },
      child: Container(
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
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
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
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      String name, String weight, String price, IconData icon, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            weight,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.add, color: color, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListingItem(
      String product, String quantity, String price, String region) {
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.serviceAgro.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco, color: AppColors.serviceAgro, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text(price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.inventory_2,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(quantity,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(region,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgroCategoryScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const AgroCategoryScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (title == 'Pembeyeo') ...[
            _buildProductItem('Urea Fertilizer 50kg', 'TZS 65,000', 'In Stock'),
            _buildProductItem('DAP Fertilizer 50kg', 'TZS 78,000', 'In Stock'),
            _buildProductItem('Maize Seeds - DH Series', 'TZS 12,500/kg', 'In Stock'),
            _buildProductItem('Tomato Seeds - ProStar', 'TZS 45,000/pack', 'Low Stock'),
            _buildProductItem('Organic Pesticide', 'TZS 25,000/L', 'In Stock'),
          ] else if (title == 'Masoko') ...[
            _buildProductItem('Fresh Tomatoes', 'TZS 1,500/kg', '200kg avail.'),
            _buildProductItem('Onions', 'TZS 2,000/kg', '500kg avail.'),
            _buildProductItem('Green Peppers', 'TZS 3,500/kg', '150kg avail.'),
            _buildProductItem('Rice - Pishori', 'TZS 3,000/kg', '1,000kg avail.'),
          ] else ...[
            _buildProductItem('Farm to Market (per km)', 'TZS 500/kg', 'Available'),
            _buildProductItem('City Delivery (per km)', 'TZS 800/kg', 'Available'),
            _buildProductItem('Refrigerated Transport', 'TZS 1,200/kg', 'On Request'),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(String name, String price, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreenLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(status,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.serviceAgro)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: 'Quote',
            height: 36,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}