import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseMethods {
  static int length = 0;

  searchByPhoneNo(String searchField) {
    print('Searching...' + searchField);
    length = 0;
    // var dbRef = FirebaseDatabase.instance.reference();
    // dbRef
    //     .child("users")
    //     .orderByChild('phone_no')
    //     .equalTo(searchField)
    //     .onValue
    //     .listen((event) {
    //   // var value = event.snapshot.value;
    //   // var uuids = value.keys;
    //   // for (var uuid in uuids) {
    //   //   var names = value[uuid]['name'];
    //   //   if (names == searchField) {
    //   //     length++;
    //   //     print('name:' + names);
    //   //   }
    //   // }
    //   print('length: ' + length.toString());
    // });
    var dbRef = FirebaseFirestore.instance.collection('users').doc(searchField);
    return dbRef.snapshots();
    // return length;
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyNumber) async {
    print('GetUSerChats: ' + itIsMyNumber);
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: itIsMyNumber)
        .snapshots();
  }
}
