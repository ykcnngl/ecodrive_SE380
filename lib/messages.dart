import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final TextEditingController messageController = TextEditingController();

  final String senderEkoId = "";
  final String receiverEkoId = "";

  void sendMessage(String messageContent) async {
    try {
      // Gönderen kişinin bilgilerini Firestore'dan al
      final senderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderEkoId)
          .get();
      final senderName = senderDoc['name'];
      final senderSurname = senderDoc['surname'];

      // Sohbet ID'si oluştur
      final chatId = senderEkoId.compareTo(receiverEkoId) < 0
          ? '${senderEkoId}_$receiverEkoId'
          : '${receiverEkoId}_$senderEkoId';

      // Mesajı Firestore'a ekle
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'content': messageContent,
        'senderEkoId': senderEkoId,
        'timestamp': FieldValue.serverTimestamp(),
        'senderName': senderName,
        'senderSurname': senderSurname,
      });

      print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages() {
    final chatId = senderEkoId.compareTo(receiverEkoId) < 0
        ? '${senderEkoId}_$receiverEkoId'
        : '${receiverEkoId}_$senderEkoId';

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Messages"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mesaj listesi
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderEkoId'] == senderEkoId;

                    return ListTile(
                      title: Align(
                        alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            color: isSender ? Colors.blue : Colors.grey[300],
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                message['content'],
                                style: TextStyle(
                                    color: isSender ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Mesaj gönderme alanı
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final messageContent = messageController.text.trim();
                    if (messageContent.isNotEmpty) {
                      sendMessage(messageContent);
                      messageController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
