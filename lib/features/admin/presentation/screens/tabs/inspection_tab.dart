import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/admin_inspection_provider.dart';

/// تبويب فحص وتفتيش السجلات
/// يحتوي 3 أقسام فرعية: فحوصات السجلات، سجلات الأمناء، الإجراءات
class InspectionTab extends ConsumerStatefulWidget {
  const InspectionTab({super.key});

  @override
  ConsumerState<InspectionTab> createState() => _InspectionTabState();
}

class _InspectionTabState extends ConsumerState<InspectionTab> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminInspectionProvider.notifier)
          .fetchInspections(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(adminInspectionProvider);
      if (!state.isLoading && state.hasMore) {
        final notifier = ref.read(adminInspectionProvider.notifier);
        switch (state.activeSection) {
          case 'inspections':
            notifier.fetchInspections();
            break;
          case 'record_books':
            notifier.fetchRecordBooks();
            break;
          case 'procedures':
            notifier.fetchProcedures();
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminInspectionProvider);

    return Column(
      children: [
        // ═══ أقسام فرعية ═══
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'inspections',
                label: Text(
                  'فحوصات السجلات',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                ),
                icon: Icon(Icons.fact_check, size: 18),
              ),
              ButtonSegment(
                value: 'record_books',
                label: Text(
                  'دفاتر السجلات',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                ),
                icon: Icon(Icons.menu_book, size: 18),
              ),
              ButtonSegment(
                value: 'procedures',
                label: Text(
                  'الإجراءات',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                ),
                icon: Icon(Icons.assignment, size: 18),
              ),
            ],
            selected: {state.activeSection},
            onSelectionChanged: (selected) {
              ref
                  .read(adminInspectionProvider.notifier)
                  .setActiveSection(selected.first);
              _searchController.clear();
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.white,
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),

        // ═══ شريط البحث ═══
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: _getSearchHint(state.activeSection),
                    hintStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(adminInspectionProvider.notifier)
                                  .setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                  onChanged: (value) {
                    ref
                        .read(adminInspectionProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.primary),
                  onPressed: () {
                    _showAdvancedFilters(context, state);
                  },
                ),
              ),
            ],
          ),
        ),

        // ═══ المحتوى حسب القسم النشط ═══
        Expanded(child: _buildSectionContent(state)),
      ],
    );
  }

  void _showAdvancedFilters(BuildContext context, AdminInspectionState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'التصفية والفرز المتقدم',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Notice to user, as specific filters per section can be added later as needed
                Expanded(
                  child: Center(
                    child: Text(
                      'أدوات التصفية المتقدمة لـ ${_getSectionName(state.activeSection)} ستتوفر قريباً بناءً على هيكل البيانات المطلوب.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSectionName(String section) {
    switch (section) {
      case 'inspections':
        return 'فحوصات السجلات';
      case 'record_books':
        return 'سجلات الأمناء';
      case 'procedures':
        return 'الإجراءات';
      default:
        return 'القسم المحدد';
    }
  }

  String _getSearchHint(String section) {
    switch (section) {
      case 'inspections':
        return 'بحث في فحوصات السجلات...';
      case 'record_books':
        return 'بحث في سجلات الأمناء...';
      case 'procedures':
        return 'بحث في الإجراءات...';
      default:
        return 'بحث...';
    }
  }

  Widget _buildSectionContent(AdminInspectionState state) {
    // حالة التحميل الأولي
    if (state.isLoading && _getCurrentList(state).isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // حالة الخطأ
    if (state.error != null && _getCurrentList(state).isEmpty) {
      return _buildErrorWidget(state);
    }

    // حالة القائمة الفارغة
    final list = _getCurrentList(state);
    if (list.isEmpty) {
      return _buildEmptyWidget(state.activeSection);
    }

    return RefreshIndicator(
      onRefresh: () async {
        final notifier = ref.read(adminInspectionProvider.notifier);
        switch (state.activeSection) {
          case 'inspections':
            await notifier.fetchInspections(refresh: true);
            break;
          case 'record_books':
            await notifier.fetchRecordBooks(refresh: true);
            break;
          case 'procedures':
            await notifier.fetchProcedures(refresh: true);
            break;
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == list.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          switch (state.activeSection) {
            case 'inspections':
              return _buildInspectionCard(list[index]);
            case 'record_books':
              return _buildRecordBookCard(list[index]);
            case 'procedures':
              return _buildProcedureCard(list[index]);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getCurrentList(AdminInspectionState state) {
    switch (state.activeSection) {
      case 'inspections':
        return state.inspections;
      case 'record_books':
        return state.recordBooks;
      case 'procedures':
        return state.procedures;
      default:
        return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 1. بطاقة فحص سجل (Inspection Card)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildInspectionCard(Map<String, dynamic> ins) {
    final status = ins['status']?.toString() ?? '';
    final statusLabel = ins['status_label']?.toString() ?? status;
    final statusColor = _getStatusColor(status);
    final hasReceived = ins['received_at'] != null;
    final hasReturned = ins['returned_at'] != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showInspectionDetail(ins),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف الأول: الأمين + الحالة
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: statusColor.withValues(alpha: 0.15),
                    child: Icon(Icons.fact_check, color: statusColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ins['guardian_name'] ?? 'غير محدد',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${ins['record_book_name'] ?? ''} - رقم ${ins['book_number'] ?? ''}',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBadge(statusLabel, statusColor),
                ],
              ),

              const SizedBox(height: 10),

              // فترة الفحص + معلومات
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _chipInfo(
                    Icons.calendar_month,
                    '${ins['hijri_year'] ?? '-'}هـ - ${ins['quarter_label'] ?? ''}',
                  ),
                  if (ins['inspection_number'] != null)
                    _chipInfo(Icons.tag, 'فحص رقم ${ins['inspection_number']}'),
                  if (ins['inspector_name'] != null)
                    _chipInfo(Icons.person_search, ins['inspector_name']),
                ],
              ),

              // تواريخ الاستلام/الإرجاع
              if (hasReceived || hasReturned) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (hasReceived)
                      _chipInfo(
                        Icons.download,
                        'استلام: ${ins['received_at_hijri'] ?? ins['received_at']}',
                      ),
                    if (hasReceived && hasReturned) const SizedBox(width: 12),
                    if (hasReturned)
                      _chipInfo(
                        Icons.upload,
                        'إرجاع: ${ins['returned_at_hijri'] ?? ins['returned_at']}',
                      ),
                  ],
                ),
              ],

              // أزرار الإجراءات
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (status == 'draft' || status == 'pending')
                    _actionButton(
                      'استلام السجل',
                      Icons.download,
                      Colors.blue,
                      () => _confirmAction(
                        'استلام السجل',
                        'هل تريد استلام هذا السجل للفحص؟',
                        () => ref
                            .read(adminInspectionProvider.notifier)
                            .receiveInspection(ins['id']),
                      ),
                    ),
                  if (status == 'in_progress' && hasReceived && !hasReturned)
                    _actionButton(
                      'إرجاع السجل',
                      Icons.upload,
                      Colors.orange,
                      () => _confirmAction(
                        'إرجاع السجل',
                        'هل تريد إرجاع هذا السجل للأمين؟',
                        () => ref
                            .read(adminInspectionProvider.notifier)
                            .returnInspection(ins['id']),
                      ),
                    ),
                  if (status == 'in_progress')
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: _actionButton(
                        'إكمال الفحص',
                        Icons.check_circle,
                        Colors.green,
                        () => _confirmAction(
                          'إكمال الفحص',
                          'هل تريد إكمال فحص هذا السجل؟',
                          () => ref
                              .read(adminInspectionProvider.notifier)
                              .completeInspection(ins['id']),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 2. بطاقة سجل أمين (Record Book Card)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildRecordBookCard(Map<String, dynamic> rb) {
    final stats = rb['stats'] as Map<String, dynamic>? ?? {};
    final totalEntries = stats['total_entries'] ?? 0;
    final documented = stats['documented'] ?? 0;
    final pending = stats['pending'] ?? 0;
    final isActive = rb['is_active'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showRecordBookDetail(rb),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.menu_book,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rb['guardian_name'] ?? 'غير محدد',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${rb['name'] ?? ''} - رقم ${rb['book_number'] ?? ''}',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBadge(
                    isActive ? 'نشط' : (rb['status'] ?? 'غير محدد'),
                    isActive ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _chipInfo(
                    Icons.calendar_month,
                    '${rb['hijri_year'] ?? '-'}هـ',
                  ),
                  if (rb['contract_type'] != null)
                    _chipInfo(Icons.description, rb['contract_type']),
                  if (rb['type'] != null) _chipInfo(Icons.category, rb['type']),
                ],
              ),
              const SizedBox(height: 10),
              // إحصائيات
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('إجمالي', totalEntries, Colors.blue),
                    _dividerVertical(),
                    _statItem('موثقة', documented, Colors.green),
                    _dividerVertical(),
                    _statItem('معلقة', pending, Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 3. بطاقة إجراء (Procedure Card)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildProcedureCard(Map<String, dynamic> proc) {
    final typeLabel = proc['procedure_type_label']?.toString() ?? '';
    final typeColor = _getProcedureTypeColor(
      proc['procedure_type']?.toString() ?? '',
    );
    final typeIcon = _getProcedureTypeIcon(
      proc['procedure_type']?.toString() ?? '',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: typeColor.withValues(alpha: 0.15),
                  child: Icon(typeIcon, color: typeColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proc['guardian_name'] ?? 'غير محدد',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${proc['record_book_name'] ?? ''} - رقم ${proc['book_number'] ?? ''}',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBadge(typeLabel, typeColor),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _chipInfo(
                  Icons.calendar_month,
                  '${proc['hijri_year'] ?? '-'}هـ',
                ),
                if (proc['procedure_date_hijri'] != null)
                  _chipInfo(Icons.event, proc['procedure_date_hijri']),
                if (proc['performed_by_name'] != null)
                  _chipInfo(Icons.person, proc['performed_by_name']),
              ],
            ),
            // معلومات الصفحات والقيود
            if (proc['page_range'] != null ||
                proc['constraint_range'] != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  if (proc['page_range'] != null)
                    _chipInfo(Icons.pages, 'ص: ${proc['page_range']}'),
                  if (proc['constraint_range'] != null)
                    _chipInfo(
                      Icons.format_list_numbered,
                      'قيود: ${proc['constraint_range']}',
                    ),
                ],
              ),
            ],
            if (proc['notes'] != null &&
                proc['notes'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                proc['notes'],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Bottom Sheets
  // ═══════════════════════════════════════════════════════════════

  void _showInspectionDetail(Map<String, dynamic> ins) {
    final id = ins['id'];
    if (id == null) return;

    ref.read(adminInspectionProvider.notifier).fetchInspectionDetail(id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _dragHandle(),
              _sheetHeader('تفاصيل الفحص', ins['record_book_name'] ?? ''),
              const Divider(height: 1),
              Expanded(
                child: Consumer(
                  builder: (ctx, ref, _) {
                    final state = ref.watch(adminInspectionProvider);
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final detail = state.selectedInspection;
                    if (detail == null) {
                      return const Center(
                        child: Text(
                          'لا توجد تفاصيل',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      );
                    }
                    return _buildInspectionDetailContent(detail, scrollCtrl);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionDetailContent(
    Map<String, dynamic> detail,
    ScrollController scrollCtrl,
  ) {
    final stats = detail['stats'] as Map<String, dynamic>? ?? {};
    final evaluation = detail['quality_evaluation'] as Map<String, dynamic>?;
    final notes = detail['entry_notes'] as List? ?? [];

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(14),
      children: [
        // ملخص
        _detailSection('معلومات الفحص', [
          _detailRow('الأمين', detail['guardian_name'] ?? '-'),
          _detailRow('السجل', detail['record_book_name'] ?? '-'),
          _detailRow('رقم السجل', detail['book_number']?.toString() ?? '-'),
          _detailRow('نوع العقد', detail['contract_type'] ?? '-'),
          _detailRow(
            'الفترة',
            '${detail['hijri_year'] ?? '-'}هـ - ${detail['quarter_label'] ?? ''}',
          ),
          _detailRow('الحالة', detail['status_label'] ?? '-'),
          _detailRow('المفتش', detail['inspector_name'] ?? '-'),
          if (detail['received_at_hijri'] != null)
            _detailRow('تاريخ الاستلام', detail['received_at_hijri']),
          if (detail['returned_at_hijri'] != null)
            _detailRow('تاريخ الإرجاع', detail['returned_at_hijri']),
        ]),

        const SizedBox(height: 12),

        // إحصائيات
        _detailSection('إحصائيات القيود', [
          Row(
            children: [
              _statCard('إجمالي', stats['total_entries'] ?? 0, Colors.blue),
              const SizedBox(width: 8),
              _statCard(
                'موثقة',
                stats['documented_entries'] ?? 0,
                Colors.green,
              ),
              const SizedBox(width: 8),
              _statCard('غير موثقة', stats['not_documented'] ?? 0, Colors.red),
            ],
          ),
        ]),

        // تقييم الجودة
        if (evaluation != null) ...[
          const SizedBox(height: 12),
          _detailSection(
            'تقييم الجودة (${evaluation['total_score'] ?? 0}/${evaluation['max_score'] ?? 100})',
            [
              _scoreBar('التنظيم', evaluation['organization_score']),
              _scoreBar('الصياغة', evaluation['wording_score']),
              _scoreBar('النماذج الرسمية', evaluation['official_forms_score']),
              _scoreBar(
                'الاختصاص',
                evaluation['territorial_jurisdiction_score'],
              ),
              _scoreBar(
                'اكتمال البيانات',
                evaluation['data_completeness_score'],
              ),
              _scoreBar(
                'تأشيرات التوثيق',
                evaluation['notary_office_annotation_score'],
              ),
              _scoreBar('نظافة السجل', evaluation['record_cleanliness_score']),
              _scoreBar('نص المحرر', evaluation['document_text_score']),
              _scoreBar('المظهر العام', evaluation['appearance_score']),
              _scoreBar('الخط', evaluation['handwriting_score']),
            ],
          ),
        ],

        // ملاحظات الفحص
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          _detailSection('ملاحظات الفحص (${notes.length})', [
            ...notes.map((n) => _noteItem(n as Map<String, dynamic>)),
          ]),
        ],
      ],
    );
  }

  void _showRecordBookDetail(Map<String, dynamic> rb) {
    final id = rb['id'];
    if (id == null) return;

    ref.read(adminInspectionProvider.notifier).fetchRecordBookDetail(id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _dragHandle(),
              _sheetHeader('تفاصيل السجل', rb['name'] ?? ''),
              const Divider(height: 1),
              Expanded(
                child: Consumer(
                  builder: (ctx, ref, _) {
                    final state = ref.watch(adminInspectionProvider);
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final detail = state.selectedRecordBook;
                    if (detail == null) {
                      return const Center(
                        child: Text(
                          'لا توجد تفاصيل',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      );
                    }
                    return _buildRecordBookDetailContent(detail, scrollCtrl);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordBookDetailContent(
    Map<String, dynamic> detail,
    ScrollController scrollCtrl,
  ) {
    final rb = detail['record_book'] as Map<String, dynamic>? ?? detail;
    final entries = detail['entries'] as List? ?? [];
    final violations = detail['violations'] as List? ?? [];
    final stats = detail['stats'] as Map<String, dynamic>? ?? {};

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(14),
      children: [
        _detailSection('معلومات السجل', [
          _detailRow('الأمين', rb['guardian_name'] ?? '-'),
          _detailRow('اسم السجل', rb['name'] ?? '-'),
          _detailRow('رقم السجل', rb['book_number']?.toString() ?? '-'),
          _detailRow('السنة', '${rb['hijri_year'] ?? '-'}هـ'),
          _detailRow('الحالة', rb['status'] ?? '-'),
        ]),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('إجمالي', stats['total_entries'] ?? 0, Colors.blue),
              const SizedBox(width: 6),
              _statCard('مخالفات', stats['violation_entries'] ?? 0, Colors.red),
            ],
          ),
        ],
        if (entries.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'القيود (${entries.length})',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          ...entries.map((e) => _entryTile(e as Map<String, dynamic>)),
        ],
        if (violations.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'المخالفات (${violations.length})',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 6),
          ...violations.map((v) => _violationTile(v as Map<String, dynamic>)),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Shared Widgets
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _chipInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _dividerVertical() =>
      Container(width: 1, height: 28, color: Colors.grey.shade300);

  Widget _statCard(String label, dynamic value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: color),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _dragHandle() => Container(
    margin: const EdgeInsets.only(top: 10),
    width: 36,
    height: 4,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _sheetHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _detailSection(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBar(String label, dynamic score) {
    final val = (score is num) ? score.toDouble() : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: val / 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  val >= 7
                      ? Colors.green
                      : (val >= 4 ? Colors.orange : Colors.red),
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${val.toStringAsFixed(0)}/10',
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _noteItem(Map<String, dynamic> note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note['violation_type'] != null)
            Text(
              note['violation_type'],
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
          if (note['violations_list'] != null)
            ...(note['violations_list'] as List).map(
              (v) => Text(
                '• $v',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          if (note['notes'] != null)
            Text(
              note['notes'],
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _entryTile(Map<String, dynamic> entry) {
    final isDoc = entry['status'] == 'documented';
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isDoc ? Icons.check_circle : Icons.pending,
        color: isDoc ? Colors.green : Colors.orange,
        size: 20,
      ),
      title: Text(
        'قيد ${entry['guardian_entry_number'] ?? entry['serial_number'] ?? '-'}',
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
      ),
      subtitle: entry['contract_type'] != null
          ? Text(
              entry['contract_type'],
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Text(
        isDoc ? 'موثق' : 'معلق',
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11,
          color: isDoc ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  Widget _violationTile(Map<String, dynamic> v) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.warning_amber, color: Colors.red.shade600, size: 20),
      title: Text(
        'قيد ${v['serial_number'] ?? '-'}',
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
      ),
      subtitle: Text(
        v['contract_type'] ?? '',
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(AdminInspectionState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.error ?? '',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: Colors.grey.shade400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              final notifier = ref.read(adminInspectionProvider.notifier);
              switch (state.activeSection) {
                case 'inspections':
                  notifier.fetchInspections(refresh: true);
                  break;
                case 'record_books':
                  notifier.fetchRecordBooks(refresh: true);
                  break;
                case 'procedures':
                  notifier.fetchProcedures(refresh: true);
                  break;
              }
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text(
              'إعادة المحاولة',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String section) {
    final msg =
        {
          'inspections': 'لا توجد فحوصات',
          'record_books': 'لا توجد سجلات',
          'procedures': 'لا توجد إجراءات',
        }[section] ??
        'لا توجد بيانات';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            msg,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAction(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontFamily: 'Tajawal')),
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'approved':
        return AppColors.primary;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getProcedureTypeColor(String type) {
    switch (type) {
      case 'issued':
        return Colors.blue;
      case 'opened':
        return Colors.green;
      case 'closed':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getProcedureTypeIcon(String type) {
    switch (type) {
      case 'issued':
        return Icons.add_circle;
      case 'opened':
        return Icons.lock_open;
      case 'closed':
        return Icons.lock;
      case 'archived':
        return Icons.archive;
      default:
        return Icons.assignment;
    }
  }
}
