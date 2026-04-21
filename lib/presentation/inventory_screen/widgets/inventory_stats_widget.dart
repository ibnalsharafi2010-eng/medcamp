import '../../../core/app_export.dart';

class InventoryStatsWidget extends StatelessWidget {
  final int totalItems;
  final int lowStockCount;
  final int emptyStockCount;
  final int normalCount;

  const InventoryStatsWidget({
    super.key,
    required this.totalItems,
    required this.lowStockCount,
    required this.emptyStockCount,
    required this.normalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _StatChip(
            label: 'إجمالي الأصناف',
            value: totalItems.toString(),
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer,
            icon: Icons.inventory_2_rounded,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'مخزون جيد',
            value: normalCount.toString(),
            color: AppTheme.success,
            bgColor: AppTheme.successContainer,
            icon: Icons.check_circle_rounded,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'منخفض',
            value: lowStockCount.toString(),
            color: AppTheme.warning,
            bgColor: AppTheme.warningContainer,
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'نافد',
            value: emptyStockCount.toString(),
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer,
            icon: Icons.remove_circle_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(60), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color.withAlpha(200),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
