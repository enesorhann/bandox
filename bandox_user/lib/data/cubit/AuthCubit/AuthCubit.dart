import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class AuthCubit extends Cubit<String>{
  AuthCubit() : super("");

  var usersRef = FirebaseFirestore.instance.collection("Users");

  Future<void> saveUserID(String phoneNum) async{
    var querySnapshot = await usersRef.where("phoneNum",isEqualTo: phoneNum).get();
    for(var doc in querySnapshot.docs){
      var user = Users.fromJson(doc.id, doc.data());
      emit(user.userID!);
    }
  }


  Future<void> deleteUserID() async{
    emit("");
  }

}