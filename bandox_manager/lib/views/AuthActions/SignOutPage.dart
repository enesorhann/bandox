import 'package:dep_manager_panel/views/AuthActions/Auth.dart';
import 'package:dep_manager_panel/views/AuthActions/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubit/AuthCubit/EmailCubit.dart';

class SignoutPage extends StatefulWidget {
  const SignoutPage({super.key});

  @override
  State<SignoutPage> createState() => _SignoutPageState();
}

class _SignoutPageState extends State<SignoutPage> {

  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Sign-Out Sayfasi",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              context.read<EmailCubit>().emailSil();
              signOut();
            },
                child: Text("Sign-Out"),
            )
          ],
        ),
      )

    );
  }
}
