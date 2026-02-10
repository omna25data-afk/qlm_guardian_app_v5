/// Resolves conflicts between local and remote data
/// Uses "last write wins" with server priority strategy
class ConflictResolver {
  ConflictResolver();

  /// Resolve conflict between local and remote entry
  /// Returns the winning version's data
  ///
  /// Strategy: Server wins unless local has unsyncable changes
  Map<String, dynamic> resolve({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
    required DateTime? localUpdatedAt,
    required DateTime? remoteUpdatedAt,
  }) {
    // If no remote update time, keep local
    if (remoteUpdatedAt == null) return local;

    // If no local update time, take remote
    if (localUpdatedAt == null) return remote;

    // Server wins in case of conflict (authoritative source)
    if (remoteUpdatedAt.isAfter(localUpdatedAt) ||
        remoteUpdatedAt.isAtSameMomentAs(localUpdatedAt)) {
      return remote;
    }

    // Local is newer — keep local but flag for review
    return _mergeWithLocalPriority(local, remote);
  }

  /// Merge strategy: keep local changes, supplement with remote fields
  /// that are null locally
  Map<String, dynamic> _mergeWithLocalPriority(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final merged = Map<String, dynamic>.from(remote);

    // Local values override remote for non-null fields
    for (final entry in local.entries) {
      if (entry.value != null) {
        merged[entry.key] = entry.value;
      }
    }

    return merged;
  }

  /// Detect if there's a conflict between two records
  bool hasConflict({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
  }) {
    // Compare key fields to detect meaningful differences
    final keysToCheck = [
      'status',
      'subject',
      'content',
      'total_amount',
      'paid_amount',
    ];

    for (final key in keysToCheck) {
      if (local[key] != remote[key]) return true;
    }
    return false;
  }
}
