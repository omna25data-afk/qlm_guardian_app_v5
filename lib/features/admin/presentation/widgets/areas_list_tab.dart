import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_areas_provider.dart';
import '../../data/models/admin_area_model.dart';
import '../providers/admin_dashboard_provider.dart';

class AreasListTab extends ConsumerStatefulWidget {
  const AreasListTab({super.key});

  @override
  ConsumerState<AreasListTab> createState() => _AreasListTabState();
}

class _AreasListTabState extends ConsumerState<AreasListTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminAreasProvider.notifier).fetchAreas(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAreasProvider);

    return Column(
      children: [
        // Search Bar (Optional, can add later if needed as per V4)

        // List
        Expanded(
          child: state.isLoading && state.areas.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.error != null && state.areas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(adminAreasProvider.notifier)
                            .fetchAreas(refresh: true),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : state.areas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 60,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد مناطق',
                        style: GoogleFonts.tajawal(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref
                      .read(adminAreasProvider.notifier)
                      .fetchAreas(refresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.areas.length,
                    itemBuilder: (context, index) {
                      return _AreaExpansionTile(
                        area: state.areas[index],
                        level: 1, // Start with Level 1 (Districts/Azla)
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _AreaExpansionTile extends ConsumerStatefulWidget {
  final AdminAreaModel area;
  final int level;

  const _AreaExpansionTile({required this.area, required this.level});

  @override
  ConsumerState<_AreaExpansionTile> createState() => _AreaExpansionTileState();
}

class _AreaExpansionTileState extends ConsumerState<_AreaExpansionTile> {
  List<AdminAreaModel>? _children;
  bool _isLoading = false;

  Future<void> _fetchChildren() async {
    if (_children != null || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(adminRepositoryProvider);
      List<AdminAreaModel> children = [];

      if (widget.level == 1) {
        children = await repository.getVillages(
          parentId: widget.area.id.toString(),
        );
      } else if (widget.level == 2) {
        children = await repository.getLocalities(
          parentId: widget.area.id.toString(),
        );
      }

      if (mounted) {
        setState(() {
          _children = children;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLeaf = widget.level >= 3;

    IconData icon = Icons.map;
    Color color = AppColors.textHint;

    if (widget.level == 1) {
      icon = Icons.location_city;
      color = AppColors.warning;
    } else if (widget.level == 2) {
      icon = Icons.holiday_village;
      color = AppColors.success;
    } else if (widget.level == 3) {
      icon = Icons.home;
      color = AppColors.info;
    }

    if (isLeaf) {
      return ListTile(
        leading: Icon(icon, color: color, size: 20),
        title: Text(widget.area.name, style: GoogleFonts.tajawal(fontSize: 14)),
        dense: true,
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ExpansionTile(
        key: PageStorageKey(widget.area.id),
        leading: Icon(icon, color: color),
        title: Text(
          widget.area.name,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          'ID: ${widget.area.id}',
          style: TextStyle(fontSize: 10, color: AppColors.textHint),
        ),
        onExpansionChanged: (expanded) {
          if (expanded) _fetchChildren();
        },
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_children != null)
            ..._children!.map(
              (child) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _AreaExpansionTile(area: child, level: widget.level + 1),
              ),
            )
          else if (_children != null && _children!.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'لا توجد مناطق تابعة',
                style: GoogleFonts.tajawal(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
