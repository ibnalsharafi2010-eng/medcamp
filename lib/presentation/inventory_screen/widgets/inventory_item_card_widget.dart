import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../inventory_model.dart' as inventory_model;

class InventoryItemCardWidget extends StatelessWidget {
  final InventoryItem item;
  final String selectedCamp;

  const InventoryItemCardWidget({
    super.key,
    required this.item,
    required this.selectedCamp,
  });

  @override
  Widget build(BuildContext context) {
    final status = item.statusForCamp(selectedCamp);
    final stock = item.stockForCamp(selectedCamp);
    final required = item.requiredForCamp(selectedCamp);

    Color statusColor;
    Color statusBg;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case inventory_model.StockStatus.empty:
        statusColor = AppTheme.error;
        statusBg = AppTheme.errorContainer;
        statusLabel = 'نافد';
        statusIcon = Icons.remove_circle_rounded;
        break;
      case inventory_model.StockStatus.low:
        statusColor = AppTheme.warning;
        statusBg = AppTheme.warningContainer;
        statusLabel = 'منخفض';
        statusIcon = Icons.warning_amber_rounded;
        break;
      case inventory_model.StockStatus.normal:
        statusColor = AppTheme.success;
        statusBg = AppTheme.successContainer;
        statusLabel = 'جيد';
        statusIcon = Icons.check_circle_rounded;
        break;
    }

    final double progress = (required > 0)
        ? (stock / required).clamp(0.0, 1.0)
        : (stock > 0 ? 1.0 : 0.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == inventory_model.StockStatus.empty
              ? AppTheme.error.withAlpha(80)
              : status == inventory_model.StockStatus.low
              ? AppTheme.warning.withAlpha(80)
              : const Color(0xFFE3F2FD),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.id}',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.category,
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.unit,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withAlpha(80),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        statusLabel,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المتبقي: $stock ${item.unit}',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                          if (required > 0)
                            Text(
                              'المطلوب: $required',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFECEFF1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            statusColor,
                          ),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.price > 0) ...[
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'السعر',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      Text(
                        '${item.price.toStringAsFixed(0)} ر',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            if (selectedCamp == 'الكل' && item.stockByCamp.length > 1) ...[
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFECEFF1)),
              const SizedBox(height: 8),
              Row(
                children: item.stockByCamp.entries.map((entry) {
                  return Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(150),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${entry.key}: ',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        Text(
                          '${entry.value}',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}