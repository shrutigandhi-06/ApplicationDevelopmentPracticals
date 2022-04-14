import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:chat_app/Chat/database.dart';
import 'package:chat_app/Chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
// import 'package:linkify/linkify.dart';
// import 'package:url_launcher/url_launcher.dart';

class Chat extends StatefulWidget {
  final String chatRoomId, chattingWithUid, chattingWithName;

  Chat(
      {required this.chatRoomId,
      required this.chattingWithUid,
      required this.chattingWithName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  // File imageFile;
  // String imageURL;
  late bool isLoading;

  late String chattingWithNumber;

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      int _type = snapshot.data?.docs[index].get("type");
                      return MessageTile(
                          message: snapshot.data?.docs[index].get('message'),
                          sendByMe: Constants.myNumber ==
                              snapshot.data?.docs[index].get("sendBy"),
                          type: snapshot.data?.docs[index].get("type"));
                    }),
              )
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myNumber,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'type': 0,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      });
    }
  }

  // Future getImage() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   PickedFile pickedFile;
  //
  //   pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     imageFile = File(pickedFile.path);
  //     if (imageFile != null) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       uploadFile();
  //     }
  //   }
  // }

  // Future uploadFile() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child('ChatImages')
  //       .child(widget.chatRoomId)
  //       .child(fileName);
  //   UploadTask uploadTask = reference.putFile(imageFile);
  //
  //   try {
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageURL = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       isLoading = false;
  //       onSendImage(imageURL, 1);
  //     });
  //   } on FirebaseException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(e.message);
  //   }
  // }

  // onSendImage(imageUrl, type) {
  //   if (imageURL != null) {
  //     Map<String, dynamic> chatMessageMap = {
  //       "sendBy": Constants.myUid,
  //       "imageURL": imageURL,
  //       'time': DateTime.now().millisecondsSinceEpoch,
  //       'type': 1,
  //     };
  //
  //     DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
  //   }
  // }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget.chattingWithUid)
        .once()
        .then((value) {
      print(value);
      // chattingWithNumber = value.value['mobileNumber']
    });

    // String chattingWithToken;
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.chattingWithUid)
        .get()
        .then((value) => FirebaseFirestore.instance
                .collection('users')
                .doc(Constants.myNumber)
                .update({
              // 'chattingWithToken': chattingWithToken.toString(),
              'chattingWithUid': widget.chattingWithUid
            }));

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: Color(0xff7AC338),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                launch('tel://' + '+91' + chattingWithNumber);
              },
              child: const Icon(
                Icons.call,
                color: Colors.white,
              ),
            ),
          )
        ],
        title: Row(
          children: [
            GestureDetector(
              onTap: () {/*TODO :Redirect to User Profile*/},
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/1.jpg'),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              onTap: () {/*TODO :Redirect to User Profile*/},
              child: Text(widget.chattingWithName),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/chatbg.png'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // getImage();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.photo,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: simpleTextStyle(),
                        decoration: const InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color(0xff7AC338),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int type;

  MessageTile(
      {required this.message, required this.sendByMe, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 0, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
            colors: sendByMe
                ? [const Color(0xff418edc), const Color(0xff1e6bb3)]
                : [const Color(0xff5e5e61), const Color(0xff8c8c8e)],
          ),
        ),
        child: Linkify(
          text: message,
          options: const LinkifyOptions(
              looseUrl: true, defaultToHttps: true, humanize: false),
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
          linkStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
