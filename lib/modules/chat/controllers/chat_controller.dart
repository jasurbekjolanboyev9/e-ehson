// chat_controller.dart
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();

  // Conversation list summary
  var conversations = <Map<String, dynamic>>[].obs;

  // Current conversation messages
  var messages = <MessageModel>[].obs;

  // Search results
  var userSearchResults = <dynamic>[].obs; // UserProfile list
  var familySearchResults = <dynamic>[].obs; // FamilyProfile list

  // Typing indicator (map conversationId -> bool)
  var typing = <String, bool>{}.obs;

  // Current selected conversation
  var currentConversationId = ''.obs;
  var currentConversationTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  void loadConversations() {
    conversations.value = _service.getConversationsSummary();
  }

  void openConversation(String conversationId, {String? title}) {
    currentConversationId.value = conversationId;
    currentConversationTitle.value = title ?? conversationId;
    messages.value = _service.getMessagesForConversation(conversationId);
    // mark as read by admin (simulate)
    _service.markConversationRead(conversationId, 'admin');
    loadConversations();
  }

  void sendMessage({
    required String text,
    required String senderId,
    required String senderName,
  }) {
    final convId = currentConversationId.value.isEmpty
        ? '${senderId}_admin' // default conv id if none selected
        : currentConversationId.value;

    _service.sendMessage(
      conversationId: convId,
      senderId: senderId,
      senderName: senderName,
      text: text,
    );
    messages.value = _service.getMessagesForConversation(convId);
    loadConversations();
  }

  void editMessage(String messageId, String newText) {
    _service.editMessage(messageId, newText);
    if (currentConversationId.isNotEmpty) {
      messages.value =
          _service.getMessagesForConversation(currentConversationId.value);
    }
    loadConversations();
  }

  void deleteMessage(String messageId) {
    _service.deleteMessage(messageId);
    if (currentConversationId.isNotEmpty) {
      messages.value =
          _service.getMessagesForConversation(currentConversationId.value);
    }
    loadConversations();
  }

  void searchUsers(String q) {
    if (q.trim().isEmpty) {
      userSearchResults.clear();
      return;
    }
    userSearchResults.value = _service.searchUsers(q);
  }

  void searchFamilies(String q) {
    if (q.trim().isEmpty) {
      familySearchResults.clear();
      return;
    }
    familySearchResults.value = _service.searchFamilies(q);
  }

  // Simulate typing indicator
  void setTyping(String conversationId, bool isTyping) {
    typing[conversationId] = isTyping;
    typing.refresh();
  }
}
