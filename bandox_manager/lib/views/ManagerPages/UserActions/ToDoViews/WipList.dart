import 'package:dep_manager_panel/Constants/Consts.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoInsertCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoUpdateCubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/BuildJobCard.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/CustomField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CrudBottomSheet.dart';

class WipList extends StatefulWidget {
  final Departments department;
  final int state;

  WipList(this.department, {super.key, required this.state});

  @override
  State<WipList> createState() => _WipListState();
}

class _WipListState extends State<WipList> with TickerProviderStateMixin {
  bool fabDurum = false;
  Color backgroundColor = Colors.greenAccent;
  Color foregroundColor = Colors.white;
  bool checkState = false;
  bool isSearched = false;
  var searchController = TextEditingController();
  bool isAdding = false;
  var addingController = TextEditingController();
  final _textStyle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: DragTarget<ToDo>(
        onWillAcceptWithDetails: (DragTargetDetails<ToDo> details) {
          return details.data.state != widget.state;
        },
        onAcceptWithDetails: (DragTargetDetails<ToDo> details) {
          ToDo job = details.data;
          setState(() {
            job.state = widget.state;
          });
          context
              .read<TodoUpdateCubit>()
              .jobUpdate(job.jobID, job.jobHead, job.state);

          context
              .read<ToDoListCubit>()
              .allJobsOfTheDepartment(job.dep_id!, widget.state);

        },
        builder: (context, candidateData, rejectedData) {
          return SingleChildScrollView(
            child: BlocBuilder<ToDoListCubit, List<ToDo>>(
              builder: (context, jobList) {
                return Padding(
                  padding: EdgeInsets.all(width/100),
                  child: Card(
                    elevation: 7.7,
                    color: Colors.yellow.shade900.withValues(alpha: 1.3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                             SizedBox(
                              width: width/20,
                              height: height/50,
                            ),
                            Text(
                              "Yapılıyor",
                              style: _textStyle,
                            ),
                          ],
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: jobList.length,
                            itemBuilder: (context, index) {
                              var job = jobList[index];
                              return Draggable<ToDo>(
                                data: job,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Opacity(
                                      opacity: 0.8,
                                      child: buildJobCard(job, context)),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.4,
                                  child: buildJobCard(job, context),
                                ),
                                onDragUpdate: (details) {
                                  var positionX = details.globalPosition.dx;
                                  if (positionX > width * 0.90 &&
                                      pageController.page!.round() < 2) {
                                    pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut
                                    );
                                  }else if(positionX < width * 0.10 &&
                                      pageController.page!.round() > 0){
                                    pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut
                                    );
                                  }
                                },
                                child: buildJobCard(job, context),
                              );
                            },
                          ),
                        ),
                        isAdding == true
                            ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: width/2.2,
                                  height: height/15,
                                  child: TextFld(addingController, "")),
                              IconButton(
                                onPressed: () {
                                  CrudBottomSheet().showBottomSheet(
                                    context,
                                    0,
                                    dep_id: widget.department.dep_id,
                                    header: addingController.text,
                                    job_state: 1,
                                  );
                                  setState(() {
                                    isAdding = false;
                                    addingController.clear();
                                  });
                                },
                                icon: Icon(
                                  size: width/18,
                                  Icons.zoom_out_map,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        )
                            : const SizedBox.shrink(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAdding = true;
                            });
                          },
                          child: isAdding == false
                              ? Text(
                            " + Kart Ekle",
                            style: _textStyle,
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isAdding = false;
                                    addingController.clear();
                                  });
                                },
                                child: Text(
                                  "İptal",
                                  style: _textStyle,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await TodoInsertCubit().jobInsert(
                                      widget.department.dep_id,
                                      addingController.text,
                                      1);
                                  setState(() {
                                    isAdding = false;
                                    addingController.clear();
                                  });
                                },
                                child: Text(
                                  "Ekle",
                                  style: _textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
