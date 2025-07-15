import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class DeptFirebsServ{

  final _deptsRef = FirebaseFirestore.instance.collection("Departments");
  final _usersRef = FirebaseFirestore.instance.collection("Users");


  Future<void> deptDelete(String dep_id) async{

    var querySnapshot = await _usersRef.where("dep_ids",arrayContains: dep_id).get();

    if(querySnapshot.docs.isNotEmpty){
      for (var doc in querySnapshot.docs) {
        var user = Users.fromJson(doc.id, doc.data());
        await _usersRef.doc(user.userID).delete();
      }
    }
    await _deptsRef.doc(dep_id).delete();
  }

  Future<void> depGuncelle(String dep_id,String dep_adi) async{
    var info = HashMap<String,dynamic>();
    info["dep_adi"] = dep_adi;
    await _deptsRef.doc(dep_id).update(info);
  }

  Future<void> depEkle(String dep_adi,String sirket_id) async{
    var info = HashMap<String,dynamic>();
    info["dep_id"] = "";
    info["dep_adi"] = dep_adi;
    info["sirket_id"] = sirket_id;
    await _deptsRef.add(info);
  }

}