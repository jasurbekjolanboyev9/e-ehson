// Importlar - kerakli paketlar va kutubxonalar
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart'
    as DioPackage; // Dio uchun alias qo‘shildi, Response konfliktini hal qilish uchun
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// InitialBindings - dastlabki bog'lanishlar va controllerlarni joylash
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService.instance);
    Get.put(AuthController());
    Get.put(CampaignController());
    Get.put(DonationController());
    Get.put(ProfileController());
    Get.put(AdminController());
  }
}

// AdminController - admin paneli uchun controller
class AdminController extends GetxController {
  var pending = <Map<String, dynamic>>[].obs;

  void loadMock() {
    pending.assignAll([
      {'id': 101, 'title': "So'rov 1", 'amount': 50000},
      {'id': 102, 'title': "So'rov 2", 'amount': 120000},
    ]);
  }

  void approve(int id) {
    pending.removeWhere((p) => p['id'] == id);
    Get.snackbar('Admin', 'So\'rov tasdiqlandi: $id');
  }

  void reject(int id) {
    pending.removeWhere((p) => p['id'] == id);
    Get.snackbar('Admin', 'So\'rov rad etildi: $id');
  }
}

// AuthController - autentifikatsiya controlleri
class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var token = RxnString();
  var user = Rxn<Map<String, dynamic>>();

  final _dummyEmail = '1@1.com';
  final _dummyPassword = '111111';

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    if (email == _dummyEmail && password == _dummyPassword) {
      token.value = 'dummy_token_123456';
      user.value = {'name': 'Test User', 'email': email};
      Get.snackbar(
        'success'.tr,
        'tizimga_muvaffaqiyatli_kirdingiz'.tr,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar(
        'error'.tr,
        'email_yoki_parol_notogri'.tr,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
    isLoading.value = false;
  }

  void logout() {
    emailController.clear();
    passwordController.clear();
    token.value = null;
    user.value = null;
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// CampaignController - kampaniyalar controlleri
class CampaignController extends GetxController {
  var campaigns = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await ApiService.instance.get('/api/campaigns');
      campaigns
          .assignAll(List<Map<String, dynamic>>.from(res.data['campaigns']));
    } catch (e) {
      Get.snackbar('Xato', 'Kampaniyalarni olishda xatolik');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? findById(int id) =>
      campaigns.firstWhereOrNull((c) => c['id'] == id);
}

// DonationController - ehson qilish controlleri
class DonationController extends GetxController {
  var amount = 0.0.obs;

  var isLoading = false.obs;
  RxBool get isProcessing => isLoading;

  var donationSuccess = false.obs;

  void setAmount(double value) {
    if (value > 0) {
      amount.value = value;
    }
  }

  Future<void> makeDonation(Map<String, dynamic> campaign) async {
    isLoading.value = true;
    donationSuccess.value = false;

    await Future.delayed(const Duration(seconds: 2));

    if (amount.value > 0) {
      donationSuccess.value = true;
      Get.snackbar(
        "Rahmat!",
        "Siz ${campaign['title'] ?? 'kampaniya'} uchun ${amount.value} so‘m ehson qildingiz.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
      );
    } else {
      Get.snackbar(
        "Xatolik",
        "Ehson miqdorini kiriting",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFFFC7C7),
      );
    }

    isLoading.value = false;
  }
}

// ProfileController - profil controlleri
class ProfileController extends GetxController {
  var profile = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var isDarkMode = false.obs;
  var isBiometricEnabled = false.obs;
  var isTwoFactorEnabled = false.obs;
  var isNotificationsEnabled = false.obs;
  var totalDonations = 0.obs;
  var donationAmount = 0.0.obs;
  var userRank = 'Bronze'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadSettings();
    simulateDonationUpdates();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      profile.value = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'image': null,
        'totalDonations': 5,
        'totalAmount': 500.0,
        'rank': 'Silver Donor',
      };
      totalDonations.value = profile['totalDonations'] ?? 0;
      donationAmount.value = profile['totalAmount'] ?? 0.0;
      userRank.value = profile['rank'] ?? 'Bronze';
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Profilni yuklashda xatolik yuz berdi'.tr,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('darkMode') ?? false;
    isBiometricEnabled.value = prefs.getBool('biometric') ?? false;
    isTwoFactorEnabled.value = prefs.getBool('twoFactor') ?? false;
    isNotificationsEnabled.value = prefs.getBool('notifications') ?? false;
  }

  void toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void toggleBiometric(bool value) async {
    isBiometricEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric', value);
  }

  void toggleTwoFactor(bool value) async {
    isTwoFactorEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('twoFactor', value);
  }

  void toggleNotifications(bool value) async {
    isNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    Get.snackbar(
      'Bildirishnomalar'.tr,
      value ? 'Yoqildi'.tr : 'O‘chirildi'.tr,
      backgroundColor: Colors.black.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void deleteAccount() {
    Get.snackbar(
      'Hisob o‘chirildi'.tr,
      'Hisobingiz muvaffaqiyatli o‘chirildi'.tr,
      backgroundColor: Colors.red.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void updateProfile(String name, String email) {
    profile.value = {
      ...profile.value,
      'name': name,
      'email': email,
    };
    Get.snackbar(
      'Profil yangilandi'.tr,
      'Profil ma\'lumotlari yangilandi'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Future<void> changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile.value = {
        ...profile.value,
        'image': File(pickedFile.path),
      };
      Get.snackbar(
        'Rasm o‘zgartirildi'.tr,
        'Profil rasmi muvaffaqiyatli o‘zgartirildi'.tr,
        backgroundColor: Colors.green.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void viewDonationHistory() {
    Get.toNamed('/donation-history');
  }

  void shareProfile() {
    Get.snackbar(
      'Profil ulashildi'.tr,
      'Profilingiz do‘stlaringizga ulashildi'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void simulateDonationUpdates() async {
    await Future.delayed(const Duration(seconds: 2));
    totalDonations.value += 1;
    donationAmount.value += 100.0;
    calculateRank();
  }

  void addCustomDonation(double amount) {
    donationAmount.value += amount;
    totalDonations.value += 1;
    profile.value = {
      ...profile.value,
      'totalDonations': totalDonations.value,
      'totalAmount': donationAmount.value,
    };
    calculateRank();
    Get.snackbar(
      'Ehson qo‘shildi'.tr,
      'Siz $amount summa ehson qildingiz'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void calculateRank() {
    if (donationAmount.value > 1000) {
      userRank.value = 'Platinum Donor';
    } else if (donationAmount.value > 500) {
      userRank.value = 'Gold Donor';
    } else if (donationAmount.value > 100) {
      userRank.value = 'Silver Donor';
    } else {
      userRank.value = 'Bronze Donor';
    }
    profile.value = {...profile.value, 'rank': userRank.value};
  }

  void showCustomDonationDialog() {
    final controller = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('Ehson qo‘shish'.tr),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Summa (\$)',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Bekor qilish'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                addCustomDonation(amount);
                Get.back();
              } else {
                Get.snackbar(
                  'Xato'.tr,
                  'Iltimos, to‘g‘ri summa kiriting'.tr,
                  backgroundColor: Colors.red.withOpacity(0.5),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 8,
                );
              }
            },
            child: Text('Qo‘shish'.tr),
          ),
        ],
      ),
    );
  }
}

// CardModel - karta modeli
class CardModel {
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cardType;
  final File? cardImage;
  final bool isDefault;

  CardModel({
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.cardImage,
    this.isDefault = false,
  });

  CardModel copyWith({
    String? holderName,
    String? cardNumber,
    String? expiryDate,
    String? cardType,
    File? cardImage,
    bool? isDefault,
  }) {
    return CardModel(
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      cardImage: cardImage ?? this.cardImage,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// CardController - kartalar controlleri
class CardController extends ChangeNotifier {
  final List<CardModel> _cards = [];

  List<CardModel> get cards => List.unmodifiable(_cards);

  void addCard(CardModel card) {
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(int index) {
    _cards.removeAt(index);
    notifyListeners();
  }

  void setDefaultCard(int index) {
    for (var i = 0; i < _cards.length; i++) {
      _cards[i] = _cards[i].copyWith(isDefault: i == index);
    }
    notifyListeners();
  }
}

// MessageModel - xabar modeli
class MessageModel {
  final String id;
  final String conversationId;
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

// UserProfile - foydalanuvchi profili modeli
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

// FamilyProfile - oila profili modeli
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

// AdvancedChatController - chat controlleri (avvalgi advanced versiya, nom o'zgartirildi konfliktni oldini olish uchun)
class AdvancedChatController extends GetxController {
  final ChatService _service = ChatService();

  var conversations = <Map<String, dynamic>>[].obs;

  var messages = <MessageModel>[].obs;

  var userSearchResults = <dynamic>[].obs;
  var familySearchResults = <dynamic>[].obs;

  var typing = <String, bool>{}.obs;

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
    _service.markConversationRead(conversationId, 'admin');
    loadConversations();
  }

  void sendMessage({
    required String text,
    required String senderId,
    required String senderName,
  }) {
    final convId = currentConversationId.value.isEmpty
        ? '${senderId}_admin'
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

  void setTyping(String conversationId, bool isTyping) {
    typing[conversationId] = isTyping;
    typing.refresh();
  }
}

// SimpleChatController - oddiy chat controlleri (nom o'zgartirildi, konfliktni oldini olish uchun, va scroll/message controllerlar qo‘shildi)
class SimpleChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    messages.addAll([
      {
        'sender': 'Donor',
        'text': 'Salom, qanday yordam bera olaman?'.tr,
        'time': '12:45',
      },
      {
        'sender': 'Family',
        'text': 'Salom, bizga oziq-ovqat kerak.'.tr,
        'time': '12:47',
      },
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add({
      'sender': 'Donor',
      'text': text.trim(),
      'time': TimeOfDay.now().format(Get.context!),
    });

    messageController.clear();

    // Scroll oxiriga tushish uchun delay bilan ishlatamiz
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Mock javob
    Future.delayed(const Duration(seconds: 1), () {
      messages.add({
        'sender': 'Family',
        'text': 'Rahmat, juda yaxshi bo‘lardi!'.tr,
        'time': TimeOfDay.now().format(Get.context!),
      });

      Future.delayed(Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

// ChatService - chat xizmati (mock)
class ChatService {
  final List<MessageModel> _messages = [];
  final List<UserProfile> _users = [];
  final List<FamilyProfile> _families = [];

  ChatService() {
    _seedData();
  }

  void _seedData() {
    _users.addAll([
      UserProfile(id: 'u1', name: 'Ali', avatar: null, online: true),
      UserProfile(id: 'u2', name: 'Vali', avatar: null, online: false),
      UserProfile(id: 'u3', name: 'Madina', avatar: null, online: true),
      UserProfile(
          id: 'admin', name: 'e-Ehson Admin', avatar: null, online: true),
    ]);

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

  void markConversationRead(String conversationId, String readerId) {
    for (var m in _messages.where((m) => m.conversationId == conversationId)) {
      if (m.senderId != readerId) m.isRead = true;
    }
  }

  List<Map<String, dynamic>> getConversationsSummary() {
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
    summary.sort((a, b) {
      final aTime = (a['lastMessage'] as MessageModel).timestamp;
      final bTime = (b['lastMessage'] as MessageModel).timestamp;
      return bTime.compareTo(aTime);
    });
    return summary;
  }
}

// ApiService - API xizmati (mock bilan, backend simulyatsiyasi)
class ApiService {
  static late final DioPackage.Dio dio;
  static late final ApiService instance;

  static Future<void> init() async {
    dio = DioPackage.Dio();
    dio.interceptors.add(DioPackage.InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.path;
        await Future.delayed(const Duration(milliseconds: 200));

        if (path.endsWith('/api/auth/login') && options.method == 'POST') {
          final data = options.data ?? {};
          final email = data['email'] ?? 'guest@ehson.uz';
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock_token_${Random().nextInt(99999)}',
              'user': {
                'id': 1,
                'name': 'Demo User',
                'email': email,
                'phone': '+998901234567'
              }
            },
          ));
        }

        if (path.endsWith('/api/campaigns') && options.method == 'GET') {
          List campaigns = List.generate(
            8,
            (i) => {
              'id': i + 1,
              'title': 'Kampaniya #${i + 1}',
              'description':
                  'Bu kampaniya ${i + 1} uchun ma\'lumot. Yordamga muhtojlar uchun.',
              'target': 100000 + (i * 50000),
              'collected': (i + 1) * 12000,
              'status': i % 2 == 0 ? 'active' : 'pending',
            },
          );
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 200,
            data: {'campaigns': campaigns},
          ));
        }

        if (path.endsWith('/api/donate') && options.method == 'POST') {
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'success': true,
              'message': 'Ehson qabul qilindi',
              'donation_id': Random().nextInt(10000)
            },
          ));
        }

        if (path.endsWith('/api/user/profile') && options.method == 'GET') {
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'id': 1,
              'name': 'Demo User',
              'email': 'demo@ehson.uz',
              'phone': '+998901234567',
              'donations': [
                {
                  'id': 1,
                  'campaign': 'Kampaniya #1',
                  'amount': 50000,
                  'date': DateTime.now()
                      .subtract(const Duration(days: 10))
                      .toIso8601String()
                },
                {
                  'id': 2,
                  'campaign': 'Kampaniya #3',
                  'amount': 20000,
                  'date': DateTime.now()
                      .subtract(const Duration(days: 40))
                      .toIso8601String()
                },
              ]
            },
          ));
        }

        if (path.endsWith('/api/statistics') && options.method == 'GET') {
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'total_donations': 523000,
              'monthly': List.generate(
                  6, (i) => {'month': i + 1, 'amount': (i + 1) * 40000}),
              'top_donors': [
                {'name': 'Ali', 'amount': 70000},
                {'name': 'Gulbahor', 'amount': 50000}
              ]
            },
          ));
        }

        if (path.endsWith('/api/request-aid') && options.method == 'POST') {
          return handler.resolve(DioPackage.Response(
            requestOptions: options,
            statusCode: 201,
            data: {
              'success': true,
              'request_id': Random().nextInt(9999),
              'status': 'pending'
            },
          ));
        }

        return handler.resolve(DioPackage.Response(
          requestOptions: options,
          statusCode: 404,
          data: {'message': 'Mock route not found $path'},
        ));
      },
    ));

    instance = ApiService._internal();
  }

  ApiService._internal();

  Future<DioPackage.Response> post(String path, [Map<String, dynamic>? data]) =>
      dio.post(path, data: data);

  Future<DioPackage.Response> get(String path, [Map<String, dynamic>? query]) =>
      dio.get(path, queryParameters: query);
}

