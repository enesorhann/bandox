import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebsServ {
  final _usersRef = FirebaseFirestore.instance.collection("Users");

  Future<void> userDelete(String userID, String dep_id) async {
    try {
      var userDoc = _usersRef.doc(userID);
      var user = await userDoc.get();

      if (!user.exists) {
        throw Exception("User does not exist");
      }

      // Mevcut departmanları alıyoruz
      var currentDepIds = List<String>.from(user['dep_ids'] ?? []);

      // Eğer yeni departmanlar eklenirse, bunları mevcut departmanlara ekliyoruz

      if (currentDepIds.contains(dep_id)) {
        currentDepIds.remove(dep_id);
      }

      await userDoc.update({"dep_ids": currentDepIds}); // Veriyi güncelle
    } catch (e) {
      print("Güncelleme sırasında hata oluştu: $e");
      throw Exception("Güncelleme başarısız");
    }
  }

/*
  Future<void> userGuncelle(
  String userID,
      {String? faceOfUser,
        String? userFname,
        String? userLname,
        String? user_tcNo,
        String? phone_number,
        List<String>? dep_ids,
        bool? isDepManager,
        String? user_ip,}
  ) async
  {

    var userDoc = await usersRef.doc(userID);
    var user = await userDoc.get();

    var currentDepIds = List<String>.from(user['dep_ids'] ?? []);

    if (dep_ids != null) {
      for (var depId in dep_ids) {
        if (!currentDepIds.contains(depId)) {
          currentDepIds.add(depId);
        }
      }
    }

    var info = HashMap<String,dynamic>();
    info["faceOfUser"] = faceOfUser;
    info["userFname"] = userFname;
    info["userLname"] = userLname;
    info["userTCno"] = user_tcNo;
    info["phoneNum"] = phone_number;
    info["dep_ids"] = currentDepIds;
    info["isDepManager"] = isDepManager;
    info["userIP"] = user_ip;

    await userDoc.update(info);

  }


 */

  Future<void> userGuncelle(
    String userID, {
    String? faceOfUser,
    String? userFname,
    String? userLname,
    String? user_tcNo,
    String? phone_number,
    List<String>? dep_ids,
    String? managerDepId,
    String? user_ip,
  }) async {
    try {
      var userDoc = _usersRef.doc(userID);
      var user = await userDoc.get();

      if (!user.exists) {
        throw Exception("User does not exist");
      }

      // Mevcut departmanları alıyoruz
      var currentDepIds = List<String>.from(user['dep_ids'] ?? []);

      // Eğer yeni departmanlar eklenirse, bunları mevcut departmanlara ekliyoruz
      if (dep_ids != null) {
        for (var depId in dep_ids) {
          if (!currentDepIds.contains(depId)) {
            currentDepIds.add(depId);
          }
        }
      }

      var info = <String, dynamic>{};
      if (faceOfUser != null) info["faceOfUser"] = faceOfUser;
      if (userFname != null) info["userFname"] = userFname;
      if (userLname != null) info["userLname"] = userLname;
      if (user_tcNo != null) info["userTCno"] = user_tcNo;
      if (phone_number != null) info["phoneNum"] = phone_number;
      info["dep_ids"] = currentDepIds;
      if (managerDepId != null) info["managerDepId"] = managerDepId;
      if (user_ip != null) info["userIP"] = user_ip;

      await userDoc.update(info); // Veriyi güncelle
    } catch (e) {
      print("Güncelleme sırasında hata oluştu: $e");
      throw Exception("Güncelleme başarısız");
    }
  }

  Future<void> userEkle(
    String faceOfUser,
    String userFname,
    String userLname,
    String userTcNo,
    String phoneNumber,
    String managerDepId,
    List<String> dep_ids, {
    String? userIp,
  }) async {
    var info = HashMap<String, dynamic>();
    info["userID"] = "";
    info["faceOfUser"] = faceOfUser;
    info["userFname"] = userFname;
    info["userLname"] = userLname;
    info["userTCno"] = userTcNo;
    info["phoneNum"] = phoneNumber;
    info["dep_ids"] = dep_ids;
    info["managerDepId"] = managerDepId;
    info["userIP"] = userIp;

    await _usersRef.add(info);
  }
}
