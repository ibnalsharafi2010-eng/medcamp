import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

enum CampStatus { active, completed, pending, archived }

class CampModel {
  final String id;
  final int number;
  final String name;
  final String date;
  final String location;
  final CampStatus status;
  final int totalItems;
  final int lowStockItems;
  final int emptyStockItems;
  final double totalConsumptionValue;
  final double totalPurchasesValue;
  final int staffCount;
  final double stockProgress;

  CampModel({
    required this.id,
    required this.number,
    required this.name,
    required this.date,
    required this.location,
    required this.status,
    required this.totalItems,
    required this.lowStockItems,
    required this.emptyStockItems,
    required this.totalConsumptionValue,
    required this.totalPurchasesValue,
    required this.staffCount,
    required this.stockProgress,
  });

  static CampStatus _statusFromString(String v) {
    switch (v) {
      case 'active':
        return CampStatus.active;
      case 'completed':
        return CampStatus.completed;
      case 'archived':
        return CampStatus.archived;
      default:
        return CampStatus.pending;
    }
  }

  factory CampModel.fromMap(Map<String, dynamic> map) {
    return CampModel(
      id: map['id']?.toString() ?? '',
      number: (map['number'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      status: _statusFromString(map['status']?.toString() ?? 'pending'),
      totalItems: (map['totalItems'] as num?)?.toInt() ?? 0,
      lowStockItems: (map['lowStockItems'] as num?)?.toInt() ?? 0,
      emptyStockItems: (map['emptyStockItems'] as num?)?.toInt() ?? 0,
      totalConsumptionValue:
          (map['totalConsumptionValue'] as num?)?.toDouble() ?? 0.0,
      totalPurchasesValue:
          (map['totalPurchasesValue'] as num?)?.toDouble() ?? 0.0,
      staffCount: (map['staffCount'] as num?)?.toInt() ?? 0,
      stockProgress: (map['stockProgress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'number': number,
    'name': name,
    'date': date,
    'location': location,
    'status': status.name,
    'totalItems': totalItems,
    'lowStockItems': lowStockItems,
    'emptyStockItems': emptyStockItems,
    'totalConsumptionValue': totalConsumptionValue,
    'totalPurchasesValue': totalPurchasesValue,
    'staffCount': staffCount,
    'stockProgress': stockProgress,
  };
}

class CampCardWidget extends StatelessWidget {
  final CampModel camp;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const CampCardWidget({
    super.key,
    required this.camp,
    required this.onTap,
    required this.onEdit,
  });

  Color get _statusColor {
    switch (camp.status) {
      case CampStatus.active:
        return AppTheme.success;
      case CampStatus.completed:
        return AppTheme.primary;
      case CampStatus.pending:
        return AppTheme.warning;
      case CampStatus.archived:
        return AppTheme.textMuted;
    }
  }

  StockStatus get _badgeStatus {
    switch (camp.status) {
      case CampStatus.active:
        return StockStatus.active;
      case CampStatus.completed:
        return StockStatus.completed;
      case CampStatus.pending:
        return StockStatus.pending;
      case CampStatus.archived:
        return StockStatus.pending;
    }
  }

  String get _statusLabel {
    switch (camp.status) {
      case CampStatus.active:
        return 'نشط';
      case CampStatus.completed:
        return 'مكتمل';
      case CampStatus.pending:
        return 'معلّق';
      case CampStatus.archived:
        return 'مؤرشف';
    }
  }

  String _formatCurrency(double val) {
    if (val >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)}م';
    } else if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(0)}K';
    }
    return val.toStringAsFixed(0);
  }

  Color get _progressColor {
    if (camp.stockProgress >= 0.6) return AppTheme.success;
    if (camp.stockProgress >= 0.3) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: camp.status == CampStatus.active
              ? AppTheme.success.withAlpha(64)
              : const Color(0xFFECEFF1),
          width: camp.status == CampStatus.active ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.primaryContainer,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Camp number badge
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _statusColor.withAlpha(38),
                            _statusColor.withAlpha(13),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _statusColor.withAlpha(77)),
                      ),
                      child: Center(
                        child: Text(
                          '${camp.number}',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _statusColor,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camp.name,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: AppTheme.textMuted,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                camp.location,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppTheme.textMuted,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                camp.date,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'تعديل',
                                style: GoogleFonts.ibmPlexSans(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'dues',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                size: 16,
                                color: AppTheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'المستحقات',
                                style: GoogleFonts.ibmPlexSans(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (val) {
                        if (val == 'edit') onEdit();
                        if (val == 'dues') {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.duesReceivablesScreen,
                          );
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Stock progress bar
                if (camp.totalItems > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مستوى المخزون',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      Text(
                        '${(camp.stockProgress * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _progressColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: camp.stockProgress,
                      backgroundColor: const Color(0xFFECEFF1),
                      valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Metrics row
                Row(
                  children: [
                    _MetricBadge(
                      icon: Icons.inventory_2_outlined,
                      label: '${camp.totalItems} صنف',
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 6),
                    if (camp.lowStockItems > 0)
                      _MetricBadge(
                        icon: Icons.warning_amber_rounded,
                        label: '${camp.lowStockItems} منخفض',
                        color: AppTheme.warning,
                      ),
                    const SizedBox(width: 6),
                    if (camp.emptyStockItems > 0)
                      _MetricBadge(
                        icon: Icons.remove_circle_outline_rounded,
                        label: '${camp.emptyStockItems} نافد',
                        color: AppTheme.error,
                      ),
                    const Spacer(),
                    StatusBadgeWidget(
                      status: _badgeStatus,
                      customLabel: _statusLabel,
                    ),
                  ],
                ),

                if (camp.totalConsumptionValue > 0) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _FinanceCell(
                          label: 'الاستهلاك',
                          value: _formatCurrency(camp.totalConsumptionValue),
                          color: AppTheme.error,
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: const Color(0xFFECEFF1),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        _FinanceCell(
                          label: 'المشتريات',
                          value: _formatCurrency(camp.totalPurchasesValue),
                          color: AppTheme.success,
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: const Color(0xFFECEFF1),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        _FinanceCell(
                          label: 'الكادر',
                          value: '${camp.staffCount} موظف',
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FinanceCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
