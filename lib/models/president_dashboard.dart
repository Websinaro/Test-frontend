class DistrictStat {
  final String district;
  final int registeredUsers;
  final int activeSos;
  final int activeNotifications;

  const DistrictStat({
    required this.district,
    required this.registeredUsers,
    required this.activeSos,
    required this.activeNotifications,
  });

  factory DistrictStat.fromJson(Map<String, dynamic> j) {
    int n(dynamic v) => (v as num?)?.toInt() ?? 0;
    return DistrictStat(
      district: (j['district'] ?? '').toString(),
      registeredUsers: n(j['registered_users']),
      activeSos: n(j['active_sos']),
      activeNotifications: n(j['active_notifications']),
    );
  }
}

class ActiveSosSummary {
  final int id;
  final int userId;
  final String userName;
  final String district;
  final double latitude;
  final double longitude;
  final String? message;
  final String createdTime;

  const ActiveSosSummary({
    required this.id,
    required this.userId,
    required this.userName,
    required this.district,
    required this.latitude,
    required this.longitude,
    this.message,
    required this.createdTime,
  });

  factory ActiveSosSummary.fromJson(Map<String, dynamic> j) {
    double d(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
    return ActiveSosSummary(
      id: j['id'] is int ? j['id'] as int : int.tryParse('${j['id']}') ?? 0,
      userId: j['user_id'] is int ? j['user_id'] as int : int.tryParse('${j['user_id']}') ?? 0,
      userName: (j['user_name'] ?? '').toString(),
      district: (j['district'] ?? '').toString(),
      latitude: d(j['latitude']),
      longitude: d(j['longitude']),
      message: j['message']?.toString(),
      createdTime: (j['created_time'] ?? '').toString(),
    );
  }
}

class PresidentDashboard {
  final int totalUsers;
  final int totalActiveSos;
  final int totalActiveNotifications;
  final List<DistrictStat> districts;
  final List<ActiveSosSummary> activeSosAlerts;

  const PresidentDashboard({
    required this.totalUsers,
    required this.totalActiveSos,
    required this.totalActiveNotifications,
    required this.districts,
    required this.activeSosAlerts,
  });

  factory PresidentDashboard.fromJson(Map<String, dynamic> j) {
    int n(dynamic v) => (v as num?)?.toInt() ?? 0;
    return PresidentDashboard(
      totalUsers: n(j['total_users']),
      totalActiveSos: n(j['total_active_sos']),
      totalActiveNotifications: n(j['total_active_notifications']),
      districts: (j['districts'] as List<dynamic>? ?? [])
          .map((e) => DistrictStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeSosAlerts: (j['active_sos_alerts'] as List<dynamic>? ?? [])
          .map((e) => ActiveSosSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
