import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:dep_manager_panel/data/repo/ToDoFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoListCubit extends Cubit<List<ToDo>>{
  ToDoListCubit() : super(<ToDo>[]);

  final _TodoServ = TodoFirebsServ();

  void allJobsOfTheDepartment(String dep_id,int state) {

    FirebaseFirestore.instance.collection("Jobs")
        .orderBy("bitisTarihi",descending: false)
        .where("dep_id",isEqualTo: dep_id)
        .where("state",isEqualTo: state)
        .snapshots()
        .listen( (snapshot) {
      var jobList = snapshot.docs.map((doc) =>
          ToDo.fromJson(doc.id,doc.data())).toList();
      if(!isClosed){
        emit(jobList);
      }

    });
  }

  void searchToDepartment(String dep_id,String searchedWord,int state) {
    FirebaseFirestore.instance.collection("Jobs")
        .orderBy("bitisTarihi",descending: false)
        .where("state",isEqualTo: state)
        .where("dep_id",isEqualTo: dep_id)
        .snapshots()
        .listen( (snapshot) {
      var jobList = snapshot.docs.map((doc) =>
          ToDo.fromJson(doc.id,doc.data())).toList();
      var filteredList = jobList.where((job){
        return job.jobHead.toLowerCase().contains(searchedWord.toLowerCase());
      }).toList();
      emit(filteredList);
    });
  }

  Future<void> jobDelete(String jobID) async{
    await _TodoServ.jobDelete(jobID);
  }

}