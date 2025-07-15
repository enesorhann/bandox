import 'package:dep_manager_panel/data/cubit/taskCubit/TaskListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoUpdateCubit.dart';
import 'package:dep_manager_panel/data/entities/Task/Task.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/CheckList.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/TaskListWidget.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/UserListToTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoDetails extends StatefulWidget {
  final ToDo job;

  const ToDoDetails(this.job, {super.key});

  @override
  State<ToDoDetails> createState() => _ToDoDetailsState();
}

class _ToDoDetailsState extends State<ToDoDetails> {
  var basTarihiController = TextEditingController();
  var btsTarihiController = TextEditingController();
  var gelirController = TextEditingController();
  var gelirAciklamaController = TextEditingController();
  var giderController = TextEditingController();
  var giderAciklamaController = TextEditingController();
  var jobDescController = TextEditingController();
  var jobHeaderController = TextEditingController();
  var titleController = TextEditingController();
  var subTitleController = TextEditingController();
  bool isOpenCheckList = false;
  bool isAddingItem = false;
  List<String>? taskIDs;
  Map<String, bool>? personIDs;
  List<Task>? taskList;

  @override
  void initState() {
    super.initState();
    basTarihiController.text = widget.job.baslangicTarihi ?? "";
    btsTarihiController.text = widget.job.bitisTarihi ?? "";
    gelirController.text = "${widget.job.gelir}";
    gelirAciklamaController.text = widget.job.gelirAciklama ?? "";
    giderController.text = "${widget.job.gider}";
    giderAciklamaController.text = widget.job.giderAciklama ?? "";
    jobDescController.text = widget.job.jobDesc ?? "";
    jobHeaderController.text = widget.job.jobHead;
    titleController.text = "Liste";

    var taskListCubit = context.read<TaskListCubit>();
    taskListCubit.getTaskList(widget.job.jobID);
    taskList = taskListCubit.state;

    if (taskList != null) {
      isOpenCheckList = true;
      isAddingItem = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                print("${widget.job.state} in state");
                await TodoUpdateCubit().jobUpdate(widget.job.jobID,
                    jobHeaderController.text, widget.job.state,
                    baslangicTarihi: basTarihiController.text,
                    bitisTarihi: btsTarihiController.text,
                    gelir: gelirController.text.isNotEmpty
                        ? double.tryParse(gelirController.text) ?? 0.0
                        : 0.0,
                    gider: giderController.text.isNotEmpty
                        ? double.tryParse(giderController.text) ?? 0.0
                        : 0.0,
                    gelirAciklama: gelirAciklamaController.text,
                    giderAciklama: giderAciklamaController.text,
                    jobDesc: jobDescController.text,
                    personIDs: personIDs);
                Navigator.pop(context);
              },
              child: const Text(
                "Guncelle",
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: TextField(
                controller: jobHeaderController,
                maxLength: 30,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Kart Adı",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 13),
              width: width,
              child: TextField(
                controller: jobDescController,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  filled: true,
                  prefixIcon: Icon(
                    Icons.view_headline_outlined,
                  ),
                  hintText: "Açıklama Ekleyin",
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                    child: TextField(
                      controller: basTarihiController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Başlangıç Tarihi",
                        prefixIcon: Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050));
                        if (date != null) {
                          setState(() {
                            basTarihiController.text =
                                date.toString().split(" ")[0];
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: TextField(
                      controller: btsTarihiController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Bitiş Tarihi",
                        prefixIcon: Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050));
                        if (date != null) {
                          setState(() {
                            btsTarihiController.text =
                                date.toString().split(" ")[0];
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: TextField(
                      controller: gelirController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Gelir",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: TextField(
                      controller: gelirAciklamaController,
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Açıklama",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: TextField(
                      controller: giderController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Gider",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: TextField(
                      controller: giderAciklamaController,
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Açıklama",
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                personIDs = await UserListToTask()
                    .showPerson(context, widget.job.jobID, widget.job.dep_id!);
                print("Control Log $personIDs");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                    width: width,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).colorScheme.surface,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.person_outline_sharp,
                            size: 40,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Üyeler",
                            locale: Locale("TR"),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: width,
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.check_box_outlined,
                              size: 35,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Yapılacaklar Listeleri",
                                locale: const Locale("TR"),
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isOpenCheckList = true;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isOpenCheckList == true
                        ? Container(
                            width: width,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Container(
                                          width: width * 0.7,
                                          height: 40,
                                          child: CustomCheckList(
                                              titleController,
                                              widget.job.jobID)),
                                    ),
                                    Container(
                                      width: width * 0.2,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isAddingItem = !isAddingItem;
                                            });
                                          },
                                          icon: isAddingItem == true
                                              ? const Icon(
                                                  Icons.keyboard_arrow_up_sharp,
                                                  size: 35,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                  size: 35,
                                                )),
                                    ),
                                  ],
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: isAddingItem
                                      ? SizedBox(
                                          key: const ValueKey("inputOpen"),
                                          width: width,
                                          child: TaskListWidget(
                                              jobID: widget.job.jobID,
                                              titleText: titleController.text
                                          ),
                                  )
                                      : const SizedBox.shrink(
                                          key: ValueKey("inputClosed")),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
