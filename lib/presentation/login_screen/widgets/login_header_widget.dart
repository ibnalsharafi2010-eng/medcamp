import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeaderWidget extends StatelessWidget {
  final bool isTablet;

  const LoginHeaderWidget({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 36 : 48,
        horizontal: isTablet ? 32 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Logo Container
          Container(
            width: isTablet ? 72 : 80,
            height: isTablet ? 72 : 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(77), width: 2),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 16),
          Text(
            'MedCamp',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isTablet ? 26 : 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'إدارة المخزون الطبي للمخيمات الإنسانية',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(217),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 0 : 8),
        ],
      ),
    );
  }
}
