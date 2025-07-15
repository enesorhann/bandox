import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/PersonBottomSheet.dart';
import 'package:flutter/material.dart';

class UserListToTask {


  final _curve = Curves.easeInOut;
  final _duration = const Duration(milliseconds: 500);

  Future<Map<String,bool>> showPerson(BuildContext context,String jobID,String depId) async{
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black45.withValues(alpha: 3.5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10) ),
        side: BorderSide(color: Colors.black)
      ),
      sheetAnimationStyle: AnimationStyle(curve: _curve,duration: _duration,
          reverseCurve: _curve,reverseDuration: _duration
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return PersonBottomSheet(jobID: jobID,depID: depId);
        },
      ),
    );
    return result ?? {};
    }
}