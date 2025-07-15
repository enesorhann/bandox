import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoListCubit.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/CrudBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/theme/AppColors.dart';

Widget buildJobCard(ToDo job,BuildContext context,{bool checkState = false}){

  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final textStyle = GoogleFonts.poppins(
    fontSize: width/27,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  return GestureDetector(
    onTap: () {
      CrudBottomSheet()
          .showBottomSheet(context, 1, job: job);
    },
    child: Padding(
        padding: EdgeInsets.all(width/2000),
      child: Card(
        child: SizedBox(
          height: height/18,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  SizedBox(width: width*0.1,),
                 /* SizedBox(
                    width: width*0.1,
                    child: Checkbox(
                      side: const BorderSide(
                          color: Colors.black,
                          strokeAlign: 2,
                          style: BorderStyle.solid),
                      activeColor: Colors.green,
                      value: checkState,
                      onChanged: (value) {
                        setState(() {
                          checkState = value!;
                        });

                      },
                    ),
                  ),

                  */
                  Text(
                    maxLines: 30,
                    job.jobHead,
                    style: textStyle,
                  ),
                  IconButton(
                    onPressed: () async {
                      await ToDoListCubit().jobDelete(job.jobID);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blueGrey,
                      size: width/15,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}