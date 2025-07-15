
/*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/views/AuthActions/LoginScreen.dart';
import '../UsersPage/BottomBarViews/UserBottomBar.dart';

class WidgetTreePage extends StatefulWidget {
  const WidgetTreePage({super.key});

  @override
  State<WidgetTreePage> createState() => _WidgetTreePageState();
}

class _WidgetTreePageState extends State<WidgetTreePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return UserBottomBar();
        }else{
          return const LoginScreen();
        }
      },
    );
  }
}


 */
