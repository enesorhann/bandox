import 'package:dep_manager_panel/data/cubit/taskCubit/TaskListCubit.dart';
import 'package:dep_manager_panel/data/cubit/todo_cubit/ToDoInsertCubit.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/CheckList.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/TaskListWidget.dart';
import 'package:dep_manager_panel/views/ManagerPages/UserActions/ToDoViews/UserListToTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoRegistration extends StatefulWidget {
  final String dep_id;
  final String header;
  final int job_state;

  const ToDoRegistration(this.dep_id, this.header, this.job_state, {super.key});

  @override
  State<ToDoRegistration> createState() => _ToDoRegistrationState();
}

class _ToDoRegistrationState extends State<ToDoRegistration> {
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
  String? jobID = "";

  @override
  void initState() {
    super.initState();
    jobHeaderController.text = widget.header;
    titleController.text = "Liste";
    jobID = "${widget.dep_id}_${DateTime.now().millisecondsSinceEpoch}";
    context.read<TaskListCubit>().getTaskList(jobID);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

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
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _width,
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
              width: _width,
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
              width: _width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _width,
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
                    width: _width,
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
              width: _width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _width * 0.45,
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
                    width: _width * 0.45,
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
              width: _width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _width * 0.45,
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
                    width: _width * 0.45,
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
                //jobID kisminda headeri sil timestamp ile tut orayı
                print("JOBID ->  $jobID");
                if (jobID != null) {
                  await TodoInsertCubit().jobInsert(widget.dep_id,
                      jobHeaderController.text, widget.job_state);
                  personIDs = await UserListToTask()
                      .showPerson(context, jobID!, widget.dep_id);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                    width: _width,
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
                width: _width,
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
                            width: _width,
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
                                          width: _width * 0.7,
                                          height: 40,
                                          child: CustomCheckList(
                                              titleController, jobID!)),
                                    ),
                                    Container(
                                      width: _width * 0.2,
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
                                          width: _width,
                                          child: TaskListWidget(
                                              jobID: jobID!,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(widget.job_state);
          await TodoInsertCubit().jobInsert(
            widget.dep_id,
            jobHeaderController.text,
            widget.job_state,
            baslangicTarihi: basTarihiController.text,
            bitisTarihi: btsTarihiController.text,
            gelir: gelirController.text.isNotEmpty
                ? double.parse(gelirController.text)
                : 0.0,
            gider: giderController.text.isNotEmpty
                ? double.parse(giderController.text)
                : 0.0,
            gelirAciklama: gelirAciklamaController.text,
            giderAciklama: giderAciklamaController.text,
            jobDesc: jobDescController.text,
            personIDs: personIDs,
          );
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.save_outlined,
          size: 44,
        ),
        label: const Text(
          "Kaydet",
        ),
      ),
    );
  }
}
