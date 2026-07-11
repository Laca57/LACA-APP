import 'package:flutter/material.dart';
import '../freight/freight_booking_screen.dart';

class CargoClearingScreen extends StatefulWidget {
  const CargoClearingScreen({super.key});

  @override
  State<CargoClearingScreen> createState() => _CargoClearingScreenState();
}

class _CargoClearingScreenState extends State<CargoClearingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FreightBookingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