// LocalizationService - til xizmati
class LocalizationService extends Translations {
  static final locale = Locale('uz', 'UZ');
  static final fallbackLocale = Locale('en', 'US');

  static final langs = ['O\'zbek', 'Русский', 'English'];
  static final locales = [
    Locale('uz', 'UZ'),
    Locale('ru', 'RU'),
    Locale('en', 'US')
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'uz_UZ': {
          'welcome': 'Xush kelibsiz',
          'login': 'Kirish',
          'register': 'Ro\'yxatdan o\'tish',
          'donate': 'Ehson qil',
          'profile': 'Profil',
          'language': 'Til',
          'dashboard': 'Bosh sahifa',
          'error': 'Xato',
          'success': 'Muvaffaqiyat',
          'page_not_found': 'Sahifa topilmadi',
          'security_code': 'Xavfsizlik kodi',
          'sent_verification_code':
              'Biz siz kiritgan telefon raqamiga tasdiqlash kodini yubordik.',
          'wrong_number':
              'Telefon raqami noto‘g‘ri? To‘g‘ri raqamni kiriting\nQayta yuborish %s soniyadan keyin mumkin',
          'next': 'Keyingi',
          'skip': 'O‘tkazib yuborish',
          'email': 'Email',
          'password': 'Parol',
          'tizimga_muvaffaqiyatli_kirdingiz':
              'Tizimga muvaffaqiyatli kirdingiz',
          'email_yoki_parol_notogri': 'Email yoki parol noto‘g‘ri',
          'Ehson statistikasi': 'Ehson statistikasi',
          'Jami ehsonlar': 'Jami ehsonlar',
          'Jami summa': 'Jami summa',
          'Daraja': 'Daraja',
          'Ehson tarixi': 'Ehson tarixi',
          'Maxsus ehson qo‘shish': 'Maxsus ehson qo‘shish',
          'Qo‘shish': 'Qo‘shish',
          'Iltimos, to‘g‘ri summa kiriting': 'Iltimos, to‘g‘ri summa kiriting',
          'Parolni o‘zgartirish': 'Parolni o‘zgartirish',
          'Biometrik autentifikatsiya': 'Biometrik autentifikatsiya',
          'Ikki bosqichli tekshirish (2FA)': 'Ikki bosqichli tekshirish (2FA)',
          'Tilni o‘zgartirish': 'Tilni o‘zgartirish',
          'Tungi rejim': 'Tungi rejim',
          'Bildirishnomalarni sozlash': 'Bildirishnomalarni sozlash',
          'Profilni ulashish': 'Profilni ulashish',
          'Hisobni o‘chirish': 'Hisobni o‘chirish',
          'Diqqat': 'Diqqat!',
          'Hisobingizni butunlay o‘chirmoqchimisiz':
              'Hisobingizni butunlay o‘chirmoqchimisiz?',
          'Bekor qilish': 'Bekor qilish',
          'Ha, o‘chir': 'Ha, o‘chir',
          'Saqlash': 'Saqlash',
          'Ism': 'Ism',
          'Email': 'Email',
          'Bildirishnomalar': 'Bildirishnomalar',
          'Yoqildi': 'Yoqildi',
          'O‘chirildi': 'O‘chirildi',
          'Hisob o‘chirildi': 'Hisob o‘chirildi',
          'Hisobingiz muvaffaqiyatli o‘chirildi':
              'Hisobingiz muvaffaqiyatli o‘chirildi',
          'Profil yangilandi': 'Profil yangilandi',
          'Profil ma\'lumotlari yangilandi': 'Profil ma\'lumotlari yangilandi',
          'Rasm o‘zgartirildi': 'Rasm o‘zgartirildi',
          'Profil rasmi muvaffaqiyatli o‘zgartirildi':
              'Profil rasmi muvaffaqiyatli o‘zgartirildi',
          'Profil ulashildi': 'Profil ulashildi',
          'Profilingiz do‘stlaringizga ulashildi':
              'Profilingiz do‘stlaringizga ulashildi',
          'Ehson qo‘shildi': 'Ehson qo‘shildi',
          'Xabar yozing...': 'Xabar yozing...',
          'Salom, qanday yordam bera olaman?':
              'Salom, qanday yordam bera olaman?',
          'Bizga oziq-ovqat kerak.': 'Bizga oziq-ovqat kerak.',
          'Rahmat, juda yaxshi bo‘lardi!': 'Rahmat, juda yaxshi bo‘lardi!',
          'Assalomu alaykum, Jasurbek!': 'Assalomu alaykum, Jasurbek!',
          'Bosh sahifa': 'Bosh sahifa',
          'Ehson qilish': 'Ehson qilish',
          'Talab qo‘yish': 'Talab qo‘yish',
          'Kampaniyalar': 'Kampaniyalar',
          'Profil': 'Profil',
          'Statistika': 'Statistika',
          'Yordam': 'Yordam',
          'Top kampaniyalar': 'Top kampaniyalar',
          'Yozgi yordam kampaniyasi': 'Yozgi yordam kampaniyasi',
          'Qashshoq oilalarga yordam berish uchun kampaniya.':
              'Qashshoq oilalarga yordam berish uchun kampaniya.',
          'Qishki kiyimlar': 'Qishki kiyimlar',
          'Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.':
              'Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.',
          'Ta\'lim uchun ehson': 'Ta\'lim uchun ehson',
          'Bolalarga ta\'lim imkoniyati yaratish maqsadida.':
              'Bolalarga ta\'lim imkoniyati yaratish maqsadida.',
          '% to‘landi': '% to‘landi',
          'Foydali videolar': 'Foydali videolar',
          'Video ochilmadi': 'Video ochilmadi',
          'Tezkor harakatlar': 'Tezkor harakatlar',
          'Ehson qil': 'Ehson qil',
          'Statistikalar': 'Statistikalar',
          'Foydalanuvchilar': 'Foydalanuvchilar',
          'Xabarlar': 'Xabarlar',
          'Faol Chatlar': 'Faol Chatlar',
          'Tez-tez so\'raladigan savollar': 'Tez-tez so\'raladigan savollar',
          'Qanday qilib ehson qilaman?': 'Qanday qilib ehson qilaman?',
          'Ehson qilish uchun \'Ehson qil\' tugmasini bosing va kerakli ma\'lumotlarni kiriting.':
              'Ehson qilish uchun \'Ehson qil\' tugmasini bosing va kerakli ma\'lumotlarni kiriting.',
          'Talab qanday qo\'yiladi?': 'Talab qanday qo\'yiladi?',
          'Siz \'Talab qo‘yish\' bo‘limida o‘z talablaringizni kiritishingiz mumkin.':
              'Siz \'Talab qo‘yish\' bo‘limida o‘z talablaringizni kiritishingiz mumkin.',
          'Kampaniyalarga qanday qo‘shilaman?':
              'Kampaniyalarga qanday qo‘shilaman?',
          'Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.':
              'Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.',
        },
        'ru_RU': {},
        'en_US': {},
      };

