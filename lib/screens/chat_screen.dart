import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ikinciel/services/message_textfield.dart';
import 'package:ikinciel/utils/single_message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
    required this.userId,
    required this.name,
  }) : super(key: key);

  final CurrentUser = FirebaseAuth.instance.currentUser;
  final String userId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(CurrentUser!.uid)
                    .collection("messages")
                    .doc(userId)
                    .collection("chats")
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("write something"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              CurrentUser!.uid;
                          return SignleMessage(
                            message: snapshot.data.docs[index]['message'],
                            isMe: isMe,
                          );
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MessageTextField(currentId: CurrentUser!.uid, userId: userId)
        ],
      ),
    );
  }
}
