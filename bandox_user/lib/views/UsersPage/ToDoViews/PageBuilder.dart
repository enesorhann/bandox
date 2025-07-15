import 'dart:math';

import 'package:dep_manager_panel/Constants/Consts.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoListCubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/DonePage.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/PageViewContent.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/ToDoList.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/WipList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageBuild extends StatefulWidget {
  final Departments department;

  const PageBuild({super.key, required this.department});

  @override
  State<PageBuild> createState() => _PageBuildState();
}

class _PageBuildState extends State<PageBuild>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> rotateAnimation;
  late Animation<double> scaleAnimation;
  bool fabDurum = false;
  Color backgroundColor = Colors.greenAccent;
  Color foregroundColor = Colors.white;
  bool checkState = false;
  bool isSearched = false;
  final _searchController = TextEditingController();
  int stateIndex = 0;
  bool isZoomedOut = false;
  var todoListCubit = ToDoListCubit();
  var wipListCubit = ToDoListCubit();
  var doneListCubit = ToDoListCubit();
  final _scrollController = ScrollController();
  late AnimationController _zoomController;

  @override
  void dispose() {
    animationController.dispose();
    _searchController.dispose();
    todoListCubit.close();
    wipListCubit.close();
    doneListCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    rotateAnimation =
    Tween(begin: 0.0, end: pi / 4).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    todoListCubit.allJobsOfTheDepartment(widget.department.dep_id, 0); // To Do
    wipListCubit.allJobsOfTheDepartment(widget.department.dep_id, 1);  // WIP
    doneListCubit.allJobsOfTheDepartment(widget.department.dep_id, 2);

    _scrollController.addListener(_updateStateIndexBasedOnScroll);

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }


  ToDoListCubit getCurrentCubit(){
    if (stateIndex == 0) {
      return todoListCubit;
    } else if (stateIndex == 1) {
      return wipListCubit;
    } else {
      return doneListCubit;
    }
  }

  void _updateStateIndexBasedOnScroll() {
    if (isZoomedOut) {
      double offset = _scrollController.offset;
      double itemWidth = MediaQuery.of(context).size.width * 0.7 + 16;
      int newIndex = (offset / itemWidth).round();

      if (newIndex != stateIndex) {
        setState(() {
          stateIndex = newIndex.clamp(0, 2);
        });
      }
    } else {
      // PageView modundayız
      int newIndex = pageController.hasClients ? pageController.page?.round() ?? 0 : 0;
      if (newIndex != stateIndex) {
        setState(() {
          stateIndex = newIndex.clamp(0, 2);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 50,
        title: isSearched != true
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.department.dep_adi} Panosu",
            ),
          ],
        )
            : Card(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Search your jobs",
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              getCurrentCubit().searchToDepartment(
                  widget.department.dep_id, value, stateIndex);
            },
          ),
        ),
        leading: isSearched != true
            ? Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        )
            : const SizedBox.shrink(),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearched = !isSearched;
                      _searchController.clear();
                    });
                    if (isSearched == false) {
                      getCurrentCubit().allJobsOfTheDepartment(widget.department.dep_id, stateIndex);
                    }
                  },
                  icon: const Icon(Icons.manage_search_sharp)),
            ],
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: _zoomController,
        builder: (context, child) {
          double width = MediaQuery.of(context).size.width;
          double pageWidth = width * 0.7; // Orijinal genişlik

          return isZoomedOut ?
          InteractiveViewer(
              panEnabled: true,
              maxScale: 4.0,
              minScale: 0.2,
              boundaryMargin: EdgeInsets.all(width/20),
              scaleEnabled: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: pageWidth,
                      child: BlocProvider.value(
                          value: todoListCubit,
                          child: ToDoListOfDepartment(widget.department,state: 0,)),
                    ),
                    const SizedBox(width: 16,),
                    SizedBox(
                      width: pageWidth,
                      child: BlocProvider.value(
                          value: wipListCubit,
                          child: WipList(widget.department,state: 1,)),
                    ),
                    const SizedBox(width: 16,),
                    SizedBox(
                      width: pageWidth,
                      child: BlocProvider.value(
                          value: doneListCubit,
                          child: DonePage(widget.department,state: 2,)),
                    ),

                  ],
                ),
              )
          )

              : PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                stateIndex = index;
              });
              _searchController.clear();
              getCurrentCubit().allJobsOfTheDepartment(widget.department.dep_id, stateIndex);
            },
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              ToDoListCubit cubit;
              if (index == 0) {
                cubit = todoListCubit;
              } else if (index == 1) {
                cubit = wipListCubit;
              } else {
                cubit = doneListCubit;
              }
              return BlocProvider.value(
                  value: cubit,
                  child: PageViewContent(index, widget.department));
            },
          );
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                isZoomedOut = !isZoomedOut;
              });

              if (isZoomedOut) {
                _zoomController.forward(from: 0.0);

                // Zoom-out açıldığında scroll pozisyonunu ayarla
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  double itemWidth = MediaQuery.of(context).size.width * 0.7 + 16;
                  double newOffset = stateIndex * itemWidth;

                  _scrollController.jumpTo(newOffset);
                });
              } else {
                _zoomController.reverse();
                // Zoom kapatıldığında pageview doğru sayfaya gelsin
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  pageController.jumpToPage(stateIndex);
                });
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(isZoomedOut ? Icons.zoom_out : Icons.zoom_in),
            ),
          ),
        ],
      ),

    );
  }
}
