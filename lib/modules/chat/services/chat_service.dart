// chat_service.dart
import '../models/message_model.dart';

class UserProfile {
  final String id;
  final String name;
  final String? avatar;
  final bool online;

  UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    this.online = false,
  });
}

class FamilyProfile {
  final String id;
  final String name;
  final String address;
  final String description;
  final String contact;

  FamilyProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.contact,
  });
}

/// ChatService - lokal (in-memory) xizmat.
/// Keyinchalik uni backendga almashtirish oson.
class ChatService {
  final List<MessageModel> _messages = [];
  final List<UserProfile> _users = [];
  final List<FamilyProfile> _families = [];

  ChatService() {
    _seedData();
  }

  void _seedData() {
    // Demo foydalanuvchilar
    _users.addAll([
      UserProfile(id: 'u1', name: 'Ali', avatar: null, online: true),
      UserProfile(id: 'u2', name: 'Vali', avatar: null, online: false),
      UserProfile(id: 'u3', name: 'Madina', avatar: null, online: true),
      UserProfile(
          id: 'admin', name: 'e-Ehson Admin', avatar: null, online: true),
    ]);

    // Demo oilalar / ehsonga muhtojlar
    _families.addAll([
      FamilyProfile(
        id: 'f1',
        name: "Rustamovlar oilasi",
        address: "Toshkent, Chilonzor",
        description: "4 bolali, hozir oziq-ovqatdan muhtoj",
        contact: "+998901234567",
      ),
      FamilyProfile(
        id: 'f2',
        name: "Karimovlar oilasi",
        address: "Namangan, Markaz",
        description: "Bitta yetim bola, shifobaxsh dori kerak",
        contact: "+998909876543",
      ),
    ]);

    // Demo xabarlar (konversatsiyalar: conversationId = "u1_admin", "u2_admin")
    _messages.addAll([
      MessageModel(
        id: 'm1',
        conversationId: 'u1_admin',
        senderId: 'u1',
        senderName: 'Ali',
        text: 'Salom! Yordam kerakmi?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
        isRead: true,
      ),
      MessageModel(
        id: 'm2',
        conversationId: 'u1_admin',
        senderId: 'admin',
        senderName: 'e-Ehson Admin',
        text: 'Ha, qanday yordam bera olamiz?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
        isRead: true,
      ),
      MessageModel(
        id: 'm3',
        conversationId: 'u2_admin',
        senderId: 'u2',
        senderName: 'Vali',
        text: 'Salom, men ro‘yxatdan o‘tmoqchiman',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
    ]);
  }

  // --- Users & families ---
  List<UserProfile> getAllUsers() => List.unmodifiable(_users);
  List<FamilyProfile> getAllFamilies() => List.unmodifiable(_families);

  List<UserProfile> searchUsers(String q) {
    final qq = q.toLowerCase();
    return _users.where((u) => u.name.toLowerCase().contains(qq)).toList();
  }

  List<FamilyProfile> searchFamilies(String q) {
    final qq = q.toLowerCase();
    return _families
        .where((f) =>
            f.name.toLowerCase().contains(qq) ||
            f.address.toLowerCase().contains(qq) ||
            f.description.toLowerCase().contains(qq))
        .toList();
  }

  // --- Messages API ---
  List<MessageModel> getMessagesForConversation(String conversationId) {
    final msgs = _messages
        .where((m) => m.conversationId == conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return msgs;
  }

  void sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final msg = MessageModel(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    _messages.add(msg);
  }

  void editMessage(String messageId, String newText) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      _messages[idx].text = newText;
    }
  }

  void deleteMessage(String messageId) {
    _messages.removeWhere((m) => m.id == messageId);
  }

  // mark as read
  void markConversationRead(String conversationId, String readerId) {
    for (var m in _messages.where((m) => m.conversationId == conversationId)) {
      if (m.senderId != readerId) m.isRead = true;
    }
  }

  // get conversation list summary (conversationId -> last message)
  List<Map<String, dynamic>> getConversationsSummary() {
    // collect unique conversationIds
    final convIds = <String>{};
    for (var m in _messages) convIds.add(m.conversationId);

    final List<Map<String, dynamic>> summary = [];
    for (var id in convIds) {
      final messages = getMessagesForConversation(id);
      if (messages.isEmpty) continue;
      final last = messages.last;
      summary.add({
        'conversationId': id,
        'lastMessage': last,
        'unreadCount':
            messages.where((m) => !m.isRead && m.senderId != 'admin').length,
      });
    }
    // sort by last message time desc
    summary.sort((a, b) {
      final aTime = (a['lastMessage'] as MessageModel).timestamp;
      final bTime = (b['lastMessage'] as MessageModel).timestamp;
      return bTime.compareTo(aTime);
    });
    return summary;
  }
}
