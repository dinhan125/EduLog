import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String receiverId;
  final String title;
  final String body;
  final String type;
  final String groupId;
  final bool isRead;
  final Timestamp createdAt;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.title,
    required this.body,
    required this.type,
    required this.groupId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      receiverId: json['receiverId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      groupId: json['groupId'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'title': title,
      'body': body,
      'type': type,
      'groupId': groupId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
