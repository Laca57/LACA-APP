import 'package:flutter/material.dart';

/// Provides responsive sizing utilities based on screen dimensions.
/// Use this throughout the app to ensure UI scales across all screen sizes.
class Responsive {
  /// Screen breakpoints
  static const double mobileBreakpoint = 360;
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  /// Get device type
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletBreakpoint;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Scale a value proportionally to screen width (reference: 375 = iPhone SE)
  static double w(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    // For very small screens, don't go below 0.75 scale
    return value * (screenWidth / 375).clamp(0.75, 1.5);
  }

  /// Scale a value proportionally to screen height (reference: 812 = iPhone X)
  static double h(BuildContext context, double value) {
    final screenHeight = MediaQuery.of(context).size.height;
    return value * (screenHeight / 812).clamp(0.75, 1.5);
  }

  /// Scale font size (uses width-based scaling but with tighter bounds)
  static double sp(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = (screenWidth / 375).clamp(0.85, 1.3);
    return value * scale;
  }

  /// Get proportional padding (uses both width and height)
  static EdgeInsets padding(BuildContext context,
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return EdgeInsets.only(
      left: w(context, left),
      top: h(context, top),
      right: w(context, right),
      bottom: h(context, bottom),
    );
  }

  /// Get symmetric padding
  static EdgeInsets sym(BuildContext context,
      {double hVal = 0, double vVal = 0}) {
    return EdgeInsets.symmetric(
      horizontal: w(context, hVal),
      vertical: h(context, vVal),
    );
  }

  /// Get proportional SizedBox width
  static Widget gapW(BuildContext context, double value) =>
      SizedBox(width: w(context, value));

  /// Get proportional SizedBox height
  static Widget gapH(BuildContext context, double value) =>
      SizedBox(height: h(context, value));

  /// Shortcut: vertical spacer using height
  static double hp(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }

  /// Shortcut: horizontal spacer using width
  static double wp(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }
}

/// Extension on BuildContext for easy access to responsive values
extension ResponsiveContext on BuildContext {
  /// Scale width
  double get rw => MediaQuery.of(this).size.width;

  /// Scale height
  double get rh => MediaQuery.of(this).size.height;

  /// Width percentage
  double wp(double percent) => rw * (percent / 100);

  /// Height percentage
  double hp(double percent) => rh * (percent / 100);

  /// Is the device a tablet or larger?
  bool get isTabletOrWider => rw >= 600;

  /// Is the device a phone?
  bool get isPhone => rw < 600;
}