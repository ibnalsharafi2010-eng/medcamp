enum StockStatus { normal, low, empty }

class InventoryItem {
  final int id;
  final String name;
  final String category;
  final String unit;
  final double price;
  final Map<String, int> stockByCamp;
  final Map<String, int> consumedByCamp;
  final Map<String, int> requiredForWork;
  final Map<String, int> requiredToBuy;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.stockByCamp,
    required this.consumedByCamp,
    required this.requiredForWork,
    required this.requiredToBuy,
  });

  int stockForCamp(String camp) {
    if (camp == 'الكل') {
      return stockByCamp.values.fold(0, (a, b) => a + b);
    }
    return stockByCamp[camp] ?? 0;
  }

  int requiredForCamp(String camp) {
    if (camp == 'الكل') {
      return requiredForWork.values.fold(0, (a, b) => a + b);
    }
    return requiredForWork[camp] ?? 0;
  }

  StockStatus statusForCamp(String camp) {
    final stock = stockForCamp(camp);
    final required = requiredForCamp(camp);
    if (stock <= 0) return StockStatus.empty;
    if (required > 0 && stock < required * 0.6) return StockStatus.low;
    return StockStatus.normal;
  }
}
