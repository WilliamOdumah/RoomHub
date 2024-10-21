class UserException implements Exception {
  final String message;
  UserException(this.message);
}

class RoomException implements Exception {
  final String message;
  RoomException(this.message);
}

class NotificationException implements Exception {
  final String message;
  NotificationException(this.message);
}