  void changeLocale(int index) => Get.updateLocale(locales[index]);
}

// CustomButton - maxsus tugma widgeti
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outline;
  final IconData? icon;

  const CustomButton(
      {required this.label,
      required this.onTap,
      this.outline = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    if (outline) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: icon != null ? Icon(icon) : SizedBox.shrink(),
        label: Text(label),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon != null ? Icon(icon) : SizedBox.shrink(),
      label: Text(label),
    );
  }
}

// CustomTextField - maxsus matn maydoni widgeti
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType keyboard;

  const CustomTextField(
      {required this.controller,
      required this.label,
      this.obscure = false,
      this.keyboard = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}

// AdminPage - admin sahifasi
class AdminPage extends StatelessWidget {
  final AdminController ac = Get.find();
  @override
  Widget build(BuildContext context) {
    ac.loadMock();
    return Scaffold(
        appBar: AppBar(title: Text('Admin')),
        body: Obx(() => ac.pending.isEmpty
            ? Center(child: Text('Pending yo\'q'))
            : ListView.builder(
                itemCount: ac.pending.length,
                itemBuilder: (context, i) {
                  final p = ac.pending[i];
                  return Card(
                      child: ListTile(
                          title: Text(p['title']),
                          subtitle: Text('Summa: ${p['amount']}'),
                          trailing: Wrap(children: [
                            ElevatedButton(
                                onPressed: () => ac.approve(p['id']),
                                child: Text('Tasdiqlash')),
                            OutlinedButton(
                                onPressed: () => ac.reject(p['id']),
                                child: Text('Rad etish'))
                          ])));
                })));
  }
}

// LoginPage - kirish sahifasi
class LoginPage extends StatelessWidget {
  final AuthController auth = Get.find();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: Center(
        child: Container(
          width: isWide ? 700 : double.infinity,
          padding: EdgeInsets.all(18),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('welcome'.tr,
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 12),
                CustomTextField(controller: _email, label: 'Email'),
                SizedBox(height: 8),
                CustomTextField(
                    controller: _pass, label: 'Parol', obscure: true),
                SizedBox(height: 12),
                Obx(() => auth.isLoading.value
                    ? CircularProgressIndicator()
                    : Column(children: [
                        CustomButton(
                            label: 'Kirish',
                            onTap: () => auth.login(
                                _email.text.trim(), _pass.text.trim()),
                            icon: Icons.login),
                        SizedBox(height: 8),
                        TextButton(
                            onPressed: () => Get.toNamed('/reset'),
                            child: Text('Parolni tiklash'))
                      ])),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Yangi foydalanuvchi? '),
                  TextButton(
                      onPressed: () => Get.toNamed('/register'),
                      child: Text('Ro\'yxatdan o\'tish'))
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// RegisterPage - ro'yxatdan o'tish sahifasi
class RegisterPage extends StatelessWidget {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ro\'yxatdan o\'tish')),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Card(
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    CustomTextField(controller: _name, label: 'Ism'),
                    SizedBox(height: 8),
                    CustomTextField(controller: _email, label: 'Email'),
                    SizedBox(height: 8),
                    CustomTextField(
                        controller: _pass, label: 'Parol', obscure: true),
                    SizedBox(height: 12),
                    CustomButton(
                        label: 'Ro\'yxatdan o\'tish',
                        onTap: () => Get.snackbar(
                            'Info', 'Demo register: ${_email.text}'))
                  ]))),
        ));
  }
}

