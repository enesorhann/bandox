import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskInsertCubit.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskListCubit.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskUpdateCubit.dart';
import 'package:dep_manager_panel/data/entities/Task/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/theme/AppColors.dart';

class TaskListWidget extends StatefulWidget {
  final String jobID;
  final String titleText;
  const TaskListWidget({Key? key, required this.jobID, required this.titleText}) : super(key: key);

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final Map<String, TextEditingController> _controllers = {};
  TextEditingController _newTaskController = TextEditingController();

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    _newTaskController.dispose();
    super.dispose();
  }

  TextEditingController _getController(String taskID, String initialText) {
    if (!_controllers.containsKey(taskID)) {
      _controllers[taskID] = TextEditingController(text: initialText);
    }
    return _controllers[taskID]!;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _border = const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 1.5,
      ),
    );

    return Column(
      children: [
        BlocBuilder<TaskListCubit, List<Task>>(
          builder: (context, taskList) {
            if (taskList.isEmpty) return const SizedBox.shrink();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                var task = taskList[index];
                var controller = _getController(task.taskID, task.taskTitle!);
                return Padding(
                  key: ValueKey(task.taskID),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    color: AppColors.surface,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.15,
                          child: Checkbox(
                            key: ValueKey("checkbox_${task.taskID}"),
                            value: task.isAssigned,
                            onChanged: (bool? newValue) {
                              if (newValue == null) return;
                              var createdAt = Timestamp.now().toString();
                              TaskUpdateCubit().updateTask(
                                widget.jobID,
                                createdAt,
                                widget.titleText,
                                newValue,
                                task.taskID,
                                taskTitle: controller.text,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: width * 0.85,
                          child: TextField(
                            key: ValueKey("textfield_${task.taskID}"),
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Madde Ekle",
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: _border,
                            ),
                            onSubmitted: (item) {
                              var createdAt = Timestamp.now().toString();
                              TaskUpdateCubit().updateTask(
                                widget.jobID,
                                createdAt,
                                widget.titleText,
                                task.isAssigned,
                                task.taskID,
                                taskTitle: item,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(width: width * 0.15),
              SizedBox(
                width: width * 0.85,
                child: TextField(
                  controller: _newTaskController,
                  decoration: InputDecoration(
                    hintText: "Madde Ekle",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    border: _border,
                  ),
                  onSubmitted: (item) async {
                    if(item.trim().isEmpty) return;
                    var createdAt = Timestamp.now().toString();
                    await TaskInsertCubit().insertTask(
                      widget.jobID,
                      createdAt,
                      widget.titleText,
                      false,
                      taskTitle: item,
                    );
                    _newTaskController.clear();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
