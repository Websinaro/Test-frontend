# President Dashboard + Notification Center - Frontend

Signup already had the President toggle + access code field wired to
`ApiService.register(accessCode: ...)`; this just adds the screens and
plumbing the backend needed to actually honor it.

## New screens
- `screens/president/president_dashboard_screen.dart` - district-wise
  citizens / active SOS / active alert counts, plus a live list of active
  SOS emergencies statewide (tap the map icon to open the location in
  OpenStreetMap). Now the president's "Command" tab (index 0 of the bottom
  nav) instead of the weather overview.
- `screens/president/notification_center_screen.dart` - the president's
  CRUD list: create, edit, deactivate/reactivate, delete alerts they've
  sent.
- `screens/president/notification_form_screen.dart` - create/edit form:
  title, message, severity (5-tier, same palette as weather alerts), and
  target (All Kerala vs a specific district).
- `screens/notifications/notification_inbox_screen.dart` - read-only alert
  inbox for citizens (their district's alerts + statewide alerts).
  Reachable via the bell icon on the Weather tab and the "Alerts" tile on
  Profile.

## Other changes
- `providers/notification_provider.dart` - list/create/update/delete state,
  registered in `app.dart`.
- `services/api_service.dart` - `fetchPresidentDashboard`,
  `fetchNotifications`, `createNotification`, `updateNotification`,
  `deleteNotification` (same AES-GCM encrypted-payload pattern as every
  other call).
- `services/push_notification_service.dart` - handles the new
  `admin_alert` FCM data type (foreground + background + tap-to-open),
  alongside the existing `sos_alert` handling.
- `screens/home/home_shell.dart` - president's first tab now shows
  `PresidentDashboardScreen`.
- `screens/home/weather_dashboard_screen.dart` - bell icon for citizens.
- `screens/profile/profile_screen.dart` - "State Command Dashboard" +
  "Notification Center" tiles for presidents; "Alerts" tile for citizens.

No new pubspec dependencies were needed - `url_launcher`, `intl`, and
`provider` were already in use elsewhere in the app.
