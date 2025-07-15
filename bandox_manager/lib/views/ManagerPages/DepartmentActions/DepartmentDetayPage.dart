import 'package:dep_manager_panel/data/cubit/department_cubit/depDetay_cubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentDetayPage extends StatefulWidget {

  final Departments department;
  DepartmentDetayPage(this.department);

  @override
  State<DepartmentDetayPage> createState() => _DepartmentDetayPageState();
}

class _DepartmentDetayPageState extends State<DepartmentDetayPage> {

  var departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    departmentController.text = widget.department.dep_adi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.close)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: departmentController,
                decoration: InputDecoration(
                    label: const Text(
                      "Department Name",
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var dep_adi = departmentController.text;
                context.read<DepDetayCubit>().depGuncelle(widget.department.dep_id, dep_adi);
                Navigator.pop(context);
              },
              child: const Text("Guncelle"),
            )
          ],
        ),
      ),
    );
  }
}

