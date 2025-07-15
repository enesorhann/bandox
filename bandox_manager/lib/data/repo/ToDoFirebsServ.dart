import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFirebsServ {
  final _jobsRef = FirebaseFirestore.instance.collection("Jobs");

  Future<void> jobDelete(String jobID) async {
    await _jobsRef.doc(jobID).delete();
  }

  Future<void> jobUpdate(
    String jobID,
    String jobHead,
    int state,
    String? baslangicTarihi,
    String? bitisTarihi,
    double? gelir,
    double? gider,
    String? gelirAciklama,
    String? giderAciklama,
    String? jobDesc,
    Map<String, bool>? personIDs,
  ) async {
    var info = HashMap<String, dynamic>();
    info["baslangicTarihi"] = baslangicTarihi;
    info["bitisTarihi"] = bitisTarihi;
    info["state"] = state;
    info["gelir"] = gelir;
    info["gider"] = gider;
    info["gelirAciklama"] = gelirAciklama;
    info["giderAciklama"] = giderAciklama;
    info["jobDesc"] = jobDesc;
    info["jobHead"] = jobHead;
    info["personIDs"] = personIDs;
    await _jobsRef.doc(jobID).update(info);
  }

  Future<void> jobInsert(
    String jobID,
    String dep_id,
    String jobHead,
    int state,
    String? baslangicTarihi,
    String? bitisTarihi,
    double? gelir,
    double? gider,
    String? gelirAciklama,
    String? giderAciklama,
    String? jobDesc,
    Map<String, bool>? personIDs,
  ) async {
    var info = HashMap<String, dynamic>();
    info["dep_id"] = dep_id;
    info["baslangicTarihi"] = baslangicTarihi;
    info["bitisTarihi"] = bitisTarihi;
    info["state"] = state;
    info["gelir"] = gelir;
    info["gider"] = gider;
    info["gelirAciklama"] = gelirAciklama;
    info["giderAciklama"] = giderAciklama;
    info["jobDesc"] = jobDesc;
    info["jobHead"] = jobHead;
    info["personIDs"] = personIDs;
    await _jobsRef.doc(jobID).set(info);
  }
}
