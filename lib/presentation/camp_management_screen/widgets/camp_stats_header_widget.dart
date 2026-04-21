import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class CampStatsHeaderWidget extends StatelessWidget {
  final int activeCamps;
  final int totalCamps;
  final int totalLowStock;
  final int totalEmptyStock;

  const CampStatsHeaderWidget({
    super.key,
    required this.activeCamps,
    required this.totalCamps,
    required this.totalLowStock,
    required this.totalEmptyStock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(64),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الثلاثاء، 21 أبريل 2026',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: Colors.white.withAlpha(191),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'مرحباً، مدير المخيم',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activeCamps مخيم نشط من أصل $totalCamps',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        color: Colors.white.withAlpha(217),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AlertCard(
                icon: Icons.warning_amber_rounded,
                label: 'أصناف منخفضة',
                value: totalLowStock.toString(),
                color: AppTheme.warning,
                bgColor: AppTheme.warningContainer,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AlertCard(
                icon: Icons.remove_circle_outline_rounded,
                label: 'أصناف نافدة',
                value: totalEmptyStock.toString(),
                color: AppTheme.error,
                bgColor: AppTheme.errorContainer,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AlertCard(
                icon: Icons.inventory_2_outlined,
                label: 'إجمالي المخيمات',
                value: totalCamps.toString(),
                color: AppTheme.primary,
                bgColor: AppTheme.surfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _AlertCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color.withAlpha(204),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
