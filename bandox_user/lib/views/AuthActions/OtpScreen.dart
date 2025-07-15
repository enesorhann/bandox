import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:user_panel/data/cubit/AuthCubit/AuthCubit.dart';
import '../UsersPage/BottomBarViews/UserBottomBar.dart';

class OtpScreen extends StatefulWidget {
  final String verificationID;
  final String phoneNum;

  const OtpScreen(this.verificationID, this.phoneNum, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var otpController = TextEditingController();
  var pinTheme = PinTheme(
      width: 55,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 25));

  Future<String> getUserID() async {
    var getAuthCubit = context.read<AuthCubit>();
    await getAuthCubit.saveUserID(widget.phoneNum);
    var user_id = getAuthCubit.state;
    return user_id;
  }

  Future<void> verifyOtp() async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: widget.verificationID,
              smsCode: otpController.text));

      if (credentials.user != null) {
        var user_id = await getUserID();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserBottomBar(user_id)));
      } else {
        otpController.text = "";
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        child: Image.asset(
                          fit: BoxFit.fitWidth,
                          "images/pho1.png",
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                        ),
                      ),
                    ),
                    Text(
                      "Enter code",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "We've sent an SMS with an activation code to your phone\n"
                              "${widget.phoneNum}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    Pinput(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      keyboardType: TextInputType.number,
                      focusNode: FocusNode(),
                      autofocus: true,
                      controller: otpController,
                      length: 6,
                      defaultPinTheme: pinTheme,
                      focusedPinTheme: pinTheme.copyWith(
                        decoration: pinTheme.decoration!.copyWith(
                            border: Border.all(color: Colors.greenAccent),
                            color: Colors.greenAccent),
                      ),
                      disabledPinTheme: pinTheme,
                      showCursor: true,
                      onCompleted: (value) {
                        debugPrint(value);
                        verifyOtp();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
