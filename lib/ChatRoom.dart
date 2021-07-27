import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  late Map<String, dynamic> userMap;
  late final String chatRoomId;
  ChatRoom({required this.chatRoomId, required this.userMap});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController messageTextEditingController = TextEditingController();
  void onSendMessage() async {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser.displayName,
        "message": messageTextEditingController.text,
        "time": FieldValue.serverTimestamp(),
      };
      messageTextEditingController.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  var snap;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          builder: (context, snapshot) {
            stream:
            _firestore.collection("users").doc(userMap['uid']).snapshots();
            builder:
            (context, snapshot) {
              if (snapshot.data != null) {
                return Container(
                  child: Column(children: [
                    Text(userMap['name']),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ]),
                );
              } else {
                return Container();
              }
            };
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(chatRoomId)
                        .collection('chats')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            snap = snapshot.data!.docs[index].data();
                            Map<String, dynamic> map = snap;
                            return messages(size, map);
                          },
                        );
                      } else {
                        return Container();
                      }
                    }))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height / 10,
        width: size.width,
        alignment: Alignment.center,
        child: Container(
          height: size.height / 12,
          width: size.width / 1.1,
          child: Row(children: [
            Container(
              height: size.height / 12,
              width: size.width / 1.1,
              child: TextField(
                  controller: messageTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Send Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ))),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                onSendMessage();
              },
            )
          ]),
        ),
      ),
    );
  }
}

Widget messages(Size size, Map<String, dynamic> map) {
  return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue,
        ),
        child: Text(map['message'],
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
      ));
}
