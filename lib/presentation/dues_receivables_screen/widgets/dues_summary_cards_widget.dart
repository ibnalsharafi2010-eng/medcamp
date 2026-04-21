import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DuesSummaryCardsWidget extends StatelessWidget {
  final double totalEntitlements;
  final double totalPaid;
  final double totalRemaining;

  const DuesSummaryCardsWidget({
    super.key,
    required this.totalEntitlements,
    required this.totalPaid,
    required this.totalRemaining,
  });

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)} م';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} ألف';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(77),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
                    'إجمالي المستحقات',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(217),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'ريال يمني',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _formatCurrencyFull(totalEntitlements),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${totalEntitlements.toStringAsFixed(0)} ريال',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  color: Colors.white.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallSummaryCard(
                label: 'المصروف',
                amount: totalPaid,
                color: AppTheme.success,
                bgColor: AppTheme.successContainer,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SmallSummaryCard(
                label: 'المتبقي',
                amount: totalRemaining,
                color: totalRemaining > 0 ? AppTheme.warning : AppTheme.success,
                bgColor: totalRemaining > 0
                    ? AppTheme.warningContainer
                    : AppTheme.successContainer,
                icon: totalRemaining > 0
                    ? Icons.pending_outlined
                    : Icons.done_all_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCurrencyFull(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)} مليون';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} ألف';
    }
    return amount.toStringAsFixed(0);
  }
}

class _SmallSummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SmallSummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _format(amount),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            'ريال يمني',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: color.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  String _format(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}م';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}ك';
    }
    return amount.toStringAsFixed(0);
  }
}
