import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum StockStatus { adequate, low, empty, pending, active, completed }

class StatusBadgeWidget extends StatelessWidget {
  final StockStatus status;
  final String? customLabel;

  const StatusBadgeWidget({super.key, required this.status, this.customLabel});

  String get _label {
    if (customLabel != null) return customLabel!;
    switch (status) {
      case StockStatus.adequate:
        return 'كافٍ';
      case StockStatus.low:
        return 'منخفض';
      case StockStatus.empty:
        return 'نافد';
      case StockStatus.pending:
        return 'معلّق';
      case StockStatus.active:
        return 'نشط';
      case StockStatus.completed:
        return 'مكتمل';
    }
  }

  Color get _bgColor {
    switch (status) {
      case StockStatus.adequate:
        return AppTheme.successContainer;
      case StockStatus.low:
        return AppTheme.warningContainer;
      case StockStatus.empty:
        return AppTheme.errorContainer;
      case StockStatus.pending:
        return const Color(0xFFFFF8E1);
      case StockStatus.active:
        return AppTheme.primaryContainer;
      case StockStatus.completed:
        return const Color(0xFFE0F7FA);
    }
  }

  Color get _textColor {
    switch (status) {
      case StockStatus.adequate:
        return AppTheme.success;
      case StockStatus.low:
        return AppTheme.warning;
      case StockStatus.empty:
        return AppTheme.error;
      case StockStatus.pending:
        return const Color(0xFFF57F17);
      case StockStatus.active:
        return AppTheme.primary;
      case StockStatus.completed:
        return const Color(0xFF00838F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        _label,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
