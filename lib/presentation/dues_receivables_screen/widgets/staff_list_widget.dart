import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class StaffMember {
  final String id;
  final String name;
  final String specialty;
  final int days;
  final double dailyRate;
  final double paid;

  StaffMember({
    required this.id,
    required this.name,
    required this.specialty,
    required this.days,
    required this.dailyRate,
    required this.paid,
  });

  double get total => days * dailyRate;
  double get remaining => total - paid;
  bool get fullyPaid => remaining <= 0;

  factory StaffMember.fromMap(Map<String, dynamic> map) {
    return StaffMember(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      specialty: map['specialty']?.toString() ?? '',
      days: (map['days'] as num?)?.toInt() ?? 0,
      dailyRate: (map['dailyRate'] as num?)?.toDouble() ?? 0.0,
      paid: (map['paid'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'days': days,
    'dailyRate': dailyRate,
    'paid': paid,
  };
}

class StaffListItemWidget extends StatelessWidget {
  final StaffMember staff;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StaffListItemWidget({
    super.key,
    required this.staff,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _specialtyColor {
    switch (staff.specialty) {
      case 'استشاري عيون':
        return AppTheme.primary;
      case 'أخصائي عيون':
        return const Color(0xFF0288D1);
      case 'أخصائي باطنية':
        return const Color(0xFF00838F);
      case 'طبيب':
        return AppTheme.success;
      case 'فني عمليات':
        return const Color(0xFF6A1B9A);
      case 'مختبرات':
        return const Color(0xFFAD1457);
      case 'تمريض':
        return const Color(0xFF558B2F);
      case 'إداري':
        return AppTheme.textSecondary;
      default:
        return AppTheme.textMuted;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('staff_${staff.id}'),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppTheme.error,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('حذف الموظف'),
            content: Text('هل تريد حذف ${staff.name}؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: staff.fullyPaid
                ? AppTheme.success.withAlpha(38)
                : const Color(0xFFECEFF1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppTheme.primaryContainer,
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _specialtyColor.withAlpha(31),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            staff.name.isNotEmpty
                                ? staff.name.substring(0, 1)
                                : '؟',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _specialtyColor,
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
                              staff.name,
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _specialtyColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                staff.specialty,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _specialtyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadgeWidget(
                        status: staff.fullyPaid
                            ? StockStatus.completed
                            : staff.remaining > staff.total * 0.5
                            ? StockStatus.low
                            : StockStatus.pending,
                        customLabel: staff.fullyPaid ? 'مكتمل' : 'متبقي',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _MetricCell(
                          label: 'الأيام',
                          value: '${staff.days}',
                          unit: 'يوم',
                          color: AppTheme.primary,
                        ),
                        _buildDivider(),
                        _MetricCell(
                          label: 'اليومي',
                          value: _formatAmount(staff.dailyRate),
                          unit: 'ريال',
                          color: AppTheme.textSecondary,
                        ),
                        _buildDivider(),
                        _MetricCell(
                          label: 'الإجمالي',
                          value: _formatAmount(staff.total),
                          unit: 'ريال',
                          color: AppTheme.primary,
                        ),
                        _buildDivider(),
                        _MetricCell(
                          label: 'المتبقي',
                          value: _formatAmount(staff.remaining),
                          unit: 'ريال',
                          color: staff.fullyPaid
                              ? AppTheme.success
                              : AppTheme.warning,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFECEFF1),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MetricCell({
    required this.label,
    required this.value,
    required this.unit,
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
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
