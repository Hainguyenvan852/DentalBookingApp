import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String notificationId;
  final String type;
  final bool isRead;
  final String message;
  final DateTime createdAt;

  Notification({required this.type,required this.isRead,required this.message,required this.createdAt, required this.notificationId});

  Map<String, dynamic> toMap() => {
    'type': type,
    'isRead': isRead,
    'message': message,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory Notification.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    Timestamp createdAt = data['createdAt'] as Timestamp;

    return Notification(
      notificationId: snap.id,
      type: data['type'] as String,
      isRead: data['isRead'] as bool,
      message: data['message'] as String,
      createdAt: createdAt.toDate(),
    );
  }
}