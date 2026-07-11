import 'dart:ui';
import 'package:flutter/material.dart';

/// Design System Configuration
/// Blends Glassmorphism, Neumorphism, Skeuomorphism, and Bento UI
class DesignSystem {
  // ========== GLASSMORPHISM ==========
  static BoxDecoration glassMorphism({
    Color backgroundColor = Colors.white,
    double borderRadius = 20,
    double opacity = 0.25,
    double blur = 10,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(color: Colors.white.withValues(alpha: 0.18)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ========== NEUMORPHISM ==========
  static BoxDecoration neumorphism({
    Color backgroundColor = const Color(0xFFF0F0F3),
    double borderRadius = 20,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.5),
                offset: const Offset(-2, -2),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(2, 2),
                blurRadius: 5,
              ),
            ]
          : [
              BoxShadow(
                color: const Color(0xFFFFFFFF),
                offset: const Offset(-5, -5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: const Color(0xFFD1D9E6),
                offset: const Offset(5, 5),
                blurRadius: 10,
              ),
            ],
    );
  }

  static Widget neumorphicButton({
    required Widget child,
    required VoidCallback onPressed,
    Color backgroundColor = const Color(0xFFF0F0F3),
    double borderRadius = 16,
    bool mini = false,
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isPressed = false;
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) {
            setState(() => isPressed = false);
            onPressed();
          },
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: mini ? 12 : 24,
              vertical: mini ? 8 : 16,
            ),
            decoration: neumorphism(
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              isPressed: isPressed,
            ),
            child: child,
          ),
        );
      },
    );
  }

  // ========== SKEUOMORPHISM ==========
  static BoxDecoration skeuomorphic({
    required Color color,
    double borderRadius = 16,
    bool hasGradient = true,
    bool hasInnerShadow = false,
  }) {
    return BoxDecoration(
      gradient: hasGradient
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.7),
              ],
            )
          : null,
      color: hasGradient ? null : color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          offset: const Offset(0, 6),
          blurRadius: 12,
        ),
        if (hasInnerShadow)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
      ],
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.15),
        width: 1,
      ),
    );
  }

  // ========== BENTO UI ==========
  static BoxDecoration bentoCard({
    Color? backgroundColor,
    double borderRadius = 20,
    Color borderColor = const Color(0xFFF0F0F0),
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder ? Border.all(color: borderColor, width: 1) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ========== COMBINED EFFECTS ==========

  /// Glassmorphism card with subtle neumorphic shadow
  static BoxDecoration glassCard({
    Color backgroundColor = Colors.white,
    double borderRadius = 20,
    double blur = 10,
  }) {
    return BoxDecoration(
      color: backgroundColor.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.1),
          offset: const Offset(-2, -2),
          blurRadius: blur,
        ),
      ],
    );
  }

  /// Bento grid layout for responsive grids
  static List<SliverGridDelegate> bentoLayout({
    required BuildContext context,
    required int crossAxisCount,
    double mainAxisSpacing = 12,
    double crossAxisSpacing = 12,
  }) {
    return [
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 0.8,
      ),
    ];
  }
}

/// Animated press effect widget for neumorphic buttons
class NeumorphicPressEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const NeumorphicPressEffect({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = const Color(0xFFF0F0F3),
  });

  @override
  State<NeumorphicPressEffect> createState() => _NeumorphicPressEffectState();
}

class _NeumorphicPressEffectState extends State<NeumorphicPressEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: DesignSystem.neumorphism(
          backgroundColor: widget.backgroundColor,
          isPressed: _isPressed,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Glass morphism with backdrop blur
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final EdgeInsets padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.opacity = 0.25,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: opacity, sigmaY: opacity),
        child: Container(
          padding: padding,
          decoration: DesignSystem.glassMorphism(
            backgroundColor: Colors.white,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}