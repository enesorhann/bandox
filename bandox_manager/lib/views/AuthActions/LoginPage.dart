import 'package:dep_manager_panel/views/AuthActions/Auth.dart';
import 'package:dep_manager_panel/views/ManagerPages/ManagerActions/ManagerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/cubit/AuthCubit/EmailCubit.dart';
import '../../data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var errorMessage = "";
  var formKey = GlobalKey<FormState>();
  var focusNode = FocusNode();
  var iconImg = "images/hidden.png";
  var boolObscure = true;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await Auth().signInWithEmailAndPassword(email: email, password: password);
      context.read<EmailCubit>().emailKayit(email);
      var getManagerCubit = context.read<GetManagerCubit>();
      await getManagerCubit.yoneticiBul(email);
      var sirketID = getManagerCubit.state!.sirket_id;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Managerpage(sirketID)));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${errorMessage}")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width - 50,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                label: Text(
                                  "E-mail",
                                ),

                              ),
                              validator: (input) {
                                if (input != null) {
                                  if (input.isEmpty) {
                                    return "Lutfen mailinizi giriniz!";
                                  }
                                  final RegExp emailRegex = RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.([a-zA-Z]{2,})$');

                                  if (!emailRegex.hasMatch(input)) {
                                    return "Lütfen geçerli bir e-mail adresi giriniz!";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: width-50,
                            child: TextFormField(
                              focusNode: focusNode,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              decoration: InputDecoration(
                                label: const Text(
                                  "Password"
                                ),
                                suffix: GestureDetector(
                                  onTap: (){
                                      setState(() {
                                        if (iconImg == "images/view.png") {
                                          iconImg = "images/hidden.png";
                                          boolObscure = true;
                                        } else {
                                          iconImg = "images/view.png";
                                          boolObscure = false;
                                        }
                                      });
                                  },
                                  child: ImageIcon(
                                      AssetImage(iconImg),
                                      size: 27,
                                      color: boolObscure
                                          ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.7)
                                          : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.8),
                                    ),
                                ),
                              ),
                              obscureText: boolObscure,
                              validator: (input) {
                                if (input != null) {
                                  if (input.isEmpty) {
                                    return "Lutfen sifrenizi giriniz!";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.validate();
                      var email = emailController.text;
                      var password = passwordController.text;
                      signInWithEmailAndPassword(email, password);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: const Text("Sign in"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