// ResetPasswordPage - parolni tiklash sahifasi
class ResetPasswordPage extends StatelessWidget {
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Parolni tiklash')),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Card(
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    CustomTextField(controller: _email, label: 'Email'),
                    SizedBox(height: 12),
                    CustomButton(
                        label: 'Yuborish',
                        onTap: () => Get.snackbar(
                            'Info', 'Password reset link sent (demo)'))
                  ]))),
        ));
  }
}

// CampaignDetailPage - kampaniya batafsil sahifasi
class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = Get.parameters;
    return Scaffold(
      appBar: AppBar(title: const Text("Kampaniya tafsilotlari")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'No title',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text("Maqsad: ${campaign['target'] ?? '---'} so‘m"),
            const Spacer(),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.toNamed(
                  '/donate',
                  arguments: {'campaign': campaign},
                ),
                child: const Text('Ehson qil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CampaignsPage - kampaniyalar sahifasi
class CampaignsPage extends StatelessWidget {
  final CampaignController cc = Get.find();

  @override
  Widget build(BuildContext context) {
    cc.fetch();
    return Scaffold(
        appBar: AppBar(title: Text('Kampaniyalar')),
        body: Obx(() => cc.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: cc.campaigns.length,
                itemBuilder: (context, i) {
                  final c = cc.campaigns[i];
                  return Card(
                      child: ListTile(
                          title: Text(c['title']),
                          subtitle: Text('${c['collected']} / ${c['target']}'),
                          trailing: Wrap(spacing: 6, children: [
                            ElevatedButton(
                                onPressed: () => Get.toNamed('/campaign/:id',
                                    parameters: {'id': '${c['id']}'}),
                                child: Text('Batafsil')),
                            OutlinedButton(
                                onPressed: () => Get.toNamed('/donate',
                                    arguments: {'campaign': c}),
                                child: Text('Ehson')),
                          ])));
                })));
  }
}

// DonatePage - ehson qilish sahifasi
class DonatePage extends StatelessWidget {
  DonatePage({Key? key}) : super(key: key);

  final DonationController dc = Get.put(DonationController());
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final campaign = Get.arguments?['campaign'] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text("Ehson qilish")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'Kampaniya',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Maqsad: ${campaign['target'] ?? '---'} so‘m"),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Ehson summasi",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                final amount = double.tryParse(val) ?? 0.0;
                dc.setAmount(amount);
              },
            ),
            const SizedBox(height: 20),
            Obx(() {
              return dc.isProcessing.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          dc.makeDonation(campaign);
                        },
                        child: const Text("Tasdiqlash"),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}

// HelpPage - yordam sahifasi
class HelpPage extends StatelessWidget {
  final faqs = [
    {
      'q': 'Qanday qilib ehson qilaman?',
      'a': 'Bosh sahifadan kampaniyani tanlab, summa kiriting.'
    },
    {'q': 'Anonim bo\'lish mumkinmi?', 'a': 'Ha, anonim opsiyasi mavjud.'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Yordam')),
        body: ListView(children: [
          ...faqs.map((f) => ExpansionTile(title: Text(f['q']!), children: [
                Padding(padding: EdgeInsets.all(12), child: Text(f['a']!))
              ])),
          ListTile(title: Text('Aloqa'), subtitle: Text('support@e-ehson.uz'))
        ]));
  }
}

// HomePage - bosh sahifa
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> youtubeVideos = [
    {
      'title': 'Ehson haqida umumiy ma\'lumot',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    },
    {
      'title': 'Moliyaviy yordam qanday ishlaydi?',
      'url': 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    },
    {
      'title': 'Qanday qilib kampaniyaga qo\'shilamiz?',
      'url': 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrBigger = size.width > 600;

    return Scaffold(
      drawer: !isTabletOrBigger
          ? Drawer(
              child: _buildSideMenu(context),
            )
          : null,
      body: Row(
        children: [
          if (isTabletOrBigger)
            Container(
              width: 250,
              color: Colors.orange,
              child: _buildSideMenu(context),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context, isTabletOrBigger),
                  const SizedBox(height: 24),
                  _buildTopCampaigns(),
                  const SizedBox(height: 24),
                  _buildYouTubeVideos(context),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildStatistics(),
                  const SizedBox(height: 24),
                  _buildFAQ(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isTablet) {
    return Row(
      children: [
        if (!isTablet)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Assalomu alaykum, Jasurbek!'.tr,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          child: Text(
            'Menu',
            style:
                TextStyle(color: Color.fromARGB(255, 1, 13, 36), fontSize: 24),
          ),
        ),
        _SideMenuItem(
          icon: Icons.home,
          label: 'Bosh sahifa'.tr,
          onTap: () => Get.toNamed('/dashboard'),
        ),
        _SideMenuItem(
          icon: Icons.volunteer_activism,
          label: 'Ehson qilish'.tr,
          onTap: () => Get.toNamed('/donate'),
        ),
        _SideMenuItem(
          icon: Icons.request_page,
          label: 'Talab qo‘yish'.tr,
          onTap: () => Get.toNamed('/request'),
        ),
        _SideMenuItem(
          icon: Icons.campaign,
          label: 'Kampaniyalar'.tr,
          onTap: () => Get.toNamed('/campaigns'),
        ),
        _SideMenuItem(
          icon: Icons.person,
          label: 'Profil'.tr,
          onTap: () => Get.toNamed('/profile'),
        ),
        _SideMenuItem(
          icon: Icons.bar_chart,
          label: 'Statistika'.tr,
          onTap: () => Get.toNamed('/statistics'),
        ),
        _SideMenuItem(
          icon: Icons.help,
          label: 'Yordam'.tr,
          onTap: () => Get.toNamed('/help'),
        ),
      ],
    );
  }

  Widget _buildTopCampaigns() {
    List<Map<String, dynamic>> campaigns = [
      {
        'title': 'Yozgi yordam kampaniyasi'.tr,
        'description': 'Muhtoj oilalarga yordam berish uchun kampaniya.'.tr,
        'goal': 100000,
        'collected': 45000,
        'color': Colors.orange
      },
      {
        'title': 'Qishki kiyimlar'.tr,
        'description': 'Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.'.tr,
        'goal': 50000,
        'collected': 21000,
        'color': Colors.blue
      },
      {
        'title': 'Ta\'lim uchun ehson'.tr,
        'description': 'Bolalarga ta\'lim imkoniyati yaratish maqsadida.'.tr,
        'goal': 120000,
        'collected': 72000,
        'color': Colors.green
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top kampaniyalar'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: campaigns.map((campaign) {
              double progress = campaign['collected'] / campaign['goal'];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign['title'],
                        style: TextStyle(
                          color: campaign['color'],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign['description'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      LinearPercentIndicator(
                        lineHeight: 10,
                        percent: progress,
                        backgroundColor: campaign['color'].withOpacity(0.2),
                        progressColor: campaign['color'],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% to‘landi'.tr,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildYouTubeVideos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foydali videolar'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: youtubeVideos.map((video) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill,
                    color: Colors.red, size: 36),
                title: Text(video['title']!),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final url = Uri.parse(video['url']!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Video ochilmadi'.tr)),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tezkor harakatlar'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ActionButton(
              icon: Icons.volunteer_activism,
              label: 'Ehson qil'.tr,
              onTap: () => Get.toNamed('/donate'),
            ),
            _ActionButton(
              icon: Icons.request_page,
              label: 'Talab qo‘yish'.tr,
              onTap: () => Get.toNamed('/request'),
            ),
            _ActionButton(
              icon: Icons.campaign,
              label: 'Kampaniyalar'.tr,
              onTap: () => Get.toNamed('/campaigns'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistikalar'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
              title: 'Foydalanuvchilar'.tr,
              value: '1,245',
              color: Colors.orange,
            ),
            _StatCard(
              title: 'Xabarlar'.tr,
              value: '4,567',
              color: Colors.green,
            ),
            _StatCard(
              title: 'Faol Chatlar'.tr,
              value: '34',
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tez-tez so\'raladigan savollar'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _FaqItem(
          question: 'Qanday qilib ehson qilaman?'.tr,
          answer:
              'Ehson qilish uchun \'Ehson qil\' tugmasini bosing va kerakli ma\'lumotlarni kiriting.'
                  .tr,
        ),
        _FaqItem(
          question: 'Talab qanday qo\'yiladi?'.tr,
          answer:
              'Siz \'Talab qo‘yish\' bo‘limida o‘z talablaringizni kiritishingiz mumkin.'
                  .tr,
        ),
        _FaqItem(
          question: 'Kampaniyalarga qanday qo\'shilaman?'.tr,
          answer:
              'Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.'
                  .tr,
        ),
      ],
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SideMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange.withOpacity(0.2),
            child: Icon(icon, color: Colors.orange, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}

// ProfilePage - profil sahifasi
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController pc = Get.put(ProfileController());
  final AuthController ac = Get.find();
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  void _showEditProfileSheet() {
    final TextEditingController nameController =
        TextEditingController(text: pc.profile['name']);
    final TextEditingController emailController =
        TextEditingController(text: pc.profile['email']);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ism'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedScaleButton(
              onPressed: () {
                pc.updateProfile(nameController.text, emailController.text);
                Get.back();
              },
              child: Text('Saqlash'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfileImage() {
    pc.changeProfileImage();
  }

  Widget _buildDonationsSummary() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ehson statistikasi'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() => AnimatedCount(
                      count: pc.totalDonations.value,
                      duration: const Duration(seconds: 1),
                      child:
                          Text('Jami ehsonlar: ${pc.totalDonations.value}'.tr),
                    )),
                Obx(() => AnimatedCount(
                      count: pc.donationAmount.value,
                      duration: const Duration(seconds: 1),
                      child:
                          Text('Jami summa: \$${pc.donationAmount.value}'.tr),
                    )),
                Obx(() => Text('Daraja: ${pc.userRank.value}'.tr)),
                const SizedBox(height: 12),
                AnimatedScaleButton(
                  onPressed: pc.viewDonationHistory,
                  child: Text('Ehson tarixi'.tr),
                ),
                AnimatedScaleButton(
                  onPressed: () {
                    pc.addCustomDonation(100.0);
                    confettiController.play();
                    pc.calculateRank();
                  },
                  child: const Text('100\$ Ehson qo\'shish'),
                ),
                AnimatedScaleButton(
                  onPressed: pc.showCustomDonationDialog,
                  child: Text('Maxsus ehson qo‘shish'.tr),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.red],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, size: 40),
            title: Text('Parolni o‘zgartirish'.tr),
            onTap: () => Get.toNamed('/reset'),
          ),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SwitchListTile(
                  key: ValueKey<bool>(pc.isBiometricEnabled.value),
                  secondary: const Icon(Icons.fingerprint),
                  title: Text('Biometrik autentifikatsiya'.tr),
                  value: pc.isBiometricEnabled.value,
                  onChanged: pc.toggleBiometric,
                ),
              )),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SwitchListTile(
                  key: ValueKey<bool>(pc.isTwoFactorEnabled.value),
                  secondary: const Icon(Icons.security),
                  title: Text('Ikki bosqichli tekshirish (2FA)'.tr),
                  value: pc.isTwoFactorEnabled.value,
                  onChanged: pc.toggleTwoFactor,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExtraSettings() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Tilni o‘zgartirish'.tr),
            onTap: () => Get.toNamed('/language'),
          ),
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.dark_mode, size: 40),
                title: Text('Tungi rejim'.tr),
                value: pc.isDarkMode.value,
                onChanged: pc.toggleDarkMode,
              )),
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text('Bildirishnomalarni sozlash'.tr),
                value: pc.isNotificationsEnabled.value,
                onChanged: pc.toggleNotifications,
              )),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('Profilni ulashish'.tr),
            onTap: pc.shareProfile,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              'Hisobni o‘chirish'.tr,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.defaultDialog(
                title: 'Diqqat!'.tr,
                middleText: 'Hisobingizni butunlay o‘chirmoqchimisiz?'.tr,
                textCancel: 'Bekor qilish'.tr,
                textConfirm: 'Ha, o‘chir'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  pc.deleteAccount();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileSheet,
          ),
        ],
      ),
      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = pc.profile.value;
        if (profile.isEmpty) {
          return Center(child: Text('Profil ma\'lumotlari mavjud emas'.tr));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Hero(
                tag: 'profile_image',
                child: GestureDetector(
                  onTap: _changeProfileImage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: profile['image'] != null
                          ? FileImage(profile['image'] as File)
                          : null,
                      child: profile['image'] == null
                          ? Text(
                              (profile['name']?.isNotEmpty ?? false)
                                  ? profile['name'][0]
                                  : 'U',
                              style: const TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(profile['name'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(profile['email'] ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
              _buildDonationsSummary(),
              _buildSecuritySettings(),
              _buildExtraSettings(),
              const SizedBox(height: 20),
              AnimatedScaleButton(
                onPressed: ac.logout,
                child: Text('Chiqish'.tr),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AnimatedCount extends StatelessWidget {
  final num count;
  final Duration duration;
  final Widget child;

  const AnimatedCount({
    super.key,
    required this.count,
    required this.duration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<num>(
      tween: Tween(begin: 0, end: count),
      duration: duration,
      builder: (context, value, _) => child,
    );
  }
}

class AnimatedScaleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedScaleButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(1.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// AddCardPage - yangi karta qo'shish sahifasi
class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();

  File? _cardImage;

  String _selectedCardType = "UzCard";
  final List<String> _cardTypes = ["UzCard", "Visa", "Humo", "Boshqa"];

  Future<void> _pickCardImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _cardImage = File(picked.path);
      });
    }
  }

  void _formatCardNumber(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    final formatted = clean.replaceAllMapped(
        RegExp(r".{4}"), (match) => "${match.group(0)} ");
    _cardNumberController.value = TextEditingValue(
      text: formatted.trim(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _formatExpiryDate(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    String result = clean;
    if (clean.length > 2) {
      result = "${clean.substring(0, 2)}/${clean.substring(2)}";
    }
    _expiryDateController.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Yangi Karta Qo'shish"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                    image: _cardImage != null
                        ? DecorationImage(
                            image: FileImage(_cardImage!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KARTA PREVIEW (${_selectedCardType})",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _cardNumberController.text.isEmpty
                            ? "**** **** **** ****"
                            : _cardNumberController.text,
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _holderNameController.text.isEmpty
                                ? "KARTA EGASI"
                                : _holderNameController.text.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _expiryDateController.text.isEmpty
                                ? "MM/YY"
                                : _expiryDateController.text,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _holderNameController,
                  decoration: const InputDecoration(
                    labelText: "Karta egasi",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (val) =>
                      val!.isEmpty ? "Karta egasini kiriting" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Karta raqami",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _formatCardNumber(val);
                    setState(() {});
                  },
                  validator: (val) => val!.replaceAll(' ', '').length < 16
                      ? "To‘g‘ri karta raqamini kiriting"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amal qilish muddati (MM/YY)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _formatExpiryDate(val);
                    setState(() {});
                  },
                  validator: (val) => val!.isEmpty || val.length != 5
                      ? "Amal qilish muddatini kiriting"
                      : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCardType,
                  items: _cardTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Karta turi",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedCardType = val!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Karta rasmini olish"),
                  onPressed: _pickCardImage,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: const Text("Karta qo'shish"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final card = CardModel(
                        holderName: _holderNameController.text,
                        cardNumber: _cardNumberController.text,
                        expiryDate: _expiryDateController.text,
                        cardType: _selectedCardType,
                        cardImage: _cardImage,
                      );
                      Provider.of<CardController>(context, listen: false)
                          .addCard(card);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CardListWidget - kartalar ro'yxati widgeti
class CardListWidget extends StatelessWidget {
  const CardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardController>(
      builder: (context, controller, child) {
        if (controller.cards.isEmpty) {
          return const Center(child: Text("No cards added yet."));
        }
        return ListView.builder(
          itemCount: controller.cards.length,
          itemBuilder: (context, index) {
            final card = controller.cards[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.credit_card,
                    color: card.isDefault ? Colors.orange : Colors.grey),
                title: Text(card.cardNumber),
                subtitle: Text("${card.holderName} • ${card.expiryDate}"),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "default") {
                      controller.setDefaultCard(index);
                    } else if (value == "delete") {
                      controller.removeCard(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: "default", child: Text("Set as Default")),
                    const PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// CameraPaymentPage - kamera to'lov sahifasi
class CameraPaymentPage extends StatelessWidget {
  const CameraPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Scan QR or Card to Pay",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Open Camera"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Camera feature coming soon!")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ChatScreen - chat sahifasi (SimpleChatController ishlatiladi, messages Map bo‘lib o'zgartirildi)
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SimpleChatController controller = Get.put(SimpleChatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isDonor = message['sender'] == 'Donor';

                  return Align(
                    alignment:
                        isDonor ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDonor ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isDonor
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['sender'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDonor ? Colors.blue : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['text'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['time'],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Xabar yozing...'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => controller.sendMessage(value),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    controller.sendMessage(controller.messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// RequestAidPage - yordam talab qilish sahifasi
class RequestAidPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestAidState();
}

class _RequestAidState extends State<RequestAidPage> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _reason = TextEditingController();
  var status = ''.obs;
  var sending = false.obs;

  void submit() async {
    final t = _title.text.trim();
    final a = double.tryParse(_amount.text.trim()) ?? 0;
    final r = _reason.text.trim();
    if (t.isEmpty || a <= 0 || r.isEmpty) {
      Get.snackbar('Xato', 'Barcha maydonlarni to\'ldiring');
      return;
    }
    sending.value = true;
    try {
      final res = await ApiService.instance
          .post('/api/request-aid', {'title': t, 'amount': a, 'reason': r});
      status.value = 'Yuborildi (ID: ${res.data['request_id']})';
    } catch (e) {
      Get.snackbar('Xato', 'Xato: $e');
    } finally {
      sending.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ehson talab qilish')),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(children: [
                      TextField(
                          controller: _title,
                          decoration: InputDecoration(
                              labelText: 'Mavzu',
                              border: OutlineInputBorder())),
                      SizedBox(height: 8),
                      TextField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Summa (UZS)',
                              border: OutlineInputBorder())),
                      SizedBox(height: 8),
                      TextField(
                          controller: _reason,
                          maxLines: 4,
                          decoration: InputDecoration(
                              labelText: 'Asos', border: OutlineInputBorder())),
                      SizedBox(height: 12),
                      Obx(() => sending.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: submit, child: Text('Yuborish'))),
                      SizedBox(height: 12),
                      Obx(() => Text(status.value)),
                    ])))));
  }
}

// LanguagePage - til tanlash sahifasi
class LanguagePage extends StatelessWidget {
  final service = LocalizationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('language'.tr)),
        body: ListView.builder(
            itemCount: LocalizationService.langs.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(LocalizationService.langs[i]),
                  onTap: () {
                    service.changeLocale(i);
                    Get.back();
                  });
            }));
  }
}

// StatisticsPage - statistika sahifasi
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool loading = false;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      loading = true;
    });
    final res = await ApiService.instance.get('/api/statistics');
    setState(() {
      stats = res.data ?? {};
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistika")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: stats.entries
                  .map((e) => ListTile(
                        title: Text(e.key),
                        trailing: Text("${e.value}"),
                      ))
                  .toList(),
            ),
    );
  }
}

// DashboardPage - dashboard sahifasi
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const ChatScreen(),
      const CameraPaymentPage(),
      AddCardPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
        color: Colors.black54,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.chat_bubble_outline, title: 'Chat'),
          TabItem(icon: Icons.camera_alt_outlined, title: 'Camera'),
          TabItem(icon: Icons.credit_card, title: 'Cards'),
          TabItem(icon: Icons.person_outline, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// SplashPage - splash sahifasi
class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () => Get.offNamed('/login'));

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'e-Ehson',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Shaffof va ishonchli ehson platformasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AppTheme - tema
class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.green,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    ),
  );
}

