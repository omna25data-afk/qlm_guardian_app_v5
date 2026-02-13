import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/record_book.dart';
import '../providers/records_provider.dart';

class RecordBooksScreen extends ConsumerWidget {
  const RecordBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsState = ref.watch(recordBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السجلات',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
      ),
      body: recordsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'خطأ في تحميل السجلات',
                style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.read(recordBooksProvider.notifier).fetchRecordBooks(),
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
        ),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد سجلات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            );
          }

          // Group by contract type
          final grouped = <String, List<RecordBook>>{};
          for (final book in books) {
            final key = book.contractType.isNotEmpty
                ? book.contractType
                : 'غير مصنف';
            grouped.putIfAbsent(key, () => []).add(book);
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(recordBooksProvider.notifier).fetchRecordBooks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final type = grouped.keys.elementAt(index);
                final typeBooks = grouped[type]!;
                return _buildContractTypeCard(context, type, typeBooks);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContractTypeCard(
    BuildContext context,
    String type,
    List<RecordBook> books,
  ) {
    final totalEntries = books.fold<int>(0, (sum, b) => sum + b.totalEntries);
    final activeBooks = books.where((b) => b.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to notebooks for this contract type
          if (books.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecordBookNotebooksScreen(
                  contractTypeId: books.first.contractTypeId ?? books.first.id,
                  contractTypeName: type,
                ),
              ),
            );
          }
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
                          type,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$activeBooks سجل نشط • $totalEntries قيد',
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
              if (books.length > 1) ...[
                const Divider(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: books
                      .take(5)
                      .map(
                        (b) => Chip(
                          label: Text(
                            '${b.hijriYear} هـ',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          backgroundColor: b.isActive
                              ? Colors.green[50]
                              : Colors.grey[100],
                          side: BorderSide(
                            color: b.isActive
                                ? Colors.green
                                : Colors.grey[300]!,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
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
              book.issuanceYear != null
                  ? '${book.issuanceYear} هـ'
                  : 'غير محدد',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.history, 'السنوات', book.years.join('، ')),
          ],
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
              notebook.issuanceYear != null
                  ? '${notebook.issuanceYear} هـ'
                  : 'غير محدد',
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
