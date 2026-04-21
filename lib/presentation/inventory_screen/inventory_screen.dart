import '../../core/app_export.dart';
import './inventory_model.dart' show InventoryItem, StockStatus;
import './widgets/inventory_filter_bar_widget.dart';
import './widgets/inventory_item_card_widget.dart';
import './widgets/inventory_stats_widget.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _navIndex = 1;
  String _selectedCamp = 'الكل';
  String _selectedCategory = 'الكل';
  String _selectedStatus = 'الكل';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _camps = ['الكل', 'مخيم 25', 'مخيم 26'];
  static const List<String> _categories = [
    'الكل',
    'أدوية',
    'مستلزمات جراحية',
    'مستلزمات طبية',
  ];

  // Full inventory data from Excel file
  static final List<InventoryItem> _allItems = [
    InventoryItem(
      id: 1,
      name: 'بريدنيزولون قطرة',
      category: 'أدوية',
      unit: 'قطر',
      price: 0,
      stockByCamp: {'مخيم 25': 45, 'مخيم 26': 30},
      consumedByCamp: {'مخيم 25': 60, 'مخيم 26': 40},
      requiredForWork: {'مخيم 25': 50, 'مخيم 26': 50},
      requiredToBuy: {'مخيم 25': 5, 'مخيم 26': 20},
    ),
    InventoryItem(
      id: 2,
      name: 'دوامكس قطرة',
      category: 'أدوية',
      unit: 'قطر',
      price: 1060,
      stockByCamp: {'مخيم 25': 120, 'مخيم 26': 85},
      consumedByCamp: {'مخيم 25': 290, 'مخيم 26': 200},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 290, 'مخيم 26': 325},
    ),
    InventoryItem(
      id: 3,
      name: 'توبكسون قطرة',
      category: 'أدوية',
      unit: 'قطر',
      price: 1000,
      stockByCamp: {'مخيم 25': 95, 'مخيم 26': 70},
      consumedByCamp: {'مخيم 25': 315, 'مخيم 26': 220},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 315, 'مخيم 26': 340},
    ),
    InventoryItem(
      id: 4,
      name: 'تي مايسين بلس قطرة',
      category: 'أدوية',
      unit: 'قطر',
      price: 850,
      stockByCamp: {'مخيم 25': 110, 'مخيم 26': 60},
      consumedByCamp: {'مخيم 25': 300, 'مخيم 26': 210},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 300, 'مخيم 26': 350},
    ),
    InventoryItem(
      id: 5,
      name: 'سيبروفلوكساسين',
      category: 'أدوية',
      unit: 'باكت',
      price: 370,
      stockByCamp: {'مخيم 25': 130, 'مخيم 26': 90},
      consumedByCamp: {'مخيم 25': 280, 'مخيم 26': 200},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 280, 'مخيم 26': 320},
    ),
    InventoryItem(
      id: 6,
      name: 'برامول اكسترا',
      category: 'أدوية',
      unit: 'شريط',
      price: 200,
      stockByCamp: {'مخيم 25': 40, 'مخيم 26': 25},
      consumedByCamp: {'مخيم 25': 60, 'مخيم 26': 45},
      requiredForWork: {'مخيم 25': 100, 'مخيم 26': 100},
      requiredToBuy: {'مخيم 25': 60, 'مخيم 26': 75},
    ),
    InventoryItem(
      id: 7,
      name: 'تروفين قطرة',
      category: 'أدوية',
      unit: 'قطر',
      price: 1500,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 8,
      name: 'سيدامكس',
      category: 'أدوية',
      unit: 'باكت',
      price: 900,
      stockByCamp: {'مخيم 25': 6, 'مخيم 26': 3},
      consumedByCamp: {'مخيم 25': 9, 'مخيم 26': 6},
      requiredForWork: {'مخيم 25': 15, 'مخيم 26': 15},
      requiredToBuy: {'مخيم 25': 9, 'مخيم 26': 12},
    ),
    InventoryItem(
      id: 9,
      name: 'ليدوكائين 2%',
      category: 'أدوية',
      unit: 'فيال',
      price: 1400,
      stockByCamp: {'مخيم 25': 25, 'مخيم 26': 18},
      consumedByCamp: {'مخيم 25': 45, 'مخيم 26': 30},
      requiredForWork: {'مخيم 25': 70, 'مخيم 26': 70},
      requiredToBuy: {'مخيم 25': 45, 'مخيم 26': 52},
    ),
    InventoryItem(
      id: 10,
      name: 'جنتاميسين',
      category: 'أدوية',
      unit: 'باكت',
      price: 70,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 3},
      consumedByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      requiredForWork: {'مخيم 25': 12, 'مخيم 26': 12},
      requiredToBuy: {'مخيم 25': 8, 'مخيم 26': 9},
    ),
    InventoryItem(
      id: 11,
      name: 'ديكساميثازون',
      category: 'أدوية',
      unit: 'باكت',
      price: 60,
      stockByCamp: {'مخيم 25': 5, 'مخيم 26': 3},
      consumedByCamp: {'مخيم 25': 7, 'مخيم 26': 5},
      requiredForWork: {'مخيم 25': 12, 'مخيم 26': 12},
      requiredToBuy: {'مخيم 25': 7, 'مخيم 26': 9},
    ),
    InventoryItem(
      id: 12,
      name: 'رنجر لاكتات',
      category: 'أدوية',
      unit: 'حبة',
      price: 480,
      stockByCamp: {'مخيم 25': 35, 'مخيم 26': 20},
      consumedByCamp: {'مخيم 25': 55, 'مخيم 26': 35},
      requiredForWork: {'مخيم 25': 90, 'مخيم 26': 90},
      requiredToBuy: {'مخيم 25': 55, 'مخيم 26': 70},
    ),
    InventoryItem(
      id: 13,
      name: 'أدرنالين',
      category: 'أدوية',
      unit: 'امبولة',
      price: 200,
      stockByCamp: {'مخيم 25': 20, 'مخيم 26': 15},
      consumedByCamp: {'مخيم 25': 30, 'مخيم 26': 20},
      requiredForWork: {'مخيم 25': 50, 'مخيم 26': 50},
      requiredToBuy: {'مخيم 25': 30, 'مخيم 26': 35},
    ),
    InventoryItem(
      id: 14,
      name: 'الفاكورت',
      category: 'أدوية',
      unit: 'فيال',
      price: 0,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 15,
      name: 'كرباكول',
      category: 'أدوية',
      unit: 'فيال',
      price: 2000,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 16,
      name: 'عدسات أمامية',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 2500,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 15, 'مخيم 26': 10},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 17,
      name: 'عدسات خلفية',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 1800,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 20, 'مخيم 26': 12},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 18,
      name: 'عدسات مرنة',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 5300,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 10, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 19,
      name: 'محلول عدسات',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 1600,
      stockByCamp: {'مخيم 25': 120, 'مخيم 26': 80},
      consumedByCamp: {'مخيم 25': 180, 'مخيم 26': 120},
      requiredForWork: {'مخيم 25': 300, 'مخيم 26': 300},
      requiredToBuy: {'مخيم 25': 180, 'مخيم 26': 220},
    ),
    InventoryItem(
      id: 20,
      name: 'خيوط 10/0',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 3000,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 21,
      name: 'خيوط 8/0',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 3000,
      stockByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      consumedByCamp: {'مخيم 25': 9, 'مخيم 26': 6},
      requiredForWork: {'مخيم 25': 15, 'مخيم 26': 15},
      requiredToBuy: {'مخيم 25': 9, 'مخيم 26': 11},
    ),
    InventoryItem(
      id: 22,
      name: 'خيوط 4/0',
      category: 'مستلزمات جراحية',
      unit: 'باكت',
      price: 1350,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 23,
      name: 'صبغة بلو',
      category: 'مستلزمات جراحية',
      unit: 'فيال',
      price: 2000,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 24,
      name: 'كريسنت',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 1500,
      stockByCamp: {'مخيم 25': 40, 'مخيم 26': 25},
      consumedByCamp: {'مخيم 25': 60, 'مخيم 26': 40},
      requiredForWork: {'مخيم 25': 100, 'مخيم 26': 100},
      requiredToBuy: {'مخيم 25': 60, 'مخيم 26': 75},
    ),
    InventoryItem(
      id: 25,
      name: 'كراتوم',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 1500,
      stockByCamp: {'مخيم 25': 38, 'مخيم 26': 22},
      consumedByCamp: {'مخيم 25': 62, 'مخيم 26': 42},
      requiredForWork: {'مخيم 25': 100, 'مخيم 26': 100},
      requiredToBuy: {'مخيم 25': 62, 'مخيم 26': 78},
    ),
    InventoryItem(
      id: 26,
      name: 'كيراتوم ماني',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 1500,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 4, 'مخيم 26': 3},
      requiredForWork: {'مخيم 25': 6, 'مخيم 26': 6},
      requiredToBuy: {'مخيم 25': 4, 'مخيم 26': 5},
    ),
    InventoryItem(
      id: 27,
      name: 'لانسيت',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 1500,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 28,
      name: 'لانسيت ماني',
      category: 'مستلزمات جراحية',
      unit: 'حبة',
      price: 0,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 4, 'مخيم 26': 3},
      requiredForWork: {'مخيم 25': 6, 'مخيم 26': 6},
      requiredToBuy: {'مخيم 25': 4, 'مخيم 26': 5},
    ),
    InventoryItem(
      id: 29,
      name: 'مشارط رقم 15',
      category: 'مستلزمات جراحية',
      unit: 'باكت',
      price: 2500,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 5, 'مخيم 26': 3},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 30,
      name: 'دراب عين معقم',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 800,
      stockByCamp: {'مخيم 25': 160, 'مخيم 26': 100},
      consumedByCamp: {'مخيم 25': 260, 'مخيم 26': 180},
      requiredForWork: {'مخيم 25': 420, 'مخيم 26': 420},
      requiredToBuy: {'مخيم 25': 260, 'مخيم 26': 320},
    ),
    InventoryItem(
      id: 31,
      name: 'محاليل مخبرية',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 914,
      stockByCamp: {'مخيم 25': 170, 'مخيم 26': 110},
      consumedByCamp: {'مخيم 25': 260, 'مخيم 26': 180},
      requiredForWork: {'مخيم 25': 430, 'مخيم 26': 430},
      requiredToBuy: {'مخيم 25': 260, 'مخيم 26': 320},
    ),
    InventoryItem(
      id: 32,
      name: '1 سي سي',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 1700,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 33,
      name: '5 سي سي',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 1700,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 34,
      name: '10 سي سي',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 3500,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      requiredForWork: {'مخيم 25': 5, 'مخيم 26': 5},
      requiredToBuy: {'مخيم 25': 3, 'مخيم 26': 4},
    ),
    InventoryItem(
      id: 35,
      name: 'جونتي رقم 7',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 7800,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 36,
      name: 'جونتي رقم 7.5',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 7800,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 37,
      name: 'جونتي لاتكس',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 2500,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      requiredForWork: {'مخيم 25': 5, 'مخيم 26': 5},
      requiredToBuy: {'مخيم 25': 3, 'مخيم 26': 4},
    ),
    InventoryItem(
      id: 38,
      name: 'قاون معقم',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 800,
      stockByCamp: {'مخيم 25': 24, 'مخيم 26': 15},
      consumedByCamp: {'مخيم 25': 36, 'مخيم 26': 24},
      requiredForWork: {'مخيم 25': 60, 'مخيم 26': 60},
      requiredToBuy: {'مخيم 25': 36, 'مخيم 26': 45},
    ),
    InventoryItem(
      id: 39,
      name: 'قاون مرضى',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 250,
      stockByCamp: {'مخيم 25': 160, 'مخيم 26': 100},
      consumedByCamp: {'مخيم 25': 250, 'مخيم 26': 170},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 250, 'مخيم 26': 310},
    ),
    InventoryItem(
      id: 40,
      name: 'غطاء عين',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 1500,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 41,
      name: 'كمامة فم سفري',
      category: 'مستلزمات طبية',
      unit: 'باكت',
      price: 500,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 8},
    ),
    InventoryItem(
      id: 42,
      name: 'أسبرت معقم',
      category: 'مستلزمات طبية',
      unit: 'دبة',
      price: 7500,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 4, 'مخيم 26': 4},
      requiredToBuy: {'مخيم 25': 2, 'مخيم 26': 3},
    ),
    InventoryItem(
      id: 43,
      name: 'ديتول معقم',
      category: 'مستلزمات طبية',
      unit: 'دبة',
      price: 2500,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 44,
      name: 'بوفدين أيودين معقم',
      category: 'مستلزمات طبية',
      unit: 'دبة',
      price: 11000,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 4, 'مخيم 26': 4},
      requiredToBuy: {'مخيم 25': 2, 'مخيم 26': 3},
    ),
    InventoryItem(
      id: 45,
      name: 'سايدكس معقم',
      category: 'مستلزمات طبية',
      unit: 'لتر',
      price: 3000,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 1, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 1, 'مخيم 26': 1},
      requiredToBuy: {'مخيم 25': 1, 'مخيم 26': 1},
    ),
    InventoryItem(
      id: 46,
      name: 'فورمالين',
      category: 'مستلزمات طبية',
      unit: 'لتر',
      price: 8000,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      requiredForWork: {'مخيم 25': 5, 'مخيم 26': 5},
      requiredToBuy: {'مخيم 25': 3, 'مخيم 26': 4},
    ),
    InventoryItem(
      id: 47,
      name: 'ماء مقطر',
      category: 'مستلزمات طبية',
      unit: 'دبة',
      price: 800,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 4, 'مخيم 26': 4},
      requiredToBuy: {'مخيم 25': 2, 'مخيم 26': 3},
    ),
    InventoryItem(
      id: 48,
      name: 'شاش مربع',
      category: 'مستلزمات طبية',
      unit: 'شدة',
      price: 1000,
      stockByCamp: {'مخيم 25': 16, 'مخيم 26': 10},
      consumedByCamp: {'مخيم 25': 24, 'مخيم 26': 16},
      requiredForWork: {'مخيم 25': 40, 'مخيم 26': 40},
      requiredToBuy: {'مخيم 25': 24, 'مخيم 26': 30},
    ),
    InventoryItem(
      id: 49,
      name: 'غطاء رأس',
      category: 'مستلزمات طبية',
      unit: 'شدة',
      price: 600,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      requiredForWork: {'مخيم 25': 5, 'مخيم 26': 5},
      requiredToBuy: {'مخيم 25': 3, 'مخيم 26': 4},
    ),
    InventoryItem(
      id: 50,
      name: 'غطاء قدم',
      category: 'مستلزمات طبية',
      unit: 'شدة',
      price: 500,
      stockByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      consumedByCamp: {'مخيم 25': 5, 'مخيم 26': 3},
      requiredForWork: {'مخيم 25': 8, 'مخيم 26': 8},
      requiredToBuy: {'مخيم 25': 5, 'مخيم 26': 6},
    ),
    InventoryItem(
      id: 51,
      name: 'لصقة جراحية',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 200,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 5, 'مخيم 26': 3},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 52,
      name: 'قطن طبي',
      category: 'مستلزمات طبية',
      unit: 'رول',
      price: 2600,
      stockByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      consumedByCamp: {'مخيم 25': 2, 'مخيم 26': 1},
      requiredForWork: {'مخيم 25': 4, 'مخيم 26': 4},
      requiredToBuy: {'مخيم 25': 2, 'مخيم 26': 3},
    ),
    InventoryItem(
      id: 53,
      name: 'نظارات شمسية',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 300,
      stockByCamp: {'مخيم 25': 160, 'مخيم 26': 100},
      consumedByCamp: {'مخيم 25': 250, 'مخيم 26': 170},
      requiredForWork: {'مخيم 25': 410, 'مخيم 26': 410},
      requiredToBuy: {'مخيم 25': 250, 'مخيم 26': 310},
    ),
    InventoryItem(
      id: 54,
      name: 'أعواد أذن',
      category: 'مستلزمات طبية',
      unit: 'علبة',
      price: 200,
      stockByCamp: {'مخيم 25': 8, 'مخيم 26': 5},
      consumedByCamp: {'مخيم 25': 12, 'مخيم 26': 8},
      requiredForWork: {'مخيم 25': 20, 'مخيم 26': 20},
      requiredToBuy: {'مخيم 25': 12, 'مخيم 26': 15},
    ),
    InventoryItem(
      id: 55,
      name: 'كانيولا 24',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 12000,
      stockByCamp: {'مخيم 25': 0, 'مخيم 26': 0},
      consumedByCamp: {'مخيم 25': 3, 'مخيم 26': 2},
      requiredForWork: {'مخيم 25': 0, 'مخيم 26': 0},
      requiredToBuy: {'مخيم 25': 0, 'مخيم 26': 0},
    ),
    InventoryItem(
      id: 56,
      name: 'روول كومبيوتر',
      category: 'مستلزمات طبية',
      unit: 'حبة',
      price: 0,
      stockByCamp: {'مخيم 25': 4, 'مخيم 26': 3},
      consumedByCamp: {'مخيم 25': 6, 'مخيم 26': 4},
      requiredForWork: {'مخيم 25': 10, 'مخيم 26': 10},
      requiredToBuy: {'مخيم 25': 6, 'مخيم 26': 7},
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InventoryItem> get _filteredItems {
    return _allItems.where((item) {
      // Camp filter
      // Category filter
      final matchCategory =
          _selectedCategory == 'الكل' || item.category == _selectedCategory;
      // Status filter
      bool matchStatus = true;
      if (_selectedStatus != 'الكل') {
        final status = item.statusForCamp(_selectedCamp);
        if (_selectedStatus == 'منخفض') matchStatus = status == inventory_model.StockStatus.low;
        if (_selectedStatus == 'نافد') {
          matchStatus = status == inventory_model.StockStatus.empty;
        }
      }
      // Search filter
      final matchSearch =
          _searchQuery.isEmpty ||
          item.name.contains(_searchQuery) ||
          item.category.contains(_searchQuery);

      return matchCategory && matchStatus && matchSearch;
    }).toList();
  }

  int get _lowStockCount => _allItems
      .where((i) => i.statusForCamp(_selectedCamp) == inventory_model.StockStatus.low)
      .length;
  int get _emptyStockCount => _allItems
      .where((i) => i.statusForCamp(_selectedCamp) == inventory_model.StockStatus.empty)
      .length;
  int get _normalCount => _allItems
      .where((i) => i.statusForCamp(_selectedCamp) == inventory_model.StockStatus.normal)
      .length;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final filtered = _filteredItems;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              // Stats bar
              InventoryStatsWidget(
                totalItems: _allItems.length,
                lowStockCount: _lowStockCount,
                emptyStockCount: _emptyStockCount,
                normalCount: _normalCount,
              ),
              const SizedBox(height: 8),
              // Filter bar
              InventoryFilterBarWidget(
                selectedCamp: _selectedCamp,
                selectedCategory: _selectedCategory,
                selectedStatus: _selectedStatus,
                camps: _camps,
                categories: _categories,
                onCampChanged: (v) => setState(() => _selectedCamp = v),
                onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                onStatusChanged: (v) => setState(() => _selectedStatus = v),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن صنف طبي...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.textMuted,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      'عرض ${filtered.length} من ${_allItems.length} صنف',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_lowStockCount > 0 || _emptyStockCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.notifications_active_rounded,
                              color: AppTheme.error,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_lowStockCount + _emptyStockCount} تنبيه مخزون',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Items list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 48,
                              color: AppTheme.textMuted.withAlpha(100),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد أصناف مطابقة',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : isTablet
                    ? _buildTabletGrid(filtered)
                    : _buildPhoneList(filtered),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isTablet
            ? null
            : AppBottomNavigation(
                currentIndex: _navIndex,
                onDestinationSelected: (i) {
                  setState(() => _navIndex = i);
                  navigateByIndex(context, i);
                },
              ),
      ),
    );
  }

  Widget _buildPhoneList(List<InventoryItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InventoryItemCardWidget(
          item: items[index],
          selectedCamp: _selectedCamp,
        );
      },
    );
  }

  Widget _buildTabletGrid(List<InventoryItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InventoryItemCardWidget(
          item: items[index],
          selectedCamp: _selectedCamp,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المخزون الطبي',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${_allItems.length} صنف طبي',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (_lowStockCount > 0 || _emptyStockCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStatus = 'نافد';
                    });
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${_lowStockCount + _emptyStockCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}