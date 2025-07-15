import 'package:dep_manager_panel/data/cubit/taskCubit/TaskListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/GetUserWithAssignment.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoInsertCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoUpdateCubit.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/cubit/AuthCubit/AuthCubit.dart';
import 'package:user_panel/data/cubit/DeptListCubit.dart';
import 'package:user_panel/firebase_options.dart';
import 'package:user_panel/theme/AppTheme.dart';
import 'package:user_panel/views/AuthActions/LoginScreen.dart';
import 'package:user_panel/views/AuthActions/WidgetTreePage.dart';

void main() async {
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
        BlocProvider(create: (context) => DeptListCubit()),
        BlocProvider(create: (context) => UsersListCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ToDoListCubit()),
        BlocProvider(create: (context) => GetUserWithAssignment()),
        BlocProvider(create: (context) => TaskListCubit()),
        BlocProvider(create: (context) => TodoInsertCubit()),
        BlocProvider(create: (context) => TodoUpdateCubit()),
      ],
      child: MaterialApp(
        locale: const Locale("TR"),
        title: 'Bandox:Görev Takibi',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home:  const LoginScreen()
      ),
    );
  }
}
