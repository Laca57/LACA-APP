import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/design_system.dart';
import '../utils/responsive.dart';

/// ServiceCard with Bento UI + Glassmorphism blend
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String? hint;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicPressEffect(
      onTap: onTap,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Responsive.w(context, 10)),
        decoration: DesignSystem.glassCard(
          backgroundColor: Colors.white,
          borderRadius: Responsive.w(context, 14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Responsive.w(context, 42),
              height: Responsive.w(context, 42),
              decoration: DesignSystem.skeuomorphic(
                color: color,
                borderRadius: Responsive.w(context, 12),
                hasGradient: true,
                hasInnerShadow: true,
              ),
              child: Icon(icon, color: Colors.white, size: Responsive.w(context, 20)),
            ),
            SizedBox(height: Responsive.h(context, 6)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.sp(context, 11),
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
              ),
            ),
            if (hint != null) ...[
              SizedBox(height: Responsive.h(context, 2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 9),
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// StatCard with neumorphism
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicPressEffect(
      onTap: () {},
      backgroundColor: color.withValues(alpha: 0.1),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.h(context, 12),
          horizontal: Responsive.w(context, 8),
        ),
        decoration: DesignSystem.glassCard(
          backgroundColor: color.withValues(alpha: 0.15),
          borderRadius: Responsive.w(context, 12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: Responsive.w(context, 22)),
            SizedBox(height: Responsive.h(context, 4)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 18),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: Responsive.h(context, 2)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SectionHeader with subtle glass effect
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 16),
        vertical: Responsive.h(context, 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 13),
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}