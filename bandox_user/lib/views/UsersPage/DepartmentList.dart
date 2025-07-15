import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/data/cubit/DeptListCubit.dart';
import 'package:user_panel/views/UsersPage/RecognizePage.dart';

class DepartmentListPage extends StatefulWidget {
  final String user_id;

  const DepartmentListPage(this.user_id, {super.key});

  @override
  State<DepartmentListPage> createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {

  final _cardTextStyle = GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    context.read<DeptListCubit>().getDepartmentsOfUser(widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Image.asset("images/img2.png",fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

            ),
            BlocBuilder<DeptListCubit, List<Departments>>(
            builder: (context, listOfDepartments) {
              if (listOfDepartments.isNotEmpty) {
                return ListView.builder(
                  itemCount: listOfDepartments.length,
                  itemBuilder: (context, index) {
                    var department = listOfDepartments[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Recognizepage(department)));
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              department.dep_adi,
                              style: _cardTextStyle,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                );
              }
            },
                      ),]
        ));
  }
}
