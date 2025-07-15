import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/cubit/department_cubit/depKayit_cubit.dart';

class DepartmentKayitSayfasi extends StatelessWidget {
  var departmentController = TextEditingController();

  DepartmentKayitSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    var sirket_id = context.watch<GetManagerCubit>().state!.sirket_id;
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
                        borderRadius: BorderRadius.circular(20.0),
                    ),

                ),
              ),
            ),
            ElevatedButton(

              onPressed: () {
                var dep_adi = departmentController.text;
                context.read<DepKayitCubit>().depEkle(dep_adi, sirket_id);
                Navigator.pop(context);
              },
              child: const Text("Departman Ekle",),
            )
          ],
        ),
      ),
    );
  }
}
