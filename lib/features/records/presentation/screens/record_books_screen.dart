import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/record_book.dart';
import '../providers/records_provider.dart';
import 'record_book_entries_screen.dart';

class RecordBooksScreen extends ConsumerWidget {
  const RecordBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesState = ref.watch(recordBookTypesProvider);
    final booksState = ref.watch(recordBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السجلات',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
      ),
      body: typesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(ref, error.toString()),
        data: (types) {
          return booksState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildError(ref, error.toString()),
            data: (books) {
              return RefreshIndicator(
                onRefresh: () async {
                  // ignore: unused_result
                  ref.refresh(recordBookTypesProvider);
                  // ignore: unused_result
                  ref.refresh(recordBooksProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final typeMap = types[index];
                    final typeId = typeMap['id'] as int;
                    final typeName = typeMap['name'] as String;
                    final contractTypeId = typeMap['contract_type_id'] as int?;

                    // Frontend grouping vs backend grouping handling
                    // Match by contract_type_id since backend groups by it, or fallback to name/recordBookTypeId
                    final matchingBooks = books.where((b) {
                      if (contractTypeId != null &&
                          b.contractTypeId == contractTypeId)
                        return true;
                      if (b.recordBookTypeId == typeId) return true;
                      if (b.contractType.isNotEmpty &&
                          typeName.contains(b.contractType))
                        return true;
                      return false;
                    }).toList();

                    return _buildTypeCard(
                      context,
                      typeName,
                      contractTypeId ?? typeId,
                      matchingBooks,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildError(WidgetRef ref, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'خطأ في التحميل',
            style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // ignore: unused_result
              ref.refresh(recordBookTypesProvider);
              // ignore: unused_result
              ref.refresh(recordBooksProvider);
            },
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    String typeName,
    int contractTypeId,
    List<RecordBook> books,
  ) {
    // Determine counts from the first matching book which holds aggregate totals
    int totalEntries = 0;
    int activeBooks = 0;

    if (books.isNotEmpty) {
      // Backend already grouped these into `books` where each is an aggregate
      totalEntries = books.fold<int>(0, (sum, b) => sum + b.totalEntries);
      activeBooks = books.fold<int>(0, (sum, b) => sum + b.notebooksCount);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordBookNotebooksScreen(
                contractTypeId: contractTypeId,
                contractTypeName: typeName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF006400).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.book,
                      color: Color(0xFF006400),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$activeBooks دفتر • $totalEntries قيد',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Notebooks screen for a specific contract type
class RecordBookNotebooksScreen extends ConsumerStatefulWidget {
  final int contractTypeId;
  final String contractTypeName;

  const RecordBookNotebooksScreen({
    super.key,
    required this.contractTypeId,
    required this.contractTypeName,
  });

  @override
  ConsumerState<RecordBookNotebooksScreen> createState() =>
      _RecordBookNotebooksScreenState();
}

class _RecordBookNotebooksScreenState
    extends ConsumerState<RecordBookNotebooksScreen> {
  bool _isLoading = true;
  List<RecordBook> _notebooks = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotebooks();
  }

  Future<void> _fetchNotebooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = ref.read(recordsRepositoryProvider);
      final notebooks = await repository.getNotebooks(widget.contractTypeId);
      if (mounted) {
        setState(() {
          _notebooks = notebooks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contractTypeName,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('خطأ: $_error', style: TextStyle(fontFamily: 'Tajawal')),
                  ElevatedButton(
                    onPressed: _fetchNotebooks,
                    child: Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            )
          : _notebooks.isEmpty
          ? Center(
              child: Text(
                'لا توجد دفاتر لهذا السجل',
                style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchNotebooks,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notebooks.length,
                itemBuilder: (ctx, i) => _buildNotebookCard(_notebooks[i]),
              ),
            ),
    );
  }

  Widget _buildNotebookCard(RecordBook book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordBookEntriesScreen(
                contractTypeId: book.contractTypeId ?? widget.contractTypeId,
                contractTypeName: widget.contractTypeName,
                bookNumber: book.bookNumber,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${book.bookNumber}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006400),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الدفتر رقم ${book.bookNumber}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'عدد القيود والمحررات: ${book.entriesCount}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showInfoDialog(book),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow(
                Icons.account_balance,
                'رقم السجل بالوزارة',
                book.ministryRecordNumber ?? 'غير محدد',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.description,
                'القالب المستخدم',
                book.templateName ?? 'غير محدد',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.calendar_today,
                'سنة الصرف',
                '${book.issuanceYear} هـ',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.history, 'السنوات', book.years.join('، ')),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(RecordBook notebook) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'معلومات السجل',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(
              Icons.book,
              'رقم الدفتر المرجعي',
              '${notebook.bookNumber}',
            ),
            _buildInfoItem(
              Icons.list_alt,
              'إجمالي عدد القيود',
              '${notebook.entriesCount}',
            ),
            _buildInfoItem(
              Icons.account_balance,
              'رقم سجل وزارة العدل',
              notebook.ministryRecordNumber ?? 'غير محدد',
            ),
            _buildInfoItem(
              Icons.description,
              'قالب السجل المعتمد',
              notebook.templateName ?? 'غير محدد',
            ),
            _buildInfoItem(
              Icons.calendar_today,
              'سنة الصرف للهيئة',
              '${notebook.issuanceYear} هـ',
            ),
            _buildInfoItem(
              Icons.history,
              'سنوات العمل والقيود',
              notebook.years.join('، '),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF006400)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontFamily: 'Tajawal',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }
}
