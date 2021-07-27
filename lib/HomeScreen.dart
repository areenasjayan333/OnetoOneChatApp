import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onetoonechatapp/Authentication.dart';

import 'ChatRoom.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late Map<String, dynamic> userMap;
  TextEditingController searchTextEditingController = TextEditingController();
  bool isloading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setState('Online');
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState("Online");
    } else {
      setState("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isloading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: searchTextEditingController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isloading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SearchScreen'),
          actions: [
            IconButton(
                onPressed: () => logOut(context), icon: Icon(Icons.logout))
          ],
        ),
        body: isloading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Colors.grey,
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search username...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          onSearch();
                        },
                        child: Container(child: Icon(Icons.search)),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  if (userMap != null)
                    ListTile(
                      onTap: () {
                        String roomId = chatRoomId(
                            _auth.currentUser!.displayName, userMap['name']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                      chatRoomId: roomId,
                                      userMap: userMap,
                                    )));
                      },
                      leading: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                      title: Text(
                        userMap['name'],
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      subtitle: Text(userMap['email']),
                      trailing: Icon(
                        Icons.chat,
                        color: Colors.black,
                      ),
                    )
                  else
                    Container(),
                ],
              ));
  }
}
