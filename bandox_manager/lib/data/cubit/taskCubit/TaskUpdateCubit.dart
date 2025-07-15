
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dep_manager_panel/data/repo/TaskFirebaseService.dart';

class TaskUpdateCubit extends Cubit<void> {
  TaskUpdateCubit() : super(0);

  final _taskService = TaskFirebaseService();

  Future<void> updateTask(
      String jobID,
      String createdAt,
      String taskHeader,
      bool isAssigned,
      String taskID,
      {
    String? taskTitle,
  }) async{

      await _taskService.updateTask(
          jobID,
          taskID,
          createdAt,
          taskHeader,
          isAssigned,
          taskTitle
      );

  }

}