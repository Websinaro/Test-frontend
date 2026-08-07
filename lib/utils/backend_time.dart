/// Backend timestamps (SOS `created_time`, notification `created_time`,
/// auth records, etc.) are stored as naive UTC strings like
/// "2026-08-07 08:39:00.000000" - `datetime.utcnow()` with no timezone
/// suffix.
///
/// Dart's `DateTime.tryParse` treats a string with no offset/`Z` as
/// already local device time, so calling `.toLocal()` on the result is a
/// no-op - the UI ends up showing the raw UTC clock reading (e.g. "8:39
/// AM") instead of the correct local time (e.g. "2:09 PM" in IST,
/// UTC+5:30). This has nothing to do with where the backend is hosted;
/// it's purely a client-side parsing gap.
///
/// This re-interprets the parsed fields as UTC before handing back a
/// proper DateTime, so a subsequent `.toLocal()` actually converts to the
/// device's local timezone.
DateTime? parseBackendUtc(String? iso) {
  if (iso == null || iso.isEmpty) return null;
  final dt = DateTime.tryParse(iso);
  if (dt == null) return null;
  if (dt.isUtc) return dt; // already has an explicit Z/offset - nothing to fix
  return DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
}
