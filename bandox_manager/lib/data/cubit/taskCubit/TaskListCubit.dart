import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/entities/Task/Task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListCubit extends Cubit<List<Task>> {
  TaskListCubit() : super(<Task>[]);

  final _tasksRef = FirebaseFirestore.instance.collection("Tasks");

  void getTaskList(String? jobID) {
    _tasksRef
        .where("jobID", isEqualTo: jobID)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      var taskList = snapshot.docs
          .map((doc) => Task.fromJson(doc.id, doc.data()))
          .toList();
      print("TaskList Length -> ${taskList.length}");
      emit(taskList);
    });
  }
}
