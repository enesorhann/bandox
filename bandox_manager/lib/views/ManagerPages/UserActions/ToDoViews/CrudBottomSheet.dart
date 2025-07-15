import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/ToDoDetails.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/ToDoRegistration.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CrudBottomSheet {

  final _curve = Curves.easeInOut;
  final _duration = const Duration(milliseconds: 500);

  void showBottomSheet(BuildContext context,int toPage, {ToDo? job,String? dep_id,String? header,int? job_state}){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape:  const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))
      ),
      sheetAnimationStyle: AnimationStyle(curve: _curve,duration: _duration,
          reverseCurve: _curve,reverseDuration: _duration
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          initialChildSize: 0.9,
          builder: (context, scrollController) {
            return (toPage == 0) ? ToDoRegistration(dep_id!, header!, job_state!) : ToDoDetails(job!);
          },);
      },
    );
  }

}