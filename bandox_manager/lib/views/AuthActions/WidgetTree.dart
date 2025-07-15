import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';
import 'package:dep_manager_panel/views/AuthActions/Auth.dart';
import 'package:dep_manager_panel/views/AuthActions/LoginPage.dart';
import 'package:dep_manager_panel/views/ManagerPages/ManagerActions/ManagerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            /* var email = context.watch<EmailCubit>().state; */
            var sirket_id = context.watch<GetManagerCubit>().state!.sirket_id;
            return Managerpage(sirket_id);
          }else{
            return LoginPage();
          }
        },
    );
  }
}
