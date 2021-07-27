import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onetoonechatapp/Authentication.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> userMap;
  TextEditingController searchTextEditingController = TextEditingController();
  bool isloading = false;

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
                  userMap != null
                      ? ListTile(
                          onTap: () {},
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
                      : Container(),
                ],
              ));
  }
}
