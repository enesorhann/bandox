import 'package:cloud_firestore/cloud_firestore.dart';

class Messages{
   String senderId;
   String receiverId;
   String message;
   Timestamp timeStamp;

  Messages({required this.senderId,required this.receiverId,required this.message,required this.timeStamp,});


  Map<String,dynamic> toMap(){
    return {
      "senderId":senderId,
      "receiverId":receiverId,
      "message":message,
      "timeStamp":timeStamp,
    };
  }

}