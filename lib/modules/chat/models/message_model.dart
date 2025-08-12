// message_model.dart
class MessageModel {
  final String id;
  final String conversationId; // qaysi suhbatga tegishli
  final String senderId;
  final String senderName;
  String text;
  final DateTime timestamp;
  bool isRead;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
}
