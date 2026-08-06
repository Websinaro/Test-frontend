import 'package:flutter/foundation.dart';

import '../models/official_alert.dart';
import '../services/api_service.dart';

class AlertsProvider extends ChangeNotifier {
  final ApiService _api = ApiService.instance;

  List<OfficialAlert> alerts = [];
  bool loading = false;
  String? errorMessage;

  Future<void> refresh() async {
    loading = true;
    notifyListeners();

    try {
      alerts = await _api.fetchAlerts();
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> post({
    required String title,
    required String message,
    required String severity,
    String? district,
    int? expiresInHours,
  }) async {
    await _api.createAlert(
      title: title,
      message: message,
      severity: severity,
      district: district,
      expiresInHours: expiresInHours,
    );
    await refresh();
  }

  Future<void> remove(int id) async {
    await _api.deleteAlert(id);
    alerts = alerts.where((a) => a.id != id).toList();
    notifyListeners();
  }

  void reset() {
    alerts = [];
    loading = false;
    errorMessage = null;
  }
}