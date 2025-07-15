import 'package:dep_manager_panel/views/AuthActions/SignOutPage.dart';
import 'package:dep_manager_panel/views/ManagerPages/ManagerActions/ManagerPage.dart';
import 'package:flutter/material.dart';


class BottombarPage extends StatefulWidget {
  String email;
  String sirket_id;

  BottombarPage(this.email, this.sirket_id, {super.key});

  @override
  State<BottombarPage> createState() => _BottombarPageState();
}

class _BottombarPageState extends State<BottombarPage> {

  late String email;
  late String sirket_id;
  var sayfaListesi = [];
  var secilenIndex = 0;

  @override
  void initState() {
    super.initState();
    sirket_id = widget.sirket_id;
    email = widget.email;
    sayfaListesi = [Managerpage(sirket_id),const SignoutPage()];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
          ),
        ],
          backgroundColor: Colors.deepOrange,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.white,
          currentIndex: secilenIndex,
          onTap: (newIndex){
            setState(() {
              secilenIndex = newIndex;
            });
          },
        ),
        body: sayfaListesi[secilenIndex]
    );
  }
}
