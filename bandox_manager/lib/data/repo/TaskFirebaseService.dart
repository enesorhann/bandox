import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TaskFirebaseService {
  final _tasksRef = FirebaseFirestore.instance.collection("Tasks");

  Future<void> updateTask(
      String jobID,
      String taskID,
      String createdAt,
      String taskHeader,
      bool isAssigned, // userID-isAssigned
      String? taskTitle) async {
    var info = HashMap<String, dynamic>();
    info["jobID"] = jobID;
    info["createdAt"] = createdAt;
    info["taskHeader"] = taskHeader;
    info["isAssigned"] = isAssigned;
    info["taskID"] = taskID;
    info["taskTitle"] = taskTitle;

    await _tasksRef.doc(taskID).update(info);
  }


  Future<void> insertTask(
      String jobID,
      String createdAt,
      String taskHeader,
      bool isAssigned,
      String? taskTitle
  ) async {
    var info = HashMap<String, dynamic>();
    info["jobID"] = jobID;
    info["createdAt"] = createdAt;
    info["taskHeader"] = taskHeader;
    info["taskTitle"] = taskTitle;
    info["isAssigned"] = isAssigned;

    await _tasksRef.add(info);
  }
}
