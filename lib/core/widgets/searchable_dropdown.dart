import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String label;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool isLoading;
  final String hint;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.label,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.value,
    this.validator,
    this.isLoading = false,
    this.hint = 'اختر...',
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    final displayLabel = widget.value != null
        ? widget.itemLabelBuilder(widget.value as T)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.isLoading ? null : _showSelectionSheet,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: const TextStyle(fontFamily: 'Tajawal'),
              hintText: widget.hint,
              hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: widget.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_drop_down),
              errorText: widget.validator?.call(widget.value),
            ),
            child: Text(
              displayLabel ?? '',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SelectionSheet<T>(
        items: widget.items,
        label: widget.label,
        itemLabelBuilder: widget.itemLabelBuilder,
        onSelected: (val) {
          widget.onChanged(val);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SelectionSheet<T> extends StatefulWidget {
  final List<T> items;
  final String label;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T> onSelected;

  const _SelectionSheet({
    required this.items,
    required this.label,
    required this.itemLabelBuilder,
    required this.onSelected,
  });

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  late List<T> _filteredItems;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final label = widget.itemLabelBuilder(item).toLowerCase();
          return label.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DraggableScrollableSheet for flexible height
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: 'بحث...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
            const SizedBox(height: 8),

            // List
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(
                            widget.itemLabelBuilder(item),
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                          onTap: () => widget.onSelected(item),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
