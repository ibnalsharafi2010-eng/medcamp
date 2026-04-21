import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'staff_list_widget.dart';

class AddStaffBottomSheetWidget extends StatefulWidget {
  final StaffMember? existing;
  final ValueChanged<Map<String, dynamic>> onSave;

  const AddStaffBottomSheetWidget({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<AddStaffBottomSheetWidget> createState() =>
      _AddStaffBottomSheetWidgetState();
}

class _AddStaffBottomSheetWidgetState extends State<AddStaffBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _daysController = TextEditingController();
  final _dailyRateController = TextEditingController();
  final _paidController = TextEditingController();
  String _selectedSpecialty = 'استشاري عيون';
  bool _isLoading = false;

  static const List<String> _specialties = [
    'استشاري عيون',
    'أخصائي عيون',
    'أخصائي باطنية',
    'طبيب',
    'فني عمليات',
    'مختبرات',
    'تمريض',
    'إداري',
  ];

  static const Map<String, double> _defaultRates = {
    'استشاري عيون': 42850,
    'أخصائي عيون': 30000,
    'أخصائي باطنية': 30000,
    'طبيب': 25000,
    'فني عمليات': 25000,
    'مختبرات': 25000,
    'تمريض': 20000,
    'إداري': 20000,
  };

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final s = widget.existing!;
      _nameController.text = s.name;
      _selectedSpecialty = s.specialty;
      _daysController.text = s.days.toString();
      _dailyRateController.text = s.dailyRate.toStringAsFixed(0);
      _paidController.text = s.paid.toStringAsFixed(0);
    } else {
      _dailyRateController.text = _defaultRates['استشاري عيون']!
          .toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _daysController.dispose();
    _dailyRateController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Replace with Riverpod/Bloc + cloud sync for production
    await Future.delayed(const Duration(milliseconds: 400));
    final map = {
      'id':
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'specialty': _selectedSpecialty,
      'days': int.tryParse(_daysController.text) ?? 0,
      'dailyRate': double.tryParse(_dailyRateController.text) ?? 0.0,
      'paid': double.tryParse(_paidController.text) ?? 0.0,
    };
    if (mounted) {
      widget.onSave(map);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCFD8DC),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.existing != null
                        ? 'تعديل بيانات الموظف'
                        : 'إضافة موظف جديد',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel('الاسم الكامل'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('أدخل الاسم الكامل'),
                    validator: (v) =>
                        v?.trim().isEmpty == true ? 'الاسم مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildFieldLabel('التخصص'),
                  const SizedBox(height: 6),
                  _buildSpecialtyDropdown(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('عدد الأيام'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _daysController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration('0'),
                              validator: (v) =>
                                  v?.trim().isEmpty == true ? 'مطلوب' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('المستحق اليومي'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _dailyRateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration('0'),
                              validator: (v) =>
                                  v?.trim().isEmpty == true ? 'مطلوب' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFieldLabel('المبلغ المصروف'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _paidController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _inputDecoration('0'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.existing != null
                                  ? 'حفظ التعديلات'
                                  : 'إضافة الموظف',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSpecialty,
      decoration: _inputDecoration('اختر التخصص'),
      style: GoogleFonts.ibmPlexSans(fontSize: 14, color: AppTheme.textPrimary),
      items: _specialties.map((s) {
        return DropdownMenuItem(value: s, child: Text(s));
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedSpecialty = val;
            _dailyRateController.text = (_defaultRates[val] ?? 20000)
                .toStringAsFixed(0);
          });
        }
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppTheme.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.ibmPlexSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}
