class Cache {
  final String key;
  final String value;
  final int expiration;

  Cache({required this.key, required this.value, required this.expiration});

  factory Cache.fromJson(Map<String, dynamic> json) {
    return Cache(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      expiration: json['expiration'] != null
          ? (json['expiration'] is int
                ? json['expiration']
                : int.tryParse(json['expiration'].toString()) ?? 0)
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value, 'expiration': expiration};
  }
}
