import 'package:dep_manager_panel/data/cubit/PhotoCubit/StorageCubit.dart';
import 'package:dep_manager_panel/data/cubit/AuthCubit/EmailCubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/DepAdiCubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depDetay_cubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depKayit_cubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depList_cubit.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskInsertCubit.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskListCubit.dart';
import 'package:dep_manager_panel/data/cubit/taskCubit/TaskUpdateCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/GetUserWithAssignment.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoInsertCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoUpdateCubit.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersDetay_cubit.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersKayit_cubit.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:dep_manager_panel/views/AuthActions/LoginPage.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/firebase_options.dart';
import 'package:user_panel/theme/AppTheme.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UsersDetayCubit()),
        BlocProvider(create: (context) => UsersListCubit()),
        BlocProvider(create: (context) => UserKayitCubit()),
        BlocProvider(create: (context) => DepKayitCubit()),
        BlocProvider(create: (context) => DepDetayCubit()),
        BlocProvider(create: (context) => DepListCubit()),
        BlocProvider(create: (context) => EmailCubit()),
        BlocProvider(create: (context) => GetManagerCubit()),
        BlocProvider(create: (context) => DepAdiCubit()),
        BlocProvider(create: (context) => StorageCubit()),
        BlocProvider(create: (context) => ToDoListCubit()),
        BlocProvider(create: (context) => TodoUpdateCubit()),
        BlocProvider(create: (context) => TodoInsertCubit()),
        BlocProvider(create: (context) => GetUserWithAssignment()),
        BlocProvider(create: (context) => TaskListCubit()),
        BlocProvider(create: (context) => TaskUpdateCubit()),
        BlocProvider(create: (context) => TaskInsertCubit()),
      ],
      child: MaterialApp(
        title: 'Bandox HR',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: LoginPage(),
        //LoginPage()
      ),
    );
  }
}