// Routes - marshrutlar
class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const RESET = '/reset';
  static const DASHBOARD = '/dashboard';
  static const DONATE = '/donate';
  static const REQUEST = '/request';
  static const CAMPAIGNS = '/campaigns';
  static const CAMPAIGN_DETAIL = '/campaign/:id';
  static const PROFILE = '/profile';
  static const ADMIN = '/admin';
  static const STATISTICS = '/statistics';
  static const HELP = '/help';
  static const LANGUAGE = '/language';
  static const CHAT = '/chat';
  static const DONATION_HISTORY = '/donation-history';
}

// AppPages - sahifalar ro'yxati
class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: Routes.RESET,
      page: () => ResetPasswordPage(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
    ),
    GetPage(
      name: Routes.DONATE,
      page: () => DonatePage(),
    ),
    GetPage(
      name: Routes.REQUEST,
      page: () => RequestAidPage(),
    ),
    GetPage(
      name: Routes.CAMPAIGNS,
      page: () => CampaignsPage(),
    ),
    GetPage(
      name: Routes.CAMPAIGN_DETAIL,
      page: () => CampaignDetailPage(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => AdminPage(),
    ),
    GetPage(
      name: Routes.STATISTICS,
      page: () => StatisticsPage(),
    ),
    GetPage(
      name: Routes.HELP,
      page: () => HelpPage(),
    ),
    GetPage(
      name: Routes.LANGUAGE,
      page: () => LanguagePage(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: Routes.DONATION_HISTORY,
      page: () => const Center(child: Text('Donation History')),
    ),
  ];
}

// Main funksiya - dastur boshlanishi
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(GetMaterialApp(
    title: 'e-Ehson',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    translations: LocalizationService(),
    locale: LocalizationService.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    initialBinding: InitialBindings(),
    initialRoute: Routes.SPLASH,
    getPages: AppPages.pages,
    defaultTransition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ));
}
