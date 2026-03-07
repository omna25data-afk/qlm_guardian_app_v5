import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/utils/arabic_pluralization.dart';
import '../../../../../../../features/records/presentation/providers/records_provider.dart';
import '../widgets/guardian_record_book_card.dart';
import '../../entries/screens/guardian_record_book_entries_screen.dart';

class GuardianRecordBooksScreen extends ConsumerStatefulWidget {
  final int contractTypeId;
  final String contractTypeName;

  const GuardianRecordBooksScreen({
    super.key,
    required this.contractTypeId,
    required this.contractTypeName,
  });

  @override
  ConsumerState<GuardianRecordBooksScreen> createState() =>
      _GuardianRecordBooksScreenState();
}

class _GuardianRecordBooksScreenState
    extends ConsumerState<GuardianRecordBooksScreen> {
  // Sort direction: true = newest first (descending), false = oldest first (ascending)
  bool _sortDescending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.contractTypeName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF006400),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            tooltip: 'ترتيب حسب سنة الصرف',
            onPressed: () {
              setState(() {
                _sortDescending = !_sortDescending;
              });
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final booksAsync = ref.watch(
            contractNotebooksProvider(widget.contractTypeId),
          );

          return booksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خطأ: $error',
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  ElevatedButton(
                    onPressed: () => ref.refresh(
                      contractNotebooksProvider(widget.contractTypeId),
                    ),
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ),
            data: (allBooks) {
              // The backend already correctly filters by contractTypeId,
              // we just filter by physical category mapping locally
              final contractNotebooks = allBooks.where((b) {
                return b.category.toLowerCase() == 'guardian_recording';
              }).toList();

              // 2. Sort notebooks by issuance year
              contractNotebooks.sort((a, b) {
                final yearA = a.hijriYear;
                final yearB = b.hijriYear;
                if (_sortDescending) {
                  return yearB.compareTo(yearA);
                } else {
                  return yearA.compareTo(yearB);
                }
              });

              if (contractNotebooks.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد سجلات محفوظة من هذا النوع',
                    style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                  ),
                );
              }

              // 3. Aggregate statistics over these specific physical notebooks
              final totalEntries = contractNotebooks.fold<int>(
                0,
                (sum, book) => sum + book.totalEntries,
              );
              final activeBooks = contractNotebooks
                  .where((b) => b.isActive)
                  .length;

              return Column(
                children: [
                  // Header Card with statistics mapping the physical notebooks
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          Icons.book,
                          'إجمالي السجلات',
                          '${contractNotebooks.length}',
                          Colors.blue,
                        ),
                        _buildStatItem(
                          Icons.check_circle,
                          'سجلات نشطة',
                          '$activeBooks',
                          Colors.green,
                        ),
                        _buildStatItem(
                          Icons.list_alt,
                          'إجمالي القيود',
                          ArabicPluralization.formatEntries(totalEntries),
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Notebooks List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(recordBooksProvider);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: contractNotebooks.length,
                        itemBuilder: (context, index) {
                          final book = contractNotebooks[index];
                          return GuardianRecordBookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GuardianRecordBookEntriesScreen(
                                        contractTypeId: widget.contractTypeId,
                                        contractTypeName:
                                            widget.contractTypeName,
                                        bookNumber: book.bookNumber,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}
