import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/data/repo/DeptFirebsServ.dart';

class YoneticiFirebsServ{

  var managerRef = FirebaseFirestore.instance.collection("Yoneticiler");
  var departmentRef = FirebaseFirestore.instance.collection("Departments");
  var deptFirebsServ = DeptFirebsServ();

  Future<void> managerDelete(String sirket_id) async{
    var querySnapshot = await departmentRef.where("sirket_id",isEqualTo: sirket_id).get();

    if(querySnapshot.docs.isNotEmpty){
      for (var doc in querySnapshot.docs) {
        var department = Departments.fromJson(doc.id, doc.data());
        await deptFirebsServ.deptDelete(department.dep_id);
      }
    }
    await managerRef.doc(sirket_id).delete();
  }

  Future<void> managerGuncelle(
      String sirket_id,
      String sirket_ad,
      String yonetici_fName,
      String yonetici_lName,
      String yonetici_mail,
      ) async{
    var  info = HashMap<String,dynamic>();
    info["sirket_ad"] = sirket_ad;
    info["yonetici_fName"] = yonetici_fName;
    info["yonetici_lName"] = yonetici_lName;
    info["yonetici_mail"] = yonetici_mail;
    await managerRef.doc(sirket_id).update(info);
  }

  Future<void> managerEkle(
      String sirket_ad,
      String yonetici_fName,
      String yonetici_lName,
      String yonetici_mail,
      ) async{
    var  info = HashMap<String,dynamic>();
    info["sirket_id"] = "";
    info["sirket_ad"] = sirket_ad;
    info["yonetici_fName"] = yonetici_fName;
    info["yonetici_lName"] = yonetici_lName;
    info["yonetici_mail"] = yonetici_mail;
    await managerRef.add(info);
  }

}