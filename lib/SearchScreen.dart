import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchScreen'),
      ),
      body: Column(
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
                onTap: () {},
                child: Container(child: Icon(Icons.search)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
