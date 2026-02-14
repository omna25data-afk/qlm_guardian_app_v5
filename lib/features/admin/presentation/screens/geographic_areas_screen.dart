import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_area_model.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/services/geographic_area_service.dart';

final rootAreasProvider = FutureProvider<List<AdminAreaModel>>((ref) async {
  final service = ref.read(geographicAreaServiceProvider);
  return service.getAreas();
});

final childrenAreasProvider = FutureProvider.family<List<AdminAreaModel>, int>((
  ref,
  parentId,
) async {
  final service = ref.read(geographicAreaServiceProvider);
  return service.getAreas(parentId: parentId);
});

class GeographicAreasScreen extends ConsumerWidget {
  const GeographicAreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootAreasAsync = ref.watch(rootAreasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المناطق الجغرافية'), centerTitle: true),
      body: rootAreasAsync.when(
        data: (areas) => ListView.builder(
          itemCount: areas.length,
          itemBuilder: (context, index) {
            return AreaExpansionTile(area: areas[index]);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class AreaExpansionTile extends ConsumerWidget {
  final AdminAreaModel area;

  const AreaExpansionTile({super.key, required this.area});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      leading: Text(
        area.icon.isNotEmpty ? area.icon : _getDefaultIcon(area.level),
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(
        area.name,
        style: TextStyle(
          color: _hexToColor(area.color),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('${area.type} - تابعة لـ ${area.parentName ?? '-'}'),
      children: [
        Consumer(
          builder: (context, ref, child) {
            final childrenAsync = ref.watch(childrenAreasProvider(area.id));

            return childrenAsync.when(
              data: (children) {
                if (children.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('لا توجد مناطق فرعية'),
                  );
                }
                return Column(
                  children: children
                      .map((childArea) => AreaExpansionTile(area: childArea))
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Error loading children: $err'),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getDefaultIcon(int level) {
    switch (level) {
      case 1:
        return '🏛️'; // Governorate
      case 2:
        return '🏢'; // Directorate
      case 3:
        return '🏘️'; // Isolation
      case 4:
        return '🏡'; // Village
      case 5:
        return '🏠'; // Locality
      default:
        return '📍';
    }
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
