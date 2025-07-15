import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class UsersDaoRepo{

  var usersRef = FirebaseFirestore.instance.collection("Users");
  var deptsRef = FirebaseFirestore.instance.collection("Departments");


  // userID ile bulundugu departmanlarin id listesini alma
  Future<List<Departments>> getDepartmentIDsOfUser(String userID) async{
    var userSnapshot =  await usersRef.doc(userID).get();
    var deptList = <Departments>[];

    try{
      if(userSnapshot.exists){
        var userJson = userSnapshot.data();
        var user = Users.fromJson(userID, userJson!);
        deptList = await kullanicininDepartmanlari(user.dep_ids);
      }

    } on FirebaseException catch(e){
      print(e.toString());
    }
    return deptList;
  }

  // bulundugu departmanlar
  Future<List<Departments>> kullanicininDepartmanlari(List<String>? depIds) async{
    var deptList = <Departments>[];

    if(depIds != null){
      for(var depId in depIds){
        var deptsSnapshot =  await deptsRef.doc(depId).get();
        if(deptsSnapshot.exists){
          var deptJson = deptsSnapshot.data();
          var department = Departments.fromJson(depId, deptJson!);
          deptList.add(department);
          //deptList.map((e) => e.dep_adi);
        }
      }
    }
    return deptList;
  }

}