import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/DonePage.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/ToDoList.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/WipList.dart';
import 'package:flutter/material.dart';

class PageViewContent extends StatelessWidget {
  final int stateIndex;
  final Departments department;

  const PageViewContent(this.stateIndex, this.department, {super.key});

  @override
  Widget build(BuildContext context) {

    switch (stateIndex) {
      case 0:
        return ToDoListOfDepartment(department, state: 0);
      case 1:
        return WipList(department, state: 1);
      case 2:
        return DonePage(department, state: 2);
      default:
        return Container();
    }
  }

}
