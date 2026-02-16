class CacheLock {
  final String key;
  final String owner;
  final int expiration;

  CacheLock({
    required this.key,
    required this.owner,
    required this.expiration,
  });

  factory CacheLock.fromJson(Map<String, dynamic> json) {
    return CacheLock(
      key: json['key'] ?? '',
      owner: json['owner'] ?? '',
      expiration: json['expiration'] != null ? (json['expiration'] is int ? json['expiration'] : int.tryParse(json['expiration'].toString()) ?? 0) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'owner': owner,
      'expiration': expiration,
    };
  }
}
