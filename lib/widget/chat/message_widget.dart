import 'package:chat_app/widget/chat/bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    // buat ambil data user dari firebase
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            // descending biar data terbaru ada dipaling atas firebase
            .orderBy('createdAt', descending: true)
            // buat dapatin data chat pakai snapshot
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          // kalau nanti proses koneksi ambil data chat itu status nya waiting
          // maka tampilkan tampilan loading
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              // biar di tampilan chat nya, data paling baru ada di paling bawah
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                return BubbleChatWidget(
                    message: (chatDocs[index].data()! as Map)['text'],
                    userNama: (chatDocs[index].data()! as Map)['username'],
                    userImage: (chatDocs[index].data()! as Map)['userImage'],
                    isMe: (chatDocs[index].data()! as Map)['userId'] ==
                        user!.uid);
              });
        });
  }
}
