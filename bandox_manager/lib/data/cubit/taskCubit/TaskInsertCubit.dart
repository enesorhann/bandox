import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/repo/TaskFirebaseService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskInsertCubit extends Cubit<void> {
  TaskInsertCubit() : super(0);

  final _taskService = TaskFirebaseService();

  Future<void> insertTask(
    String jobID,
    String createdAt,
    String taskHeader,
    bool isAssigned, {
    String? taskTitle,
  }) async {

    await _taskService.insertTask(
        jobID, createdAt, taskHeader, isAssigned, taskTitle);
  }
}
