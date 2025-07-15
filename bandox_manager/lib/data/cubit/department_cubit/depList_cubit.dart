import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/data/repo/DeptFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepListCubit extends Cubit<List<Departments>>{
  DepListCubit() : super(<Departments>[]);

  final _dFServ = DeptFirebsServ();
  final _deptsRef = FirebaseFirestore.instance.collection("Departments");
  var _managerRef = FirebaseFirestore.instance.collection("Yoneticiler");


  void sirkettekiDepartmanlar(String sirket_id) {
    _deptsRef
        .where("sirket_id",isEqualTo: sirket_id)
        .snapshots()
        .listen( (snapshot) {
      var departmentList = snapshot.docs.map((doc) =>
          Departments.fromJson(doc.id,doc.data())).toSet().toList();
      emit(departmentList);
    });

  }

/*

  Future<void> sirkettekiDepartmanlar(String sirket_id) async {
    var querySnapshot = await deptsRef.where("sirket_id",isEqualTo: sirket_id).get();
    var list = <Departments>[];

    try{
      for (var doc in querySnapshot.docs) {
        var dep_key = doc.id;
        var json = doc.data();
        var department = Departments.fromJson(dep_key, json);
        list.add(department);
      }
      emit(list);
    } catch(e){
      print(e.toString());
    }
  }


 */

  Future<void> deptDelete(String depID) async{
    await _dFServ.deptDelete(depID);
  }

}