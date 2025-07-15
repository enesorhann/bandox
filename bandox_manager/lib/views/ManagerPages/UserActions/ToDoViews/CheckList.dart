import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> updateHeader(String text,String jobID) async{
  await FirebaseFirestore.instance.collection("Tasks")
      .doc(jobID)
      .update(
    {
      "taskHeader" : text
    }
  );
}


Widget CustomCheckList(TextEditingController titleController,String jobID) {
  return TextField(
    maxLines: 1,
    minLines: 1,
    controller: titleController,
    decoration: const InputDecoration(
      filled: true,
    ),
    onSubmitted: (text) async{
      await updateHeader(text,jobID);
    },
  );
}
