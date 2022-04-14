import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chat_app/Chat/views/search.dart';
import 'package:chat_app/Chat/views/chat.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'database.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  User? user = FirebaseAuth.instance.currentUser;
  Stream chatRooms = Stream.empty();

  List<String> _chattingWithName = [], _chattingWithUid = [];

  Widget getChatList(snapshot) {
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      _chattingWithUid.add(snapshot.data.docs[i]
          .get('chatRoomId')
          .toString()
          .replaceAll("_", "")
          .replaceAll(Constants.myNumber.toString(), ""));

      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(_chattingWithUid[i])
          .once()
          .then((value) {
        print(value);
        // _chattingWithName.add(value.value['name']);
      }).whenComplete(() => {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    if (_chattingWithName.isNotEmpty) {
                      _chattingWithName;
                    }
                  });
                })
              });
    }
    return _chattingWithName.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                chattingWithUid: _chattingWithUid[index],
                chattingWithName: _chattingWithName[index],
                chatRoomId: snapshot.data.docs[index].get("chatRoomId"),
              );
            });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return /*snapshot.hasData
            // ? snapshot.data?.size.toInt() != 0
            ? */
            getChatList(snapshot);
        // : Container(
        //     child: const Center(
        //       child: Text('No chats'),
        //     ),
        //   );
        // : const Center(
        //     child: CircularProgressIndicator(),
        //   );
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    //Constants.myNumber = user.phoneNumber;
    print('GetUSerInfoGetChats: ' + Constants.myNumber.toString());
    // DatabaseMethods()
    //     .getUserChats(Constants.myNumber.toString())
    //     .then((snapshots) {
    //   setState(() {
    //     chatRooms = snapshots;
    //   });
    // });
    setState(() {
      chatRooms = DatabaseMethods().getUserChats(
          FirebaseAuth.instance.currentUser!.phoneNumber.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xff7AC338),
      ),
      backgroundColor: Colors.grey,
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7AC338),
        child: const Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chattingWithUid;
  final String chattingWithName;
  final String chatRoomId;

  ChatRoomsTile(
      {required this.chattingWithUid,
      required this.chattingWithName,
      required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              chattingWithUid: chattingWithUid,
              chatRoomId: chatRoomId,
              chattingWithName: chattingWithName,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white, //Colors.black26
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Color(0xff7AC338),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  chattingWithName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              chattingWithName,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
