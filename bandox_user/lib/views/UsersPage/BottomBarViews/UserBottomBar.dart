import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/views/UsersPage/DepartmentList.dart';
import 'package:user_panel/views/UsersPage/ProfileViews/ProfileMain.dart';

class UserBottomBar extends StatefulWidget {
  final String user_id;

  UserBottomBar(this.user_id, {super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  var sayfaListesi = [];
  var secilenIndex = 0;

  /*Future<void> get_ip() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(data.toString())));
  }

   */

  @override
  void initState() {
    //get_ip();
    sayfaListesi = [DepartmentListPage(widget.user_id), const ProfileMain()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Home",
            backgroundColor: Colors.green,
              tooltip: "Home"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile",
          backgroundColor: Colors.green,
          tooltip: "Profile"
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
        selectedLabelStyle: Theme.of(context).textTheme.titleLarge,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        currentIndex: secilenIndex,
        onTap: (newIndex) {
          setState(() {
            secilenIndex = newIndex;
          });
        },
                  ),
        body: sayfaListesi[secilenIndex],
    );
  }
}
