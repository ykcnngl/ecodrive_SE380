import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatScreen.dart';


class MessagesScreen extends StatelessWidget {
  final String currentEkoId;

  const MessagesScreen({super.key, required this.currentEkoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(                                   //Using StreamBuilder to continuously listen to a collection of chats from Firestore
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());      // If data doesn't load, show circle
          }

          final allChats = snapshot.data!.docs;              // all chat data pulled from firestore
          final userChats = allChats.where((doc) {
            final participants = doc.id.split('_');         //Participants parsed from the ID for chat
            return participants.contains(currentEkoId);        // Data convert to list
          }).toList();

          if (userChats.isEmpty) {                          // If chat empty, show message
            return const Center(
              child: Text("No chats available."),
            );
          }

          return ListView.builder(            // we use listview for user's chat list
            itemCount: userChats.length,              // The number of elements shown is the length of the list
            itemBuilder: (context, index) {
              final chat = userChats[index];
              final participants = chat.id.split('_');          // participants specify from chatID
              final otherUser = participants.firstWhere((id) => id != currentEkoId);

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(otherUser),
                subtitle: Text(
                  chat['lastMessage'] ?? 'No messages yet.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        senderEkoId: currentEkoId,
                        receiverEkoId: otherUser,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
