import 'package:dep_manager_panel/data/cubit/todo_cubit/GetUserWithAssignment.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:dep_manager_panel/data/entities/ToDo/ToDo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/entities/Users/Users.dart';

class PersonBottomSheet extends StatefulWidget {
  final String jobID;
  final String depID;

  PersonBottomSheet({required this.jobID, super.key, required this.depID});

  @override
  State<PersonBottomSheet> createState() => _PersonBottomSheetState();
}

class _PersonBottomSheetState extends State<PersonBottomSheet> {
  final _checkBoxState = <String, bool>{};
  late Map<String, bool> personIDs;
  late ToDo currentJob;

  @override
  void initState() {
    super.initState();
    context
        .read<GetUserWithAssignment>()
        .oneJobOfTheDepartmentWithGet(widget.jobID);
    context
        .read<UsersListCubit>()
        .birKezDepartmandakiKullanicilar(widget.depID);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        Navigator.pop(context, _checkBoxState);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black45.withValues(alpha: 3.5),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(
              width: width,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Üyeler",
                locale: Locale("TR"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            BlocBuilder<GetUserWithAssignment, Map<String, bool>>(
              builder: (context, personMap) {
                print("PersonMap Values -> ${personMap.values}");
                return BlocBuilder<UsersListCubit, List<Users>>(
                  builder: (context, userList) {
                    print("UserList Length -> ${userList.length}");
                    if (userList.isNotEmpty) {
                      if (_checkBoxState.isEmpty) {
                        for (var user in userList) {
                          var isAssigned = personMap[user.userID] ?? false;
                          _checkBoxState.putIfAbsent(
                              user.userID!, () => isAssigned);
                        }
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            var user = userList[index];
                            var url = user.faceOfUser;
                            // böylelikle daha modüler oldu karmaşık sorgulardan kurtulduk

                            return GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,

                                child: Card(
                                  color: Colors.white24,
                                  child: SizedBox(
                                    height: 75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: url != null
                                                  ? Image.network(url)
                                                  : Image.asset(
                                                      "images/images.png")),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${user.userFname} ${user.userLname}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 70,
                                            ),
                                            StatefulBuilder(
                                              builder: (context, setState) {
                                                return Checkbox(
                                                    side: const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    activeColor: Colors.green,
                                                    value: _checkBoxState[
                                                            user.userID] ??
                                                        false,
                                                    onChanged:
                                                        (bool? newValue) async {
                                                      if (newValue != null) {
                                                        setState(() {
                                                          _checkBoxState[user
                                                                  .userID!] =
                                                              newValue;
                                                        });
                                                      }
                                                    });
                                              },
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
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text(
                              "Bu departmanda kullanici bulunamadi,görev atayabilmeniz icin kullanici eklemeniz gerekmektedir!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
