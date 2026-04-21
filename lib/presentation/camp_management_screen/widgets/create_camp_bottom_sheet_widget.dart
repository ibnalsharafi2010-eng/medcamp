import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'camp_card_widget.dart';

class CreateCampBottomSheetWidget extends StatefulWidget {
  final int nextCampNumber;
  final CampModel? existingCamp;
  final ValueChanged<Map<String, dynamic>> onSave;

  const CreateCampBottomSheetWidget({
    super.key,
    required this.nextCampNumber,
    this.existingCamp,
    required this.onSave,
  });

  @override
  State<CreateCampBottomSheetWidget> createState() =>
      _CreateCampBottomSheetWidgetState();
}

class _CreateCampBottomSheetWidgetState
    extends State<CreateCampBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController;
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;
  String _selectedStatus = 'pending';
  bool _isLoading = false;

  static const List<Map<String, String>> _statusOptions = [
    {'value': 'pending', 'label': 'معلّق'},
    {'value': 'active', 'label': 'نشط'},
    {'value': 'completed', 'label': 'مكتمل'},
  ];

  static const List<String> _yemenGovernorates = [
    'أمانة العاصمة',
    'صنعاء',
    'عدن',
    'تعز',
    'الحديدة',
    'إب',
    'حجة',
    'ذمار',
    'البيضاء',
    'لحج',
    'أبين',
    'شبوة',
    'مأرب',
    'الجوف',
    'صعدة',
    'عمران',
    'المهرة',
    'حضرموت',
    'سقطرى',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existingCamp;
    _numberController = TextEditingController(
      text: e != null ? e.number.toString() : widget.nextCampNumber.toString(),
    );
    _nameController = TextEditingController(
      text: e != null
          ? e.name
          : 'مخيم العيون الحر رقم ${widget.nextCampNumber}',
    );
    _locationController = TextEditingController(text: e?.location ?? '');
    _dateController = TextEditingController(
      text: e?.date ?? _formatDate(DateTime.now()),
    );
    _selectedStatus = e != null ? e.status.name : 'pending';
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateController.text = _formatDate(picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Replace with Riverpod/Bloc + Firestore for production
    await Future.delayed(const Duration(milliseconds: 400));
    final campNum =
        int.tryParse(_numberController.text) ?? widget.nextCampNumber;
    final map = {
      'id':
          widget.existingCamp?.id ??
          'camp_${DateTime.now().millisecondsSinceEpoch}',
      'number': campNum,
      'name': _nameController.text.trim(),
      'date': _dateController.text.trim(),
      'location': _locationController.text.trim(),
      'status': _selectedStatus,
      'totalItems': widget.existingCamp?.totalItems ?? 0,
      'lowStockItems': widget.existingCamp?.lowStockItems ?? 0,
      'emptyStockItems': widget.existingCamp?.emptyStockItems ?? 0,
      'totalConsumptionValue':
          widget.existingCamp?.totalConsumptionValue ?? 0.0,
      'totalPurchasesValue': widget.existingCamp?.totalPurchasesValue ?? 0.0,
      'staffCount': widget.existingCamp?.staffCount ?? 0,
      'stockProgress': widget.existingCamp?.stockProgress ?? 0.0,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.existingCamp != null
                            ? 'تعديل بيانات المخيم'
                            : 'إنشاء مخيم جديد',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'سيتم إنشاء مخيم مستقل بنفس قائمة الأصناف وتنسيق البيانات',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('رقم المخيم'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _numberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                              decoration: _dec('25'),
                              validator: (v) =>
                                  v?.trim().isEmpty == true ? 'مطلوب' : null,
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  _nameController.text =
                                      'مخيم العيون الحر رقم $val';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('اسم المخيم'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _nameController,
                              decoration: _dec('مخيم العيون الحر رقم 25'),
                              validator: (v) =>
                                  v?.trim().isEmpty == true ? 'مطلوب' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _label('الموقع / المحافظة'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _yemenGovernorates.contains(_locationController.text)
                        ? _locationController.text
                        : null,
                    hint: Text(
                      'اختر المحافظة',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    decoration: _dec(''),
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                    items: _yemenGovernorates.map((g) {
                      return DropdownMenuItem(value: g, child: Text(g));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        _locationController.text = val;
                      }
                    },
                    validator: (v) => v == null ? 'اختر المحافظة' : null,
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('تاريخ المخيم'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _pickDate,
                              decoration: _dec('YYYY-MM-DD').copyWith(
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: AppTheme.primary,
                                ),
                              ),
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
                            _label('الحالة'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              decoration: _dec(''),
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 14,
                                color: AppTheme.textPrimary,
                              ),
                              items: _statusOptions.map((opt) {
                                return DropdownMenuItem(
                                  value: opt['value'],
                                  child: Text(opt['label']!),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedStatus = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryContainer),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'سيتم نسخ قائمة الأصناف الكاملة (349 صنفاً) إلى هذا المخيم تلقائياً بنفس التنسيق',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
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
                              widget.existingCamp != null
                                  ? 'حفظ التعديلات'
                                  : 'إنشاء المخيم',
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

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }

  InputDecoration _dec(String hint) {
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: GoogleFonts.ibmPlexSans(
        fontSize: 13,
        color: AppTheme.textMuted,
      ),
    );
  }
}
