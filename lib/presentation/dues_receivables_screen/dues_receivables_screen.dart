
import '../../core/app_export.dart';
import './widgets/add_staff_bottom_sheet_widget.dart';
import './widgets/dues_summary_cards_widget.dart';
import './widgets/staff_list_widget.dart';

class DuesReceivablesScreen extends StatefulWidget {
  const DuesReceivablesScreen({super.key});

  @override
  State<DuesReceivablesScreen> createState() => _DuesReceivablesScreenState();
}

class _DuesReceivablesScreenState extends State<DuesReceivablesScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _navIndex = 2;
  String _selectedSpecialty = 'الكل';
  late List<Map<String, dynamic>> _staffMaps;
  late List<StaffMember> _staffList;
  final bool _isLoading = false;

  static const List<Map<String, dynamic>> _initialStaffMaps = [
    {
      'id': '1',
      'name': 'د. زكريا راجح ناجي علي',
      'specialty': 'استشاري عيون',
      'days': 7,
      'dailyRate': 42850,
      'paid': 250000,
    },
    {
      'id': '2',
      'name': 'د. هيثم قاسم أحمد حسين',
      'specialty': 'أخصائي عيون',
      'days': 7,
      'dailyRate': 30000,
      'paid': 210000,
    },
    {
      'id': '3',
      'name': 'د. نبيل عبدالله محمد',
      'specialty': 'أخصائي عيون',
      'days': 6,
      'dailyRate': 30000,
      'paid': 150000,
    },
    {
      'id': '4',
      'name': 'د. سامية أحمد الشرعبي',
      'specialty': 'أخصائي باطنية',
      'days': 5,
      'dailyRate': 30000,
      'paid': 150000,
    },
    {
      'id': '5',
      'name': 'د. خالد عبدالرحمن العمري',
      'specialty': 'طبيب',
      'days': 7,
      'dailyRate': 25000,
      'paid': 100000,
    },
    {
      'id': '6',
      'name': 'أ. منى محمد الزيدي',
      'specialty': 'تمريض',
      'days': 7,
      'dailyRate': 20000,
      'paid': 140000,
    },
    {
      'id': '7',
      'name': 'أ. علي حسن المقطري',
      'specialty': 'فني عمليات',
      'days': 7,
      'dailyRate': 25000,
      'paid': 175000,
    },
    {
      'id': '8',
      'name': 'أ. فاطمة صالح الحميدي',
      'specialty': 'مختبرات',
      'days': 6,
      'dailyRate': 25000,
      'paid': 100000,
    },
    {
      'id': '9',
      'name': 'أ. محمد أمين الوصابي',
      'specialty': 'إداري',
      'days': 8,
      'dailyRate': 20000,
      'paid': 160000,
    },
    {
      'id': '10',
      'name': 'أ. رنا عبدالكريم السقاف',
      'specialty': 'تمريض',
      'days': 5,
      'dailyRate': 15000,
      'paid': 50000,
    },
    {
      'id': '11',
      'name': 'د. يوسف علي البدوي',
      'specialty': 'استشاري عيون',
      'days': 4,
      'dailyRate': 42850,
      'paid': 171400,
    },
    {
      'id': '12',
      'name': 'أ. حسام الدين محمد',
      'specialty': 'فني عمليات',
      'days': 7,
      'dailyRate': 25000,
      'paid': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _staffMaps = List<Map<String, dynamic>>.from(_initialStaffMaps);
    _staffList = _staffMaps.map(StaffMember.fromMap).toList();
  }

  List<String> get _specialties {
    final specialties = _staffList.map((s) => s.specialty).toSet().toList();
    return ['الكل', ...specialties];
  }

  List<StaffMember> get _filteredStaff {
    if (_selectedSpecialty == 'الكل') return _staffList;
    return _staffList.where((s) => s.specialty == _selectedSpecialty).toList();
  }

  double get _totalEntitlements =>
      _staffList.fold(0.0, (sum, s) => sum + s.total);
  double get _totalPaid => _staffList.fold(0.0, (sum, s) => sum + s.paid);
  double get _totalRemaining => _totalEntitlements - _totalPaid;

  void _showAddStaffSheet({StaffMember? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddStaffBottomSheetWidget(
        existing: existing,
        onSave: (map) {
          setState(() {
            // TODO: Replace with Riverpod/Bloc for production
            if (existing != null) {
              final idx = _staffList.indexWhere((s) => s.id == existing.id);
              if (idx >= 0) {
                _staffList[idx] = StaffMember.fromMap(map);
              }
            } else {
              _staffList.add(StaffMember.fromMap(map));
            }
          });
        },
      ),
    );
  }

  void _deleteStaff(String id) {
    setState(() {
      // TODO: Replace with Riverpod/Bloc for production
      _staffList.removeWhere((s) => s.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddStaffSheet(),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('إضافة موظف'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
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
              Icons.payments_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'المستحقات والرواتب',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.download_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
          tooltip: 'تصدير تقرير',
          onPressed: () {
            // TODO: Implement PDF export for production
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('جاري إعداد التقرير...'),
                backgroundColor: AppTheme.primary,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPhoneLayout() {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () async {
        // TODO: Replace with actual cloud sync for production
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DuesSummaryCardsWidget(
                totalEntitlements: _totalEntitlements,
                totalPaid: _totalPaid,
                totalRemaining: _totalRemaining,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildSpecialtyFilter()),
          SliverToBoxAdapter(child: _buildListHeader()),
          if (_filteredStaff.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.people_outline_rounded,
                title: 'لا يوجد كادر طبي',
                description: 'أضف أعضاء الكادر الطبي المشاركين في المخيم',
                actionLabel: 'إضافة موظف',
                onAction: () => _showAddStaffSheet(),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final staff = _filteredStaff[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: StaffListItemWidget(
                    staff: staff,
                    index: index,
                    onEdit: () => _showAddStaffSheet(existing: staff),
                    onDelete: () => _deleteStaff(staff.id),
                  ),
                );
              }, childCount: _filteredStaff.length),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        AppNavigationRail(
          currentIndex: _navIndex,
          onDestinationSelected: (i) {
            setState(() => _navIndex = i);
            navigateByIndex(context, i);
          },
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _buildPhoneLayout()),
      ],
    );
  }

  Widget _buildSpecialtyFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _specialties.length,
          itemBuilder: (context, index) {
            final specialty = _specialties[index];
            final isSelected = specialty == _selectedSpecialty;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text(specialty),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedSpecialty = specialty);
                },
                selectedColor: AppTheme.primaryContainer,
                backgroundColor: AppTheme.surface,
                labelStyle: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primary
                        : const Color(0xFFCFD8DC),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الكادر الطبي (${_filteredStaff.length})',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            'مخيم العيون رقم 25',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
