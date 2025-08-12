import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
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

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

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
