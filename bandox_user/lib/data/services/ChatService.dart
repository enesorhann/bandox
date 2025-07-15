import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_panel/data/entities/Message/Messages.dart';

class ChatService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;


  String generateChatRoomID(String receiverId,String senderId){
    var ids = [receiverId,senderId];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessage(String receiverId,String senderId, String message) async {
    var currentUserId = senderId;
    var timeStamp = Timestamp.now();

    var newMessage = Messages(
        senderId: currentUserId,
        receiverId: receiverId,
        message: message,
        timeStamp: timeStamp);

    String chatRoomId = generateChatRoomID(receiverId, senderId);

    await _firebaseFirestore.collection("chatrooms")
    .doc(chatRoomId)
    .collection("messages")
    .add(newMessage.toMap());

  }

  Stream<QuerySnapshot> getMessages(String reveiverUserId,String senderUserId){

    String chatRoomId = generateChatRoomID(reveiverUserId, senderUserId);

    return _firebaseFirestore.collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp",descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String reveiverUserId,String senderUserId){

    String chatRoomId = generateChatRoomID(reveiverUserId, senderUserId);

    return _firebaseFirestore.collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp",descending: true)
        .limit(1)
        .snapshots();
  }

}
