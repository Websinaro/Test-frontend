class OfficialAlert {
  final int id;
  final String title;
  final String message;
  final String severity;
  final String? district;
  final String createdTime;
  final String? expiresTime;

  const OfficialAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    this.district,
    required this.createdTime,
    this.expiresTime,
  });

  factory OfficialAlert.fromJson(Map<String, dynamic> json) {
    return OfficialAlert(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      severity: (json['severity'] ?? 'orange').toString(),
      district: json['district']?.toString(),
      createdTime: (json['created_time'] ?? '').toString(),
      expiresTime: json['expires_time']?.toString(),
    );
  }
}