import '../../../core/app_export.dart';

class InventoryFilterBarWidget extends StatelessWidget {
  final String selectedCamp;
  final String selectedCategory;
  final String selectedStatus;
  final List<String> camps;
  final List<String> categories;
  final ValueChanged<String> onCampChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onStatusChanged;

  const InventoryFilterBarWidget({
    super.key,
    required this.selectedCamp,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.camps,
    required this.categories,
    required this.onCampChanged,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Camp filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: camps.map((camp) {
                final isSelected = selectedCamp == camp;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(camp),
                    selected: isSelected,
                    onSelected: (_) => onCampChanged(camp),
                    backgroundColor: AppTheme.background,
                    selectedColor: AppTheme.primaryContainer,
                    checkmarkColor: AppTheme.primary,
                    labelStyle: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primary
                          : const Color(0xFFCFD8DC),
                      width: isSelected ? 1.5 : 1,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Category + Status filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Status chips
                ...['الكل', 'منخفض', 'نافد'].map((status) {
                  final isSelected = selectedStatus == status;
                  Color chipColor = AppTheme.background;
                  Color textColor = AppTheme.textSecondary;
                  Color borderColor = const Color(0xFFCFD8DC);
                  if (isSelected) {
                    if (status == 'منخفض') {
                      chipColor = AppTheme.warningContainer;
                      textColor = AppTheme.warning;
                      borderColor = AppTheme.warning;
                    } else if (status == 'نافد') {
                      chipColor = AppTheme.errorContainer;
                      textColor = AppTheme.error;
                      borderColor = AppTheme.error;
                    } else {
                      chipColor = AppTheme.primaryContainer;
                      textColor = AppTheme.primary;
                      borderColor = AppTheme.primary;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (_) => onStatusChanged(status),
                      backgroundColor: chipColor,
                      selectedColor: chipColor,
                      checkmarkColor: textColor,
                      labelStyle: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? textColor : AppTheme.textSecondary,
                      ),
                      side: BorderSide(
                        color: borderColor,
                        width: isSelected ? 1.5 : 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: const Color(0xFFCFD8DC)),
                const SizedBox(width: 8),
                // Category chips
                ...categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => onCategoryChanged(cat),
                      backgroundColor: AppTheme.background,
                      selectedColor: AppTheme.secondaryContainer,
                      checkmarkColor: AppTheme.secondary,
                      labelStyle: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.secondary
                            : AppTheme.textSecondary,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.secondary
                            : const Color(0xFFCFD8DC),
                        width: isSelected ? 1.5 : 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
