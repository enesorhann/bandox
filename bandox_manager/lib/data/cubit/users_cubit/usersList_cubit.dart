import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/repo/UserFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class UsersListCubit extends Cubit<List<Users>>{
  UsersListCubit() : super(<Users>[]);

  final _uFServ = UserFirebsServ();
  final _usersRef = FirebaseFirestore.instance.collection("Users");

/*
  Future<void> usersList({String? searchedWord}) async{
    var querySnapshot = await usersRef.get();
    var list = <Users>[];

    try{
      for (var doc in querySnapshot.docs) {
        var user_key = doc.id;
        var json = doc.data();
        var user = Users.fromJson(user_key, json);
        list.add(user);
      }
      emit(list);
    } catch(e){
      print(e.toString());
      emit([]);
    }

  }

 */

  Future<void> departmandakiKullanicilar(String dep_id) async{
    _usersRef
    .where("dep_ids",arrayContains: dep_id)
    .snapshots()
    .listen((snapshot){
      var userList = snapshot.docs.map((doc) => Users.fromJson(doc.id,doc.data())).toList();
      emit(userList);
    });
  }



  Future<void> birKezDepartmandakiKullanicilar(String dep_id) async{
    var querySnapshot = await _usersRef
        .where("dep_ids",arrayContains: dep_id)
        .get();
    var list = <Users>[];

    print("${querySnapshot.docs.length} kullanici bulundu!");

    try{
      for (var doc in querySnapshot.docs) {
        var user_key = doc.id;
        var json = doc.data();
        var user = Users.fromJson(user_key, json);
        list.add(user);
      }
      emit(list);
    } on FirebaseException catch(e){
      print("Hata Mesaji -> "+e.toString());
      emit([]);
    }
  }


  Future<void> userDelete(String userID,String dep_id) async{
    await _uFServ.userDelete(userID,dep_id);
  }

}