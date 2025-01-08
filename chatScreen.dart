import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ChatScreen extends StatefulWidget {
  final String senderEkoId;
  final String receiverEkoId;

  const ChatScreen({super.key, required this.senderEkoId, required this.receiverEkoId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();   // using a message controller for messaging
  final ScrollController _scrollController = ScrollController();       // using a scroll controller for sliding

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverEkoId}'),   // shown title is receiver ekoid
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addToAppointment,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(   // listen firestore chat according to user
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)         // order according to time
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());       // waiting animation
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,              // last message showing first so list reverse
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final isSender = message['senderId'] == widget.senderEkoId;
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,    // Alignment of message: user on the right, other user on the left
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue : Colors.grey[300], // User messages are blue, other user messages are gray
                          borderRadius: BorderRadius.circular(10),        // chat box shape
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(             // Text box
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();  //take user message and delete unnecessary spaces
    if (text.isNotEmpty) {
      final chatId = _getChatId();        //unique comnbination for chat

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': widget.senderEkoId,
        'receiverId': widget.receiverEkoId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  String _getChatId() {               // Create Chat ID using two users ekoid
    final ids = [widget.senderEkoId, widget.receiverEkoId];
    ids.sort();
    return ids.join('_');
  }

  void _addToAppointment() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Passenger to Appointment'),
          content: const Text(
              'Are you sure you want to add this passenger to your appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final driverEkoId = widget.senderEkoId;
                final passengerEkoId = widget.receiverEkoId;

                final position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                final appointmentRef = FirebaseFirestore.instance
                    .collection('appointments')
                    .doc(driverEkoId);

                final appointmentData = await appointmentRef.get();

                if (appointmentData.exists) {
                  final passengers =
                  List<String>.from(appointmentData['passengers'] ?? []);
                  if (!passengers.contains(passengerEkoId)) {
                    passengers.add(passengerEkoId);
                    await appointmentRef.update({
                      'passengers': passengers,
                      'latitude': position.latitude,
                      'longitude': position.longitude,
                      'ekoId': driverEkoId,
                    });
                  }
                } else {
                  await appointmentRef.set({
                    'ekoId': driverEkoId,
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'passengers': [passengerEkoId],
                  });
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passenger added to appointment!'),
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
