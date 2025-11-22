import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type;
  final bool isRead;
  final String message;
  final DateTime createdAt;

  NotificationModel({required this.type,required this.isRead,required this.message,required this.createdAt, required this.id});

  NotificationModel copyWith({String? id, String? type, bool? isRead, String? message, DateTime? createdAt}) 
    => NotificationModel(
      type: type ?? this.type, 
      isRead: isRead ?? this.isRead, 
      message: message ?? this.message, 
      createdAt: createdAt ?? this.createdAt, 
      id: id ?? this.id
    );

  Map<String, dynamic> toMap() => {
    'type': type,
    'isRead': isRead,
    'message': message,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory NotificationModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    Timestamp createdAt = data['createdAt'] as Timestamp;

    return NotificationModel(
      id: snap.id,
      type: data['type'] as String,
      isRead: data['isRead'] as bool,
      message: data['message'] as String,
      createdAt: createdAt.toDate(),
    );
  }
}