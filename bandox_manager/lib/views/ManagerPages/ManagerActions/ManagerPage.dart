import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/DepAdiCubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depList_cubit.dart';
import 'package:dep_manager_panel/views/ManagerPages/DepartmentActions/DepartmentDetayPage.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/PageBuilder.dart';
import 'package:dep_manager_panel/views/ManagerPages/DepartmentActions/DepartmentKayitSayfasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';
import '../../../data/entities/Departments/Departments.dart';

class Managerpage extends StatefulWidget {
  String sirket_id;

  Managerpage(this.sirket_id, {super.key});

  @override
  State<Managerpage> createState() => _ManagerpageState();
}

class _ManagerpageState extends State<Managerpage> {

  final _textStyle = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  );
  final _popUpTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    context.read<DepListCubit>().sirkettekiDepartmanlar(widget.sirket_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${context.watch<GetManagerCubit>().state!.sirket_ad} Departmanlari",
        ),
      ),
      body: BlocBuilder<DepListCubit, List<Departments>>(
        builder: (context, listOfDepartments) {
          if (listOfDepartments.isEmpty) {
            return  Center(
                child: Text('Hiçbir departman bulunamadı.',
                    style: Theme.of(context).textTheme.titleLarge
                )
            ); // Boş liste
          } else {
            return ListView.builder(
              itemCount: listOfDepartments.length,
              itemBuilder: (context, index) {
                var department = listOfDepartments[index];
                return GestureDetector(
                  onTap: () {
                    context.read<DepAdiCubit>().saveDepName(department.dep_adi);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PageBuilder(department: department)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 150,
                                ),
                                Text(
                                  department.dep_adi,
                                  style: _textStyle
                                ),
                              ],
                            ),
                            PopupMenuButton<int>(
                              color: Colors.white.withValues(alpha: 0.9),
                              iconColor: Colors.white,
                              elevation: 15,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text("Sil",
                                      style: _popUpTextStyle
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text("Güncelle",
                                      style: _popUpTextStyle
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 0:
                                    context
                                        .read<DepListCubit>()
                                        .deptDelete(department.dep_id);
                                    break;
                                  case 1:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DepartmentDetayPage(department),
                                      ),
                                    );
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DepartmentKayitSayfasi()),
          );
        },
        tooltip: "ADD",
        child: const Icon(
          Icons.add,
          size: 44,
        ),
      ),
    );
  }
}
