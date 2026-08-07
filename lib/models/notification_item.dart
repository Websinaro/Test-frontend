/// A president/admin-issued broadcast alert - either targeted at a single
/// district or (when [district] is null) at all of Kerala.
class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String severity; // green | yellow | orange | light_red | dark_red
  final String? district; // null = all Kerala
  final int createdBy;
  final String createdByName;
  final bool active;
  final String createdTime;
  final String updatedTime;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.district,
    required this.createdBy,
    required this.createdByName,
    required this.active,
    required this.createdTime,
    required this.updatedTime,
  });

  bool get isStatewide => district == null;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      severity: (json['severity'] ?? 'orange').toString(),
      district: json['district']?.toString(),
      createdBy: json['created_by'] is int ? json['created_by'] as int : int.tryParse('${json['created_by']}') ?? 0,
      createdByName: (json['created_by_name'] ?? '').toString(),
      active: json['active'] == true,
      createdTime: (json['created_time'] ?? '').toString(),
      updatedTime: (json['updated_time'] ?? '').toString(),
    );
  }
}
