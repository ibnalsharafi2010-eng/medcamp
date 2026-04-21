
import '../../core/app_export.dart';
import './widgets/camp_card_widget.dart';
import './widgets/camp_stats_header_widget.dart';
import './widgets/create_camp_bottom_sheet_widget.dart';

class CampManagementScreen extends StatefulWidget {
  const CampManagementScreen({super.key});

  @override
  State<CampManagementScreen> createState() => _CampManagementScreenState();
}

class _CampManagementScreenState extends State<CampManagementScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _navIndex = 0;
  String _filterStatus = 'الكل';
  late List<Map<String, dynamic>> _campMaps;
  late List<CampModel> _camps;
  late AnimationController _listAnimController;

  static final List<Map<String, dynamic>> _initialCampMaps = [
    {
      'id': 'camp_25',
      'number': 25,
      'name': 'مخيم العيون الحر رقم 25',
      'date': '2026-04-12',
      'location': 'محافظة إب',
      'status': 'completed',
      'totalItems': 55,
      'lowStockItems': 8,
      'emptyStockItems': 3,
      'totalConsumptionValue': 5618280.0,
      'totalPurchasesValue': 1893610.0,
      'staffCount': 21,
      'stockProgress': 0.62,
    },
    {
      'id': 'camp_26',
      'number': 26,
      'name': 'مخيم العيون الحر رقم 26',
      'date': '2026-04-26',
      'location': 'محافظة تعز',
      'status': 'active',
      'totalItems': 55,
      'lowStockItems': 12,
      'emptyStockItems': 5,
      'totalConsumptionValue': 2140500.0,
      'totalPurchasesValue': 980000.0,
      'staffCount': 18,
      'stockProgress': 0.38,
    },
    {
      'id': 'camp_27',
      'number': 27,
      'name': 'مخيم العيون الحر رقم 27',
      'date': '2026-05-10',
      'location': 'محافظة حجة',
      'status': 'pending',
      'totalItems': 0,
      'lowStockItems': 0,
      'emptyStockItems': 0,
      'totalConsumptionValue': 0.0,
      'totalPurchasesValue': 0.0,
      'staffCount': 0,
      'stockProgress': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _campMaps = List<Map<String, dynamic>>.from(_initialCampMaps);
    _camps = _campMaps.map(CampModel.fromMap).toList();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listAnimController.forward();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  List<CampModel> get _filteredCamps {
    if (_filterStatus == 'الكل') return _camps;
    return _camps.where((c) {
      switch (_filterStatus) {
        case 'نشط':
          return c.status == CampStatus.active;
        case 'مكتمل':
          return c.status == CampStatus.completed;
        case 'معلّق':
          return c.status == CampStatus.pending;
        default:
          return true;
      }
    }).toList();
  }

  int get _activeCamps =>
      _camps.where((c) => c.status == CampStatus.active).length;
  int get _totalLowStock => _camps.fold(0, (sum, c) => sum + c.lowStockItems);
  int get _totalEmptyStock =>
      _camps.fold(0, (sum, c) => sum + c.emptyStockItems);

  void _showCreateCampSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateCampBottomSheetWidget(
        nextCampNumber: _camps.isNotEmpty
            ? _camps.map((c) => c.number).reduce((a, b) => a > b ? a : b) + 1
            : 25,
        onSave: (map) {
          setState(() {
            // TODO: Replace with Riverpod/Bloc + Firestore for production
            _camps.add(CampModel.fromMap(map));
          });
          _listAnimController.reset();
          _listAnimController.forward();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final bool isLargeTablet = MediaQuery.of(context).size.width >= 840;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: isTablet
              ? _buildTabletLayout(isLargeTablet)
              : _buildPhoneLayout(null),
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
          onPressed: _showCreateCampSheet,
          icon: const Icon(Icons.add_rounded),
          label: const Text('مخيم جديد'),
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
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MedCamp',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'إدارة المخيمات الطبية',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.sync_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
          tooltip: 'مزامنة البيانات',
          onPressed: () {
            // TODO: Implement cloud sync for production
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.cloud_done_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تمت المزامنة بنجاح',
                      style: GoogleFonts.ibmPlexSans(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: AppTheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.person_outline_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
              (route) => false,
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildPhoneLayout(double? railWidth) {
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
              child: CampStatsHeaderWidget(
                activeCamps: _activeCamps,
                totalCamps: _camps.length,
                totalLowStock: _totalLowStock,
                totalEmptyStock: _totalEmptyStock,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildFilterRow()),
          SliverToBoxAdapter(child: _buildSectionHeader()),
          if (_filteredCamps.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.medical_services_outlined,
                title: 'لا توجد مخيمات',
                description:
                    'أنشئ مخيمًا طبيًا جديدًا لبدء إدارة المخزون والمستحقات',
                actionLabel: 'إنشاء مخيم',
                onAction: _showCreateCampSheet,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final camp = _filteredCamps[index];
                  return AnimatedBuilder(
                    animation: _listAnimController,
                    builder: (context, child) {
                      final delay = (index * 0.12).clamp(0.0, 0.6);
                      final animValue = Curves.easeOutCubic.transform(
                        ((_listAnimController.value - delay) / (1.0 - delay))
                            .clamp(0.0, 1.0),
                      );
                      return Opacity(
                        opacity: animValue,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - animValue)),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CampCardWidget(
                        camp: camp,
                        onTap: () => _navigateToCampDetail(camp),
                        onEdit: () => _showEditCampSheet(camp),
                      ),
                    ),
                  );
                }, childCount: _filteredCamps.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(bool isLargeTablet) {
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
        Expanded(child: _buildTabletGrid()),
      ],
    );
  }

  Widget _buildTabletGrid() {
    final isLargeTablet = MediaQuery.of(context).size.width >= 840;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CampStatsHeaderWidget(
              activeCamps: _activeCamps,
              totalCamps: _camps.length,
              totalLowStock: _totalLowStock,
              totalEmptyStock: _totalEmptyStock,
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildFilterRow()),
        SliverToBoxAdapter(child: _buildSectionHeader()),
        if (_filteredCamps.isEmpty)
          SliverFillRemaining(
            child: EmptyStateWidget(
              icon: Icons.medical_services_outlined,
              title: 'لا توجد مخيمات',
              description: 'أنشئ مخيمًا طبيًا جديدًا',
              actionLabel: 'إنشاء مخيم',
              onAction: _showCreateCampSheet,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLargeTablet ? 3 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final camp = _filteredCamps[index];
                return CampCardWidget(
                  camp: camp,
                  onTap: () => _navigateToCampDetail(camp),
                  onEdit: () => _showEditCampSheet(camp),
                );
              }, childCount: _filteredCamps.length),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildFilterRow() {
    final filters = ['الكل', 'نشط', 'مكتمل', 'معلّق'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = filter == _filterStatus;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => setState(() => _filterStatus = filter),
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

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'المخيمات (${_filteredCamps.length})',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            'آخر مزامنة: ${_formatTime(DateTime.now())}',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _navigateToCampDetail(CampModel camp) {
    // TODO: Navigate to camp detail screen when generated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح ${camp.name}...'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showEditCampSheet(CampModel camp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateCampBottomSheetWidget(
        nextCampNumber: camp.number,
        existingCamp: camp,
        onSave: (map) {
          setState(() {
            // TODO: Replace with Riverpod/Bloc for production
            final idx = _camps.indexWhere((c) => c.id == camp.id);
            if (idx >= 0) {
              _camps[idx] = CampModel.fromMap(map);
            }
          });
        },
      ),
    );
  }
}
