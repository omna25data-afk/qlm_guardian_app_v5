import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_area_model.dart';
import '../../data/models/admin_guardian_model.dart';
import '../providers/admin_dashboard_provider.dart';

class AddEditGuardianScreen extends ConsumerStatefulWidget {
  final AdminGuardianModel? guardian;

  const AddEditGuardianScreen({super.key, this.guardian});

  @override
  ConsumerState<AddEditGuardianScreen> createState() =>
      _AddEditGuardianScreenState();
}

class _AddEditGuardianScreenState extends ConsumerState<AddEditGuardianScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // --- Controllers ---

  // 1. Basic Info
  final _serialNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _grandfatherNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _greatGrandfatherNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _homePhoneController = TextEditingController();
  DateTime? _birthDate;

  // 2. Identity Info
  String _proofType = 'بطاقة شخصية';
  final _proofNumberController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _expiryDate;

  // 3. Professional Info
  final _qualificationController = TextEditingController();
  final _jobController = TextEditingController();
  final _workplaceController = TextEditingController();
  final _experienceNotesController = TextEditingController();

  // 4. Ministerial & License
  final _ministerialNumController = TextEditingController();
  DateTime? _ministerialDate;
  final _licenseNumController = TextEditingController();
  DateTime? _licenseIssueDate;
  DateTime? _licenseExpiryDate;

  // 5. Profession Card
  final _cardNumController = TextEditingController();
  DateTime? _cardIssueDate;
  DateTime? _cardExpiryDate;

  // 6. Geographic Area Selection
  AdminAreaModel? _selectedMainDistrict;
  List<AdminAreaModel> _selectedVillages = [];
  List<AdminAreaModel> _selectedLocalities = [];

  // 7. Status & Notes
  String _employmentStatus = 'على رأس العمل';
  DateTime? _stopDate;
  final _stopReasonController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.guardian != null) {
      _loadGuardianData();
    }
  }

  void _loadGuardianData() {
    final g = widget.guardian!;
    _serialNumberController.text = g.serialNumber;
    _firstNameController.text = g.firstName ?? '';
    _fatherNameController.text = g.fatherName ?? '';
    _grandfatherNameController.text = g.grandfatherName ?? '';
    _familyNameController.text = g.familyName ?? '';
    _greatGrandfatherNameController.text = g.greatGrandfatherName ?? '';
    _birthPlaceController.text = g.birthPlace ?? '';
    if (g.phone != null) _phoneController.text = g.phone!;
    _homePhoneController.text = g.homePhone ?? '';
    if (g.birthDate != null) _birthDate = DateTime.tryParse(g.birthDate!);

    _proofType = g.proofType ?? 'بطاقة شخصية';
    _proofNumberController.text = g.proofNumber ?? '';
    _issuingAuthorityController.text = g.issuingAuthority ?? '';
    if (g.issueDate != null) {
      _issueDate = DateTime.tryParse(g.issueDate!);
    }
    if (g.expiryDate != null) {
      _expiryDate = DateTime.tryParse(g.expiryDate!);
    }

    _qualificationController.text = g.qualification ?? '';
    _jobController.text = g.job ?? '';
    _workplaceController.text = g.workplace ?? '';
    _experienceNotesController.text = g.experienceNotes ?? '';

    _ministerialNumController.text = g.ministerialDecisionNumber ?? '';
    if (g.ministerialDecisionDate != null) {
      _ministerialDate = DateTime.tryParse(g.ministerialDecisionDate!);
    }
    _licenseNumController.text = g.licenseNumber ?? '';
    if (g.licenseIssueDate != null) {
      _licenseIssueDate = DateTime.tryParse(g.licenseIssueDate!);
    }
    if (g.licenseExpiryDate != null) {
      _licenseExpiryDate = DateTime.tryParse(g.licenseExpiryDate!);
    }

    _cardNumController.text = g.professionCardNumber ?? '';
    if (g.professionCardIssueDate != null) {
      _cardIssueDate = DateTime.tryParse(g.professionCardIssueDate!);
    }
    if (g.professionCardExpiryDate != null) {
      _cardExpiryDate = DateTime.tryParse(g.professionCardExpiryDate!);
    }

    _employmentStatus = g.employmentStatus ?? 'على رأس العمل';
    if (g.stopDate != null) {
      _stopDate = DateTime.tryParse(g.stopDate!);
    }
    _stopReasonController.text = g.stopReason ?? '';
    _notesController.text = g.notes ?? '';
  }

  @override
  void dispose() {
    _serialNumberController.dispose();
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _familyNameController.dispose();
    _greatGrandfatherNameController.dispose();
    _birthPlaceController.dispose();
    _phoneController.dispose();
    _homePhoneController.dispose();
    _proofNumberController.dispose();
    _issuingAuthorityController.dispose();
    _qualificationController.dispose();
    _jobController.dispose();
    _workplaceController.dispose();
    _experienceNotesController.dispose();
    _ministerialNumController.dispose();
    _licenseNumController.dispose();
    _cardNumController.dispose();
    _stopReasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  void _openAreaSelection(String type, bool multi) {
    String? parentId;
    if (type == 'قرية') {
      if (_selectedMainDistrict == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'يرجى اختيار العزلة أولاً',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        );
        return;
      }
      parentId = _selectedMainDistrict!.id.toString();
    } else if (type == 'محل') {
      if (_selectedVillages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'يرجى اختيار قرية واحدة على الأقل',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        );
        return;
      }
      parentId = _selectedVillages.first.id.toString();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AreaSelectionSheet(
        type: type,
        multi: multi,
        currentSelection: type == 'عزلة'
            ? (_selectedMainDistrict != null ? [_selectedMainDistrict!] : [])
            : (type == 'قرية' ? _selectedVillages : _selectedLocalities),
        parentId: parentId,
        onSelected: (List<AdminAreaModel> items) {
          setState(() {
            if (type == 'عزلة') {
              if (_selectedMainDistrict?.id !=
                  (items.isNotEmpty ? items.first.id : null)) {
                _selectedVillages = [];
                _selectedLocalities = [];
              }
              _selectedMainDistrict = items.isNotEmpty ? items.first : null;
            } else if (type == 'قرية') {
              _selectedVillages = items;
            } else if (type == 'محل') {
              _selectedLocalities = items;
            }
          });
        },
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final Map<String, dynamic> data = {
        'serial_number': _serialNumberController.text,
        'first_name': _firstNameController.text,
        'father_name': _fatherNameController.text,
        'grandfather_name': _grandfatherNameController.text,
        'family_name': _familyNameController.text,
        'great_grandfather_name': _greatGrandfatherNameController.text,
        'birth_place': _birthPlaceController.text,
        'phone': _phoneController.text, // Changed from phone_number to phone
        'home_phone': _homePhoneController.text,
        'proof_type': _proofType,
        'proof_number': _proofNumberController.text,
        'issuing_authority': _issuingAuthorityController.text,
        'qualification': _qualificationController.text,
        'job': _jobController.text,
        'workplace': _workplaceController.text,
        'experience_notes': _experienceNotesController.text,
        'ministerial_decision_number': _ministerialNumController.text,
        'license_number': _licenseNumController.text,
        'profession_card_number': _cardNumController.text,
        'employment_status': _employmentStatus,
        'stop_reason': _stopReasonController.text,
        'notes': _notesController.text,
      };

      if (_birthDate != null) data['birth_date'] = _formatDate(_birthDate!);
      if (_issueDate != null) data['issue_date'] = _formatDate(_issueDate!);
      if (_expiryDate != null) data['expiry_date'] = _formatDate(_expiryDate!);
      if (_ministerialDate != null) {
        data['ministerial_decision_date'] = _formatDate(_ministerialDate!);
      }
      if (_licenseIssueDate != null) {
        data['license_issue_date'] = _formatDate(_licenseIssueDate!);
      }
      if (_licenseExpiryDate != null) {
        data['license_expiry_date'] = _formatDate(_licenseExpiryDate!);
      }
      if (_cardIssueDate != null) {
        data['profession_card_issue_date'] = _formatDate(_cardIssueDate!);
      }
      if (_cardExpiryDate != null) {
        data['profession_card_expiry_date'] = _formatDate(_cardExpiryDate!);
      }
      if (_stopDate != null) data['stop_date'] = _formatDate(_stopDate!);

      if (_selectedMainDistrict != null) {
        data['main_district_id'] = _selectedMainDistrict!.id.toString();
      }
      if (_selectedVillages.isNotEmpty) {
        data['village_ids'] = _selectedVillages.map((e) => e.id).toList();
      }
      if (_selectedLocalities.isNotEmpty) {
        data['locality_ids'] = _selectedLocalities.map((e) => e.id).toList();
      }

      if (widget.guardian == null) {
        await repo.createGuardian(data, imagePath: _selectedImage?.path);
      } else {
        await repo.updateGuardian(
          widget.guardian!.id,
          data,
          imagePath: _selectedImage?.path,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم الحفظ بنجاح',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: $e',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController c,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: type,
        style: GoogleFonts.tajawal(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.tajawal(
            color: Colors.grey[600],
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: required
            ? (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null
            : null,
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onSelect,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: InkWell(
        onTap: () async {
          final d = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            locale: const Locale('ar', 'SA'),
          );
          if (d != null) onSelect(d);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.tajawal(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date != null ? _formatDate(date) : 'اختر التاريخ',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: date != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: date != null ? Colors.black87 : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  List<Step> get _steps => [
    Step(
      title: const Text('المعلومات الشخصية'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.guardian?.photoUrl != null
                            ? NetworkImage(widget.guardian!.photoUrl!)
                                  as ImageProvider
                            : null),
                  child:
                      (_selectedImage == null &&
                          widget.guardian?.photoUrl == null)
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('الرقم التسلسلي', Icons.numbers),
          _buildTextField(
            _serialNumberController,
            'الرقم التسلسلي *',
            Icons.tag,
            required: true,
          ),

          _buildSectionTitle('الاسم الكامل', Icons.badge),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _firstNameController,
                  'الاسم الأول *',
                  Icons.person_outline,
                  required: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  _fatherNameController,
                  'اسم الأب *',
                  Icons.person_outline,
                  required: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _grandfatherNameController,
                  'اسم الجد *',
                  Icons.person_outline,
                  required: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  _familyNameController,
                  'اللقب *',
                  Icons.people_outline,
                  required: true,
                ),
              ),
            ],
          ),
          _buildTextField(
            _greatGrandfatherNameController,
            'الجد الكبير',
            Icons.person_outline,
          ),

          const SizedBox(height: 10),
          _buildSectionTitle('بيانات الميلاد والاتصال', Icons.contact_mail),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  'تاريخ الميلاد *',
                  _birthDate,
                  (d) => setState(() => _birthDate = d),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  _birthPlaceController,
                  'مكان الميلاد *',
                  Icons.place,
                  required: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _phoneController,
                  'الجوال *',
                  Icons.phone_android,
                  type: TextInputType.phone,
                  required: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  _homePhoneController,
                  'المنزل',
                  Icons.phone,
                  type: TextInputType.phone,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      title: const Text('الهوية'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _proofType,
            decoration: InputDecoration(
              labelText: 'نوع الإثبات',
              prefixIcon: const Icon(Icons.assignment_ind),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            items: const [
              DropdownMenuItem(
                value: 'بطاقة شخصية',
                child: Text('بطاقة شخصية'),
              ),
              DropdownMenuItem(value: 'جواز سفر', child: Text('جواز سفر')),
              DropdownMenuItem(
                value: 'بطاقة عسكرية',
                child: Text('بطاقة عسكرية'),
              ),
              DropdownMenuItem(
                value: 'بطاقة عائلية',
                child: Text('بطاقة عائلية'),
              ),
            ],
            onChanged: (val) => setState(() => _proofType = val!),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _proofNumberController,
            'رقم الإثبات *',
            Icons.numbers,
            required: true,
          ),
          _buildTextField(
            _issuingAuthorityController,
            'جهة الإصدار *',
            Icons.account_balance,
            required: true,
          ),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker('تاريخ الإصدار', _issueDate, (d) {
                  setState(() {
                    _issueDate = d;
                    _expiryDate = DateTime(d.year + 10, d.month, d.day);
                  });
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDatePicker(
                  'تاريخ الانتهاء',
                  _expiryDate,
                  (d) => setState(() => _expiryDate = d),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      title: const Text('المهنة'),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          _buildTextField(
            _qualificationController,
            'المؤهل العلمي',
            Icons.school,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _jobController,
                  'الوظيفة الحالية',
                  Icons.work,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  _workplaceController,
                  'جهة العمل',
                  Icons.business,
                ),
              ),
            ],
          ),
          _buildTextField(
            _experienceNotesController,
            'ملاحظات الخبرة',
            Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    ),
    Step(
      title: const Text('الرخصة'),
      isActive: _currentStep >= 3,
      state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('القرار الوزاري', Icons.gavel),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _ministerialNumController,
                  'رقم القرار',
                  Icons.numbers,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDatePicker(
                  'تاريخ القرار',
                  _ministerialDate,
                  (d) => setState(() => _ministerialDate = d),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSectionTitle('ترخيص المزاولة', Icons.card_membership),
          _buildTextField(_licenseNumController, 'رقم الترخيص', Icons.badge),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker('تاريخ الإصدار', _licenseIssueDate, (
                  d,
                ) {
                  setState(() {
                    _licenseIssueDate = d;
                    _licenseExpiryDate = DateTime(d.year + 3, d.month, d.day);
                  });
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDatePicker(
                  'تاريخ الانتهاء',
                  _licenseExpiryDate,
                  (d) => setState(() => _licenseExpiryDate = d),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSectionTitle('بطاقة المهنة', Icons.credit_card),
          _buildTextField(_cardNumController, 'رقم البطاقة', Icons.numbers),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker('تاريخ الإصدار', _cardIssueDate, (d) {
                  setState(() {
                    _cardIssueDate = d;
                    _cardExpiryDate = DateTime(d.year + 1, d.month, d.day);
                  });
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDatePicker(
                  'تاريخ الانتهاء',
                  _cardExpiryDate,
                  (d) => setState(() => _cardExpiryDate = d),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      title: const Text('المناطق'),
      isActive: _currentStep >= 4,
      state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          _buildAreaCard(
            'عزلة الاختصاص الرئيسية',
            _selectedMainDistrict?.name ?? 'اضغط للاختيار',
            Icons.location_city,
            Colors.blue,
            () => _openAreaSelection('عزلة', false),
            isSelected: _selectedMainDistrict != null,
          ),
          const SizedBox(height: 12),
          _buildAreaCard(
            'القرى التابعة',
            _selectedVillages.isEmpty
                ? 'اضغط لاختيار القرى'
                : '${_selectedVillages.length} قرية مختارة',
            Icons.holiday_village,
            Colors.green,
            () => _openAreaSelection('قرية', true),
            isSelected: _selectedVillages.isNotEmpty,
          ),
          const SizedBox(height: 12),
          _buildAreaCard(
            'المحلات',
            _selectedLocalities.isEmpty
                ? 'اضغط لاختيار المحلات'
                : '${_selectedLocalities.length} محل مختار',
            Icons.store_mall_directory,
            Colors.orange,
            () => _openAreaSelection('محل', true),
            isSelected: _selectedLocalities.isNotEmpty,
          ),
        ],
      ),
    ),
    Step(
      title: const Text('الحالة'),
      isActive: _currentStep >= 5,
      state: _currentStep > 5 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _employmentStatus,
            decoration: InputDecoration(
              labelText: 'الحالة الوظيفية',
              prefixIcon: Icon(
                Icons.info_outline,
                color: _employmentStatus == 'على رأس العمل'
                    ? Colors.green
                    : Colors.red,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            items: const [
              DropdownMenuItem(
                value: 'على رأس العمل',
                child: Text(
                  'على رأس العمل',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'متوقف عن العمل',
                child: Text(
                  'متوقف عن العمل',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            onChanged: (val) => setState(() => _employmentStatus = val!),
          ),
          if (_employmentStatus == 'متوقف عن العمل') ...[
            const SizedBox(height: 16),
            _buildDatePicker(
              'تاريخ التوقف',
              _stopDate,
              (d) => setState(() => _stopDate = d),
            ),
            _buildTextField(
              _stopReasonController,
              'سبب التوقف',
              Icons.warning,
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 16),
          _buildTextField(
            _notesController,
            'ملاحظات إضافية',
            Icons.feed,
            maxLines: 3,
          ),
        ],
      ),
    ),
  ];

  Widget _buildAreaCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isSelected = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: color, width: 1.5)
            : BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.tajawal(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.guardian != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'تعديل بيانات الأمين' : 'إضافة أمين جديد',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          elevation: 0,
          onStepTapped: (index) => setState(() => _currentStep = index),
          onStepContinue: () {
            if (_currentStep < _steps.length - 1) {
              setState(() => _currentStep += 1);
            } else {
              _save();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (ctx, details) {
            final isLastStep = _currentStep == _steps.length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isLastStep ? 'حفظ البيانات' : 'التالي',
                              style: GoogleFonts.tajawal(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'السابق',
                          style: GoogleFonts.tajawal(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: _steps,
        ),
      ),
    );
  }
}

class _AreaSelectionSheet extends ConsumerStatefulWidget {
  final String type;
  final bool multi;
  final List<AdminAreaModel> currentSelection;
  final Function(List<AdminAreaModel>) onSelected;
  final String? parentId;

  const _AreaSelectionSheet({
    required this.type,
    required this.multi,
    required this.currentSelection,
    required this.onSelected,
    this.parentId,
  });

  @override
  ConsumerState<_AreaSelectionSheet> createState() =>
      _AreaSelectionSheetState();
}

class _AreaSelectionSheetState extends ConsumerState<_AreaSelectionSheet> {
  List<AdminAreaModel> _items = [];
  List<AdminAreaModel> _selected = [];
  bool _loading = false;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.currentSelection);
    _fetch();
  }

  void _fetch({String? query}) async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final items = await repo.getAreas(
        type: widget.type,
        searchQuery: query,
        parentId: widget.parentId,
      );
      if (mounted) setState(() => _items = items);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearch(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _fetch(query: val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'اختر ${widget.type}',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'بحث عن ${widget.type}...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: _onSearch,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: _loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _items.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('لا توجد نتائج'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    separatorBuilder: (c, i) =>
                        Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (ctx, i) {
                      final item = _items[i];
                      final isSelected = _selected.any((s) => s.id == item.id);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        title: Text(
                          item.name,
                          style: GoogleFonts.tajawal(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : Colors.grey[100],
                          child: Icon(
                            isSelected
                                ? Icons.check
                                : Icons.location_on_outlined,
                            color: isSelected ? Colors.white : Colors.grey,
                            size: 20,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.multi) {
                              if (isSelected) {
                                _selected.removeWhere((s) => s.id == item.id);
                              } else {
                                _selected.add(item);
                              }
                            } else {
                              _selected = [item];
                              widget.onSelected(_selected);
                              Navigator.pop(context);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          if (widget.multi)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSelected(_selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'تأكيد (${_selected.length})',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
