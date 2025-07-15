import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:user_panel/theme/AppColors.dart';
import 'package:user_panel/views/AuthActions/OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phoneController = TextEditingController();
  late String phoneNumber = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  Country? country;

  var border =  const OutlineInputBorder(
      borderSide: BorderSide(
    color: AppColors.primary,
    width: 2.0,
    style: BorderStyle.solid,
  ));

  Future ShowDialog(BuildContext context,String countryCode, String phoneNumber) {
    final phone = "$countryCode$phoneNumber";
    print(phone);
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 3),
                child: Container(
                  color: Colors.transparent.withValues(alpha: 0.5),
                ),
              ),
            ),
            AlertDialog(
              title: Text(
                "Is this the correct number?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                "$countryCode ${formatPhoneNumber(phoneNumber)}",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Edit",
                    )
                ),
                TextButton(
                    onPressed: () {
                      phoneAuthentication(phone);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Yes",
                    )),
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
            ),
          ],
        );
      },
    );
  }

  Future<void> phoneAuthentication(String phoneNo) async {

    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("phoneNum", isEqualTo: phoneNo)
        .get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Boyle bir telefon numarasi bulunamadi")));
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (phoneAuthCredential) async {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await currentUser.updatePhoneNumber(phoneAuthCredential);
        }
      },
      verificationFailed: (error) {
        if (error.code == "invalid-phone-number") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error,The provided phone number is not valid")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${error.code},${error.message}. Try Again!")));
        }
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId, phoneNo)));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Otomatik doğrulama zaman aşımına uğradı. Lütfen kodu manuel olarak giriniz.")));
      },
    );
  }

  void showPicker() {
    showCountryPicker(
        showPhoneCode: true,
        context: context,
        favorite: ["TR", "USA", "US"],
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: Colors.black87,
          textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          bottomSheetHeight: 500,
          // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          searchTextStyle: const TextStyle(color: Colors.blueGrey),
          inputDecoration: InputDecoration(
              hintText: 'Search yur country here..',
              hintStyle: const TextStyle(color: Colors.black45),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white70,
              ),
              border: border,
              focusedBorder: border),
        ),
        onSelect: (Country country) {
          setState(() {
            this.country = country;
          });
        });
  }

  Future<void> fetchCountryCode() async {
    final response = await get(Uri.parse("http://ip-api.com/json"));
    final body = jsonDecode(response.body);
    var country = body["countryCode"];
    setState(() {
      this.country = CountryParser.parseCountryCode(country);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCountryCode();
  }

  String formatPhoneNumber(String text){

    final digits = text.replaceAll(RegExp(r'\D'), '' );
    final buffer = StringBuffer();
    phoneNumber = text;

    for(int i=0;i<10 && i<text.length;i++){

      if(i==3 || i==6 || i==8) buffer.write('-');
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Image.asset("images/appicon.png"),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: this.country == null
                    ?  CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      onFieldSubmitted: (_) async {
                        var countryCode = "+${country!.phoneCode}";
                        await ShowDialog(context,countryCode,phoneNumber);
                      },
                      focusNode: FocusNode(),
                      autofocus: true,
                      controller: phoneController,
                      showCursor: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                          hoverColor: Colors.white,
                          enabledBorder: border,
                          focusedBorder: border,
                          prefixIcon: GestureDetector(
                            onTap: showPicker,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                width: 100,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  "${country!.flagEmoji}  +${country!.phoneCode}    |",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue,newValue){
                          final formatted = formatPhoneNumber(newValue.text);

                          int offset = formatted.length;
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: offset)
                          );
                        }),
                      ],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
