import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/UsersViews/UpdateSayfasi.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/UsersViews/UserKayitSayfasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class UsersListPage extends StatefulWidget {
  Departments department;

  UsersListPage(this.department, {super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

  final _textStyle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );


  @override
  void initState() {
    context
        .read<UsersListCubit>()
        .departmandakiKullanicilar(widget.department.dep_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Persons of ${widget.department.dep_adi}",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
      ),
      body: BlocBuilder<UsersListCubit, List<Users>>(
        builder: (context, userList) {
          if (userList.isNotEmpty) {
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var user = userList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateSayfasi(
                                user: user, dep: widget.department)));
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: SizedBox(
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user.userFname} ${user.userLname}",
                                      style: _textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 70,
                                ),
                                IconButton(
                                  highlightColor: Colors.lightBlueAccent,
                                  onPressed: () {
                                    context.read<UsersListCubit>().userDelete(
                                        user.userID!, widget.department.dep_id);
                                  },
                                  icon: const Icon(
                                    size: 44,
                                    Icons.delete,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserKayitSayfasi(widget.department)));
        },
        label: const Text(
          "ADD",
        ),
        tooltip: "ADD",
        icon: const Icon(
          Icons.add,
          size: 27,
        ),
      ),
    );
  }
}
