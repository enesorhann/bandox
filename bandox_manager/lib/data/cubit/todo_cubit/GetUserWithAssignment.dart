import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUserWithAssignment extends Cubit<Map<String, bool>> {
  GetUserWithAssignment() : super({});

  final _jobsRef = FirebaseFirestore.instance.collection("Jobs");

  Future<void> oneJobOfTheDepartmentWithListen(String jobID) async {
    _jobsRef
        //jobID = depID_state_jobHeader
        .doc(jobID)
        .snapshots()
        .listen((snapshot) {
      /*if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        var task = ToDo.fromJson(doc.id, doc.data()).personIDs;
        if (task != null) {
          print("TASK -> ${task}");
          emit(task);
        }
      } */
    });
  }

  Future<void> oneJobOfTheDepartmentWithGet(String jobID) async {
    print("Aranan jobID -> ${jobID}");

    try {
      var docSnapshot = await _jobsRef.doc(jobID).get();

      print("Doc ID -> ${docSnapshot.id}");
      print(
          "Doc DATA -> ${ToDo.fromJson(docSnapshot.id, docSnapshot.data() as Map<String, dynamic>).jobHead}");
      print("${docSnapshot} loglama get ile");

      final todo = ToDo.fromJson(
          docSnapshot.id, docSnapshot.data() as Map<String, dynamic>);

      if (todo.personIDs != null) {
        emit(todo.personIDs!);
      } else {
        emit({});
        print("Query Snapshot boş döndü");
      }
    } catch (e) {
      print("Hata Mesaji -> " + e.toString());
      emit({});
    }
  }
}
